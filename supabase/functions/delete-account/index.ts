// Edge function: delete-account
//
// Immediate, irreversible self-deletion of the CALLING user's account.
//
// Security model:
//  - The caller proves who they are with their own Supabase JWT (the
//    Authorization: Bearer <access_token> header the client automatically
//    attaches when it calls `functions.invoke`). We resolve that token to a
//    real auth user with the ANON key — a user client — and delete only that
//    user's data. We NEVER accept a user id from the request body, so a caller
//    can only ever delete themselves.
//  - Row deletion and the auth-user deletion use the SERVICE ROLE key, which
//    is read from the function's environment (SUPABASE_SERVICE_ROLE_KEY) and
//    only ever exists here, server-side. It is never sent to the client.
//
// What gets deleted (all scoped to the authenticated user's id):
//   friend_requests (either direction), friendships (either side),
//   memorized_words, the profiles row, then the auth.users record itself.
//
// The foreign keys already cascade (profiles -> memorized_words /
// friend_requests / friendships, and auth.users -> profiles), so deleting the
// auth user alone would remove everything. We still delete each table
// explicitly first so the deletion is self-describing and does not silently
// depend on the cascade wiring — and so a future non-cascading table is caught
// here rather than orphaned.

import { createClient } from 'jsr:@supabase/supabase-js@2';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers':
    'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
};

function json(body: unknown, status: number): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
  });
}

Deno.serve(async (req) => {
  // CORS preflight.
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }
  if (req.method !== 'POST') {
    return json({ error: 'Method not allowed' }, 405);
  }

  const supabaseUrl = Deno.env.get('SUPABASE_URL');
  const anonKey = Deno.env.get('SUPABASE_ANON_KEY');
  const serviceRoleKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');
  if (!supabaseUrl || !anonKey || !serviceRoleKey) {
    return json({ error: 'Function is not configured' }, 500);
  }

  // The caller's own JWT. Without it we cannot identify (and therefore cannot
  // self-delete) anyone.
  const authHeader = req.headers.get('Authorization');
  if (!authHeader) {
    return json({ error: 'Missing Authorization header' }, 401);
  }

  // Resolve the token to a user with the ANON key — this validates the JWT and
  // yields the caller's id. This is the ONLY source of the id we delete.
  const userClient = createClient(supabaseUrl, anonKey, {
    global: { headers: { Authorization: authHeader } },
    auth: { persistSession: false, autoRefreshToken: false },
  });

  const { data: userData, error: userError } = await userClient.auth.getUser();
  if (userError || !userData?.user) {
    return json({ error: 'Invalid or expired session' }, 401);
  }
  const userId = userData.user.id;

  // Service-role client: bypasses RLS to remove every row + the auth user.
  const admin = createClient(supabaseUrl, serviceRoleKey, {
    auth: { persistSession: false, autoRefreshToken: false },
  });

  try {
    // 1. Friend requests in either direction.
    const { error: reqErr } = await admin
      .from('friend_requests')
      .delete()
      .or(`from_user.eq.${userId},to_user.eq.${userId}`);
    if (reqErr) throw reqErr;

    // 2. Friendships on either side.
    const { error: friErr } = await admin
      .from('friendships')
      .delete()
      .or(`user_a.eq.${userId},user_b.eq.${userId}`);
    if (friErr) throw friErr;

    // 3. Memorized words.
    const { error: wordsErr } = await admin
      .from('memorized_words')
      .delete()
      .eq('user_id', userId);
    if (wordsErr) throw wordsErr;

    // 4. The profile row.
    const { error: profErr } = await admin
      .from('profiles')
      .delete()
      .eq('id', userId);
    if (profErr) throw profErr;

    // 5. Finally the auth user itself (Admin API, service role only).
    const { error: authErr } = await admin.auth.admin.deleteUser(userId);
    if (authErr) throw authErr;

    return json({ success: true }, 200);
  } catch (error) {
    console.error('delete-account failed for user', userId, error);
    return json({ error: 'Deletion failed' }, 500);
  }
});
