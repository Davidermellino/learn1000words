// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get navHome => 'Inicio';

  @override
  String get navWords => 'Palabras';

  @override
  String get navFriends => 'Amigos';

  @override
  String get navProfile => 'Perfil';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get back => 'Atrás';

  @override
  String get next => 'Siguiente';

  @override
  String get finish => 'Finalizar';

  @override
  String get retry => 'Reintentar';

  @override
  String get logIn => 'Iniciar sesión';

  @override
  String get signUp => 'Registrarse';

  @override
  String get authCreateAccount => 'Crea tu cuenta';

  @override
  String get authWelcomeBack => 'Bienvenido de nuevo';

  @override
  String get authRegisterSubtitle =>
      'Regístrate para guardar tu progreso en la nube y recuperarlo en cualquier dispositivo.';

  @override
  String get authLoginSubtitle => 'Inicia sesión para recuperar tu progreso.';

  @override
  String get authContinueGoogle => 'Continuar con Google';

  @override
  String get authContinueApple => 'Continuar con Apple';

  @override
  String get authOrWithEmail => 'o con correo electrónico';

  @override
  String get emailLabel => 'Correo electrónico';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get authSwitchToLogin => '¿Ya tienes una cuenta? Inicia sesión';

  @override
  String get authSwitchToRegister => '¿No tienes una cuenta? Regístrate';

  @override
  String get authEnterEmailPassword => 'Introduce tu correo y contraseña.';

  @override
  String get authSignupPending =>
      'Registro iniciado: confirma tu correo y luego inicia sesión con tus credenciales.';

  @override
  String get authGenericError => 'Algo salió mal. Inténtalo de nuevo.';

  @override
  String get authNotConfigured =>
      'La sincronización en la nube no está configurada en esta versión.\nConsulta SUPABASE_SETUP.md.';

  @override
  String get nicknameTakenTitle => 'Apodo ya en uso';

  @override
  String get nicknameTakenBody =>
      'Otra persona ya ha elegido este apodo. Elige otro:';

  @override
  String get nicknameLabel => 'Apodo';

  @override
  String get nicknamePrompt => '¿Cómo quieres que te llamemos?';

  @override
  String get nicknameLengthError => 'Debe tener entre 3 y 20 caracteres';

  @override
  String get avatarPrompt => 'Elige tu avatar';

  @override
  String get dailyGoalPrompt => '¿Cuántas palabras al día?';

  @override
  String languagesLoadError(Object error) {
    return 'Error al cargar los idiomas:\n$error';
  }

  @override
  String get noLanguagesAvailable => 'No hay idiomas disponibles.';

  @override
  String get pickSourceLanguage => '¿Desde qué idioma quieres empezar?';

  @override
  String get pickTargetLanguage => '¿Qué idioma quieres aprender?';

  @override
  String levelsLoadError(Object error) {
    return 'Error al cargar los niveles:\n$error';
  }

  @override
  String completeLevelFirst(int level) {
    return 'Completa antes el nivel $level';
  }

  @override
  String levelLockedSemantic(int level) {
    return 'Nivel $level, bloqueado';
  }

  @override
  String levelProgressSemantic(int level, int memorized, int total) {
    return 'Nivel $level, $memorized de $total palabras';
  }

  @override
  String get profileTitle => 'Perfil';

  @override
  String get noProfileYet => 'Aún no hay perfil.';

  @override
  String memorizedWordsCount(int count) {
    return 'Palabras memorizadas: $count';
  }

  @override
  String currentLevelLabel(int level) {
    return 'Nivel actual: $level';
  }

  @override
  String get languageTileTitle => 'Idioma';

  @override
  String get account => 'Cuenta';

  @override
  String get accountLinked => 'Cuenta vinculada';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get deleteAccount => 'Eliminar cuenta';

  @override
  String get deleteAccountSubtitle =>
      'Elimina permanentemente tu cuenta y todos los datos.';

  @override
  String get signOutConfirmTitle => '¿Cerrar sesión de tu cuenta?';

  @override
  String get signOutConfirmBody =>
      'Se eliminarán los datos de este dispositivo. Tu progreso permanece a salvo en la nube y se restaura la próxima vez que inicies sesión.';

  @override
  String get deleteAccountConfirmTitle => '¿Eliminar tu cuenta?';

  @override
  String get deleteAccountConfirmBody =>
      'Esta acción es inmediata e irreversible. Tu cuenta, tu progreso y todos los datos asociados se eliminarán de forma permanente de la nube y de este dispositivo. No se puede deshacer ni recuperar.';

  @override
  String get deleteAccountConfirmButton => 'Eliminar permanentemente';

  @override
  String get todayLabel => 'Hoy';

  @override
  String todaySummary(int count, int goal, int streak) {
    String _temp0 = intl.Intl.pluralLogic(
      streak,
      locale: localeName,
      other: '$streak días',
      one: '$streak día',
    );
    return '$count/$goal palabras hoy · 🔥 racha de $_temp0';
  }

  @override
  String get goalReached => '¡Objetivo alcanzado! 🎉';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get dailyGoalLabel => 'Objetivo diario';

  @override
  String goalWordsSegment(int goal) {
    return '$goal palabras';
  }

  @override
  String get reminderTitle => 'Recordatorio diario';

  @override
  String get appLanguageTitle => 'Idioma de la aplicación';

  @override
  String get systemDefaultLanguage => 'Predeterminado del sistema';

  @override
  String flashcardsTitle(int level) {
    return 'Tarjetas · Nivel $level';
  }

  @override
  String wordsLoadError(Object error) {
    return 'Error al cargar las palabras:\n$error';
  }

  @override
  String get noWordsInLevel => 'No hay palabras en este nivel.';

  @override
  String get flashcardsOrdered => 'En orden';

  @override
  String get flashcardsOrderedSubtitle =>
      'Para aprender las palabras por primera vez';

  @override
  String get flashcardsRandom => 'Aleatorio';

  @override
  String get flashcardsRandomSubtitle => 'Para repasar en orden aleatorio';

  @override
  String get flashcardPrevious => 'Anterior';

  @override
  String get flashcardNext => 'Siguiente';

  @override
  String get tapToReturn => 'Toca para volver';

  @override
  String get tapForTranslation => 'Toca para ver la traducción';

  @override
  String testTitle(int level) {
    return 'Prueba · Nivel $level';
  }

  @override
  String testLoadError(Object error) {
    return 'Error al cargar la prueba:\n$error';
  }

  @override
  String get answerWrong => 'Incorrecto';

  @override
  String get correctAnswerPrefix => 'Respuesta correcta: ';

  @override
  String get check => 'Comprobar';

  @override
  String get answerCorrect => 'Correcto';

  @override
  String get testCompleted => '¡Prueba completada!';

  @override
  String testScore(int correct, int total) {
    return '$correct de $total palabras memorizadas.';
  }

  @override
  String get retryRemaining => 'Reintenta las palabras restantes';

  @override
  String get backToLevel => 'Volver al nivel';

  @override
  String get levelCompleted => '¡Nivel completado!';

  @override
  String get allWordsMemorized =>
      'Ya has memorizado todas las palabras de este nivel.';

  @override
  String usageTitle(int level) {
    return 'Uso · Nivel $level';
  }

  @override
  String get yourSentences => 'Tus frases';

  @override
  String loadErrorGeneric(Object error) {
    return 'Error al cargar:\n$error';
  }

  @override
  String get sentenceSaved => '¡Frase guardada!';

  @override
  String get writeSentenceHint => 'Escribe una frase con esta palabra…';

  @override
  String get done => 'Hecho';

  @override
  String get anotherWord => 'Otra palabra';

  @override
  String get noMemorizedInLevel =>
      'No hay palabras memorizadas en este nivel.\nCompleta primero una prueba para desbloquear el ejercicio de uso.';

  @override
  String get noSentencesYet =>
      'Aún no hay frases.\n¡Escribe una en el ejercicio de uso!';

  @override
  String wordNumber(int id) {
    return 'Palabra n.º $id';
  }

  @override
  String get knownWordsTitle => 'Palabras conocidas';

  @override
  String knownWordsTitleLevel(int level) {
    return 'Palabras conocidas · Nivel $level';
  }

  @override
  String get searchWordHint => 'Busca una palabra…';

  @override
  String knownWordsCount(int count) {
    return '$count palabras conocidas';
  }

  @override
  String knownWordsFiltered(int visible, int total) {
    return '$visible de $total palabras';
  }

  @override
  String levelAbbr(int level) {
    return 'Niv. $level';
  }

  @override
  String get noWordsMemorizedYet =>
      'Aún no has memorizado ninguna palabra.\n¡Aprueba las pruebas para llenar esta lista!';

  @override
  String levelTitle(int level) {
    return 'Nivel $level';
  }

  @override
  String get level => 'NIVEL';

  @override
  String levelLoadError(Object error) {
    return 'Error al cargar el nivel:\n$error';
  }

  @override
  String get modeFlashcardsTitle => 'Tarjetas';

  @override
  String get modeFlashcardsSubtitle => 'Aprende las palabras con tarjetas';

  @override
  String get modeTestTitle => 'Prueba';

  @override
  String get modeTestSubtitle => 'Ponte a prueba';

  @override
  String get modeUsageTitle => 'Uso';

  @override
  String get modeUsageSubtitle => 'Las palabras en frases';

  @override
  String get modeKnownSubtitle => 'Las palabras memorizadas de este nivel';

  @override
  String get memorizedWordsCaption => 'palabras memorizadas';

  @override
  String requestSentTo(Object nickname) {
    return 'Solicitud enviada a $nickname';
  }

  @override
  String nowFriendsWith(Object nickname) {
    return '¡Tú y $nickname ya sois amigos!';
  }

  @override
  String get requestRejected => 'Solicitud rechazada';

  @override
  String get searchByNickname => 'Buscar por apodo';

  @override
  String get receivedRequests => 'Solicitudes recibidas';

  @override
  String get wantsToBeFriend => 'Quiere ser tu amigo';

  @override
  String get accept => 'Aceptar';

  @override
  String get reject => 'Rechazar';

  @override
  String get yourFriends => 'Tus amigos';

  @override
  String get signInToFindFriends =>
      'Inicia sesión para encontrar a tus amigos\ny comparar vuestro progreso.';

  @override
  String get noUsersFound => 'No se encontraron usuarios.';

  @override
  String get alreadyFriends => 'Ya sois amigos';

  @override
  String get requestSentLabel => 'Solicitud enviada';

  @override
  String get add => 'Añadir';

  @override
  String friendSummary(Object pair, int level, int count) {
    return '$pair · Nivel $level · $count palabras memorizadas';
  }

  @override
  String get noFriendsYet =>
      'Aún no tienes amigos. Busca un apodo arriba para enviar tu primera solicitud.';

  @override
  String get errorNetwork =>
      'No se pudo contactar con el servidor. Comprueba tu conexión e inténtalo de nuevo.';

  @override
  String get errorSession =>
      'Sesión caducada o no válida. Inicia sesión de nuevo.';

  @override
  String get errorGeneric => 'Se ha producido un error. Inténtalo de nuevo.';
}
