import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../theme/app_tokens.dart';

/// Branded launch splash, drawn in Flutter so the ermine shows uncut (the
/// native Android-12 splash masks its icon to a circle) with the app name
/// directly beneath it.
///
/// Wraps the app's [child] (the router's navigator) and paints a full-screen
/// overlay on top at cold start, then fades it out. The overlay uses the same
/// page colour as the native splash background, so the native → Flutter handoff
/// is seamless.
class AppSplash extends StatefulWidget {
  const AppSplash({super.key, required this.child});

  final Widget child;

  /// How long the splash stays fully opaque before fading out. Timed from the
  /// first rendered frame (see [initState]) so it can't elapse behind a slow
  /// native splash.
  static const _hold = Duration(milliseconds: 1600);
  static const _fade = Duration(milliseconds: 450);

  @override
  State<AppSplash> createState() => _AppSplashState();
}

class _AppSplashState extends State<AppSplash> {
  bool _opaque = true; // overlay visible
  bool _present = true; // overlay still in the tree (removed after the fade)

  @override
  void initState() {
    super.initState();
    // Start the hold only once the first frame is on screen — otherwise, on a
    // slow (debug) launch the timer runs out while the native splash is still
    // covering us, and the Flutter splash is never actually seen.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(AppSplash._hold, () {
        if (mounted) setState(() => _opaque = false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_present)
          Positioned.fill(
            child: IgnorePointer(
              ignoring: !_opaque,
              child: AnimatedOpacity(
                opacity: _opaque ? 1 : 0,
                duration: AppSplash._fade,
                curve: Curves.easeOut,
                onEnd: () {
                  if (!_opaque && mounted) setState(() => _present = false);
                },
                child: const _SplashContent(),
              ),
            ),
          ),
      ],
    );
  }
}

class _SplashContent extends StatelessWidget {
  const _SplashContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ColoredBox(
      color: theme.colorScheme.surface,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/icon/ermine_logo.png',
              height: 140,
              semanticLabel: AppConstants.appName,
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(AppConstants.appName, style: theme.textTheme.displaySmall),
          ],
        ),
      ),
    );
  }
}
