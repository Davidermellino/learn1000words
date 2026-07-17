// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get navHome => 'Início';

  @override
  String get navWords => 'Palavras';

  @override
  String get navFriends => 'Amigos';

  @override
  String get navProfile => 'Perfil';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get back => 'Voltar';

  @override
  String get next => 'Seguinte';

  @override
  String get finish => 'Concluir';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get logIn => 'Iniciar sessão';

  @override
  String get signUp => 'Registar';

  @override
  String get authCreateAccount => 'Cria a tua conta';

  @override
  String get authWelcomeBack => 'Bem-vindo de volta';

  @override
  String get authRegisterSubtitle =>
      'Regista-te para guardar o teu progresso na nuvem e recuperá-lo em qualquer dispositivo.';

  @override
  String get authLoginSubtitle =>
      'Inicia sessão para recuperar o teu progresso.';

  @override
  String get authContinueGoogle => 'Continuar com o Google';

  @override
  String get authContinueApple => 'Continuar com a Apple';

  @override
  String get authOrWithEmail => 'ou com e-mail';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get passwordLabel => 'Palavra-passe';

  @override
  String get authSwitchToLogin => 'Já tens uma conta? Inicia sessão';

  @override
  String get authSwitchToRegister => 'Não tens uma conta? Regista-te';

  @override
  String get authEnterEmailPassword => 'Introduz o teu e-mail e palavra-passe.';

  @override
  String get authSignupPending =>
      'Registo iniciado: confirma o teu e-mail e depois inicia sessão com as tuas credenciais.';

  @override
  String get authGenericError => 'Algo correu mal. Tenta novamente.';

  @override
  String get authNotConfigured =>
      'A sincronização na nuvem não está configurada nesta versão.\nConsulta SUPABASE_SETUP.md.';

  @override
  String get nicknameTakenTitle => 'Alcunha já em uso';

  @override
  String get nicknameTakenBody =>
      'Outra pessoa já escolheu esta alcunha. Escolhe outra:';

  @override
  String get nicknameLabel => 'Alcunha';

  @override
  String get nicknamePrompt => 'Como queres que te chamemos?';

  @override
  String get nicknameLengthError => 'Deve ter entre 3 e 20 caracteres';

  @override
  String get avatarPrompt => 'Escolhe o teu avatar';

  @override
  String get dailyGoalPrompt => 'Quantas palavras por dia?';

  @override
  String languagesLoadError(Object error) {
    return 'Erro ao carregar os idiomas:\n$error';
  }

  @override
  String get noLanguagesAvailable => 'Nenhum idioma disponível.';

  @override
  String get pickSourceLanguage => 'A partir de que idioma queres começar?';

  @override
  String get pickTargetLanguage => 'Que idioma queres aprender?';

  @override
  String levelsLoadError(Object error) {
    return 'Erro ao carregar os níveis:\n$error';
  }

  @override
  String completeLevelFirst(int level) {
    return 'Conclui primeiro o nível $level';
  }

  @override
  String levelLockedSemantic(int level) {
    return 'Nível $level, bloqueado';
  }

  @override
  String levelProgressSemantic(int level, int memorized, int total) {
    return 'Nível $level, $memorized de $total palavras';
  }

  @override
  String get profileTitle => 'Perfil';

  @override
  String get noProfileYet => 'Ainda não há perfil.';

  @override
  String memorizedWordsCount(int count) {
    return 'Palavras memorizadas: $count';
  }

  @override
  String currentLevelLabel(int level) {
    return 'Nível atual: $level';
  }

  @override
  String get languageTileTitle => 'Idioma';

  @override
  String get account => 'Conta';

  @override
  String get accountLinked => 'Conta associada';

  @override
  String get signOut => 'Terminar sessão';

  @override
  String get deleteAccount => 'Eliminar conta';

  @override
  String get deleteAccountSubtitle =>
      'Remove definitivamente a tua conta e todos os dados.';

  @override
  String get signOutConfirmTitle => 'Terminar sessão da conta?';

  @override
  String get signOutConfirmBody =>
      'Os dados neste dispositivo serão removidos. O teu progresso permanece seguro na nuvem e é restaurado no próximo início de sessão.';

  @override
  String get deleteAccountConfirmTitle => 'Eliminar a tua conta?';

  @override
  String get deleteAccountConfirmBody =>
      'Esta ação é imediata e irreversível. A tua conta, o teu progresso e todos os dados associados serão eliminados definitivamente da nuvem e deste dispositivo. Não é possível anular nem recuperar os dados.';

  @override
  String get deleteAccountConfirmButton => 'Eliminar definitivamente';

  @override
  String get todayLabel => 'Hoje';

  @override
  String todaySummary(int count, int goal, int streak) {
    String _temp0 = intl.Intl.pluralLogic(
      streak,
      locale: localeName,
      other: '$streak dias',
      one: '$streak dia',
    );
    return '$count/$goal palavras hoje · 🔥 sequência de $_temp0';
  }

  @override
  String get goalReached => 'Objetivo alcançado! 🎉';

  @override
  String get settingsTitle => 'Definições';

  @override
  String get dailyGoalLabel => 'Objetivo diário';

  @override
  String goalWordsSegment(int goal) {
    return '$goal palavras';
  }

  @override
  String get reminderTitle => 'Lembrete diário';

  @override
  String get appLanguageTitle => 'Idioma da aplicação';

  @override
  String get systemDefaultLanguage => 'Predefinição do sistema';

  @override
  String flashcardsTitle(int level) {
    return 'Cartões · Nível $level';
  }

  @override
  String wordsLoadError(Object error) {
    return 'Erro ao carregar as palavras:\n$error';
  }

  @override
  String get noWordsInLevel => 'Nenhuma palavra neste nível.';

  @override
  String get flashcardsOrdered => 'Por ordem';

  @override
  String get flashcardsOrderedSubtitle =>
      'Para aprender as palavras pela primeira vez';

  @override
  String get flashcardsRandom => 'Aleatório';

  @override
  String get flashcardsRandomSubtitle => 'Para rever por ordem aleatória';

  @override
  String get flashcardPrevious => 'Anterior';

  @override
  String get flashcardNext => 'Seguinte';

  @override
  String get tapToReturn => 'Toca para voltar';

  @override
  String get tapForTranslation => 'Toca para ver a tradução';

  @override
  String testTitle(int level) {
    return 'Teste · Nível $level';
  }

  @override
  String testLoadError(Object error) {
    return 'Erro ao carregar o teste:\n$error';
  }

  @override
  String get answerWrong => 'Errado';

  @override
  String get correctAnswerPrefix => 'Resposta correta: ';

  @override
  String get check => 'Verificar';

  @override
  String get answerCorrect => 'Correto';

  @override
  String get testCompleted => 'Teste concluído!';

  @override
  String testScore(int correct, int total) {
    return '$correct de $total palavras memorizadas.';
  }

  @override
  String get retryRemaining => 'Repetir as palavras restantes';

  @override
  String get backToLevel => 'Voltar ao nível';

  @override
  String get levelCompleted => 'Nível concluído!';

  @override
  String get allWordsMemorized =>
      'Já memorizaste todas as palavras deste nível.';

  @override
  String usageTitle(int level) {
    return 'Uso · Nível $level';
  }

  @override
  String get yourSentences => 'As tuas frases';

  @override
  String loadErrorGeneric(Object error) {
    return 'Erro ao carregar:\n$error';
  }

  @override
  String get sentenceSaved => 'Frase guardada!';

  @override
  String get writeSentenceHint => 'Escreve uma frase com esta palavra…';

  @override
  String get done => 'Concluído';

  @override
  String get anotherWord => 'Outra palavra';

  @override
  String get noMemorizedInLevel =>
      'Nenhuma palavra memorizada neste nível.\nConclui primeiro um teste para desbloquear o exercício de uso.';

  @override
  String get noSentencesYet =>
      'Ainda não há frases.\nEscreve uma no exercício de uso!';

  @override
  String wordNumber(int id) {
    return 'Palavra n.º $id';
  }

  @override
  String get knownWordsTitle => 'Palavras conhecidas';

  @override
  String knownWordsTitleLevel(int level) {
    return 'Palavras conhecidas · Nível $level';
  }

  @override
  String get searchWordHint => 'Procura uma palavra…';

  @override
  String knownWordsCount(int count) {
    return '$count palavras conhecidas';
  }

  @override
  String knownWordsFiltered(int visible, int total) {
    return '$visible de $total palavras';
  }

  @override
  String levelAbbr(int level) {
    return 'Nív. $level';
  }

  @override
  String get noWordsMemorizedYet =>
      'Ainda não memorizaste nenhuma palavra.\nPassa nos testes para preencher esta lista!';

  @override
  String levelTitle(int level) {
    return 'Nível $level';
  }

  @override
  String get level => 'NÍVEL';

  @override
  String levelLoadError(Object error) {
    return 'Erro ao carregar o nível:\n$error';
  }

  @override
  String get modeFlashcardsTitle => 'Cartões';

  @override
  String get modeFlashcardsSubtitle => 'Aprende as palavras com cartões';

  @override
  String get modeTestTitle => 'Teste';

  @override
  String get modeTestSubtitle => 'Põe-te à prova';

  @override
  String get modeUsageTitle => 'Uso';

  @override
  String get modeUsageSubtitle => 'As palavras em frases';

  @override
  String get modeKnownSubtitle => 'As palavras memorizadas deste nível';

  @override
  String get memorizedWordsCaption => 'palavras memorizadas';

  @override
  String requestSentTo(Object nickname) {
    return 'Pedido enviado a $nickname';
  }

  @override
  String nowFriendsWith(Object nickname) {
    return 'Tu e $nickname são agora amigos!';
  }

  @override
  String get requestRejected => 'Pedido recusado';

  @override
  String get searchByNickname => 'Procurar por alcunha';

  @override
  String get receivedRequests => 'Pedidos recebidos';

  @override
  String get wantsToBeFriend => 'Quer ser teu amigo';

  @override
  String get accept => 'Aceitar';

  @override
  String get reject => 'Recusar';

  @override
  String get yourFriends => 'Os teus amigos';

  @override
  String get signInToFindFriends =>
      'Inicia sessão para encontrar os teus amigos\ne comparar o progresso.';

  @override
  String get noUsersFound => 'Nenhum utilizador encontrado.';

  @override
  String get alreadyFriends => 'Já são amigos';

  @override
  String get requestSentLabel => 'Pedido enviado';

  @override
  String get add => 'Adicionar';

  @override
  String friendSummary(Object pair, int level, int count) {
    return '$pair · Nível $level · $count palavras memorizadas';
  }

  @override
  String get noFriendsYet =>
      'Ainda não tens amigos. Procura uma alcunha acima para enviar o teu primeiro pedido.';

  @override
  String get errorNetwork =>
      'Não foi possível contactar o servidor. Verifica a tua ligação e tenta novamente.';

  @override
  String get errorSession =>
      'Sessão expirada ou inválida. Inicia sessão novamente.';

  @override
  String get errorGeneric => 'Ocorreu um erro. Tenta novamente.';
}
