// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get navHome => 'Accueil';

  @override
  String get navWords => 'Mots';

  @override
  String get navFriends => 'Amis';

  @override
  String get navProfile => 'Profil';

  @override
  String get cancel => 'Annuler';

  @override
  String get confirm => 'Confirmer';

  @override
  String get back => 'Retour';

  @override
  String get next => 'Suivant';

  @override
  String get finish => 'Terminer';

  @override
  String get retry => 'Réessayer';

  @override
  String get logIn => 'Se connecter';

  @override
  String get signUp => 'S’inscrire';

  @override
  String get authCreateAccount => 'Crée ton compte';

  @override
  String get authWelcomeBack => 'Bon retour';

  @override
  String get authRegisterSubtitle =>
      'Inscris-toi pour enregistrer ta progression dans le cloud et la retrouver sur tous tes appareils.';

  @override
  String get authLoginSubtitle => 'Connecte-toi pour retrouver ta progression.';

  @override
  String get authContinueGoogle => 'Continuer avec Google';

  @override
  String get authContinueApple => 'Continuer avec Apple';

  @override
  String get authOrWithEmail => 'ou avec un e-mail';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get authSwitchToLogin => 'Tu as déjà un compte ? Connecte-toi';

  @override
  String get authSwitchToRegister => 'Tu n’as pas de compte ? Inscris-toi';

  @override
  String get authEnterEmailPassword => 'Saisis ton e-mail et ton mot de passe.';

  @override
  String get authSignupPending =>
      'Inscription lancée : confirme ton e-mail, puis connecte-toi avec tes identifiants.';

  @override
  String get authGenericError => 'Un problème est survenu. Réessaie.';

  @override
  String get authNotConfigured =>
      'La synchronisation cloud n’est pas configurée dans cette version.\nVoir SUPABASE_SETUP.md.';

  @override
  String get nicknameTakenTitle => 'Pseudo déjà utilisé';

  @override
  String get nicknameTakenBody =>
      'Quelqu’un d’autre a déjà choisi ce pseudo. Choisis-en un autre :';

  @override
  String get nicknameLabel => 'Pseudo';

  @override
  String get nicknamePrompt => 'Comment veux-tu qu’on t’appelle ?';

  @override
  String get nicknameLengthError => 'Doit contenir entre 3 et 20 caractères';

  @override
  String get avatarPrompt => 'Choisis ton avatar';

  @override
  String get dailyGoalPrompt => 'Combien de mots par jour ?';

  @override
  String languagesLoadError(Object error) {
    return 'Erreur lors du chargement des langues :\n$error';
  }

  @override
  String get noLanguagesAvailable => 'Aucune langue disponible.';

  @override
  String get pickSourceLanguage => 'De quelle langue veux-tu partir ?';

  @override
  String get pickTargetLanguage => 'Quelle langue veux-tu apprendre ?';

  @override
  String levelsLoadError(Object error) {
    return 'Erreur lors du chargement des niveaux :\n$error';
  }

  @override
  String completeLevelFirst(int level) {
    return 'Termine d’abord le niveau $level';
  }

  @override
  String levelLockedSemantic(int level) {
    return 'Niveau $level, verrouillé';
  }

  @override
  String levelProgressSemantic(int level, int memorized, int total) {
    return 'Niveau $level, $memorized sur $total mots';
  }

  @override
  String get profileTitle => 'Profil';

  @override
  String get noProfileYet => 'Pas encore de profil.';

  @override
  String memorizedWordsCount(int count) {
    return 'Mots mémorisés : $count';
  }

  @override
  String currentLevelLabel(int level) {
    return 'Niveau actuel : $level';
  }

  @override
  String get languageTileTitle => 'Langue';

  @override
  String get account => 'Compte';

  @override
  String get accountLinked => 'Compte lié';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get deleteAccount => 'Supprimer le compte';

  @override
  String get deleteAccountSubtitle =>
      'Supprime définitivement ton compte et toutes les données.';

  @override
  String get signOutConfirmTitle => 'Se déconnecter du compte ?';

  @override
  String get signOutConfirmBody =>
      'Les données de cet appareil seront supprimées. Ta progression reste en sécurité dans le cloud et est restaurée à ta prochaine connexion.';

  @override
  String get deleteAccountConfirmTitle => 'Supprimer ton compte ?';

  @override
  String get deleteAccountConfirmBody =>
      'Cette action est immédiate et irréversible. Ton compte, ta progression et toutes les données associées seront définitivement supprimés du cloud et de cet appareil. Impossible d’annuler ou de récupérer les données.';

  @override
  String get deleteAccountConfirmButton => 'Supprimer définitivement';

  @override
  String get todayLabel => 'Aujourd’hui';

  @override
  String todaySummary(int count, int goal, int streak) {
    String _temp0 = intl.Intl.pluralLogic(
      streak,
      locale: localeName,
      other: '$streak jours',
      one: '$streak jour',
    );
    return '$count/$goal mots aujourd’hui · 🔥 série de $_temp0';
  }

  @override
  String get goalReached => 'Objectif atteint ! 🎉';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get dailyGoalLabel => 'Objectif quotidien';

  @override
  String goalWordsSegment(int goal) {
    return '$goal mots';
  }

  @override
  String get reminderTitle => 'Rappel quotidien';

  @override
  String get appLanguageTitle => 'Langue de l’application';

  @override
  String get systemDefaultLanguage => 'Par défaut du système';

  @override
  String flashcardsTitle(int level) {
    return 'Cartes · Niveau $level';
  }

  @override
  String wordsLoadError(Object error) {
    return 'Erreur lors du chargement des mots :\n$error';
  }

  @override
  String get noWordsInLevel => 'Aucun mot dans ce niveau.';

  @override
  String get flashcardsOrdered => 'Dans l’ordre';

  @override
  String get flashcardsOrderedSubtitle =>
      'Pour apprendre les mots la première fois';

  @override
  String get flashcardsRandom => 'Aléatoire';

  @override
  String get flashcardsRandomSubtitle => 'Pour réviser dans le désordre';

  @override
  String get flashcardPrevious => 'Précédent';

  @override
  String get flashcardNext => 'Suivant';

  @override
  String get tapToReturn => 'Touche pour revenir';

  @override
  String get tapForTranslation => 'Touche pour la traduction';

  @override
  String testTitle(int level) {
    return 'Test · Niveau $level';
  }

  @override
  String testLoadError(Object error) {
    return 'Erreur lors du chargement du test :\n$error';
  }

  @override
  String get answerWrong => 'Faux';

  @override
  String get correctAnswerPrefix => 'Bonne réponse : ';

  @override
  String get check => 'Vérifier';

  @override
  String get answerCorrect => 'Correct';

  @override
  String get testCompleted => 'Test terminé !';

  @override
  String testScore(int correct, int total) {
    return '$correct mots mémorisés sur $total.';
  }

  @override
  String get retryRemaining => 'Réessaie les mots restants';

  @override
  String get backToLevel => 'Retour au niveau';

  @override
  String get levelCompleted => 'Niveau terminé !';

  @override
  String get allWordsMemorized =>
      'Tu as déjà mémorisé tous les mots de ce niveau.';

  @override
  String usageTitle(int level) {
    return 'Usage · Niveau $level';
  }

  @override
  String get yourSentences => 'Tes phrases';

  @override
  String loadErrorGeneric(Object error) {
    return 'Erreur de chargement :\n$error';
  }

  @override
  String get sentenceSaved => 'Phrase enregistrée !';

  @override
  String get writeSentenceHint => 'Écris une phrase avec ce mot…';

  @override
  String get done => 'Terminé';

  @override
  String get anotherWord => 'Un autre mot';

  @override
  String get noMemorizedInLevel =>
      'Aucun mot mémorisé dans ce niveau.\nTermine d’abord un test pour débloquer l’exercice d’usage.';

  @override
  String get noSentencesYet =>
      'Pas encore de phrase.\nÉcris-en une dans l’exercice d’usage !';

  @override
  String wordNumber(int id) {
    return 'Mot n° $id';
  }

  @override
  String get knownWordsTitle => 'Mots connus';

  @override
  String knownWordsTitleLevel(int level) {
    return 'Mots connus · Niveau $level';
  }

  @override
  String get searchWordHint => 'Cherche un mot…';

  @override
  String knownWordsCount(int count) {
    return '$count mots connus';
  }

  @override
  String knownWordsFiltered(int visible, int total) {
    return '$visible sur $total mots';
  }

  @override
  String levelAbbr(int level) {
    return 'Niv. $level';
  }

  @override
  String get noWordsMemorizedYet =>
      'Aucun mot mémorisé pour l’instant.\nRéussis les tests pour remplir cette liste !';

  @override
  String levelTitle(int level) {
    return 'Niveau $level';
  }

  @override
  String get level => 'NIVEAU';

  @override
  String levelLoadError(Object error) {
    return 'Erreur lors du chargement du niveau :\n$error';
  }

  @override
  String get modeFlashcardsTitle => 'Cartes';

  @override
  String get modeFlashcardsSubtitle => 'Apprends les mots avec des cartes';

  @override
  String get modeTestTitle => 'Test';

  @override
  String get modeTestSubtitle => 'Mets-toi à l’épreuve';

  @override
  String get modeUsageTitle => 'Usage';

  @override
  String get modeUsageSubtitle => 'Les mots dans des phrases';

  @override
  String get modeKnownSubtitle => 'Les mots mémorisés de ce niveau';

  @override
  String get memorizedWordsCaption => 'mots mémorisés';

  @override
  String requestSentTo(Object nickname) {
    return 'Demande envoyée à $nickname';
  }

  @override
  String nowFriendsWith(Object nickname) {
    return 'Toi et $nickname êtes maintenant amis !';
  }

  @override
  String get requestRejected => 'Demande refusée';

  @override
  String get searchByNickname => 'Rechercher par pseudo';

  @override
  String get receivedRequests => 'Demandes reçues';

  @override
  String get wantsToBeFriend => 'Veut devenir ton ami';

  @override
  String get accept => 'Accepter';

  @override
  String get reject => 'Refuser';

  @override
  String get yourFriends => 'Tes amis';

  @override
  String get signInToFindFriends =>
      'Connecte-toi pour trouver tes amis\net comparer vos progressions.';

  @override
  String get noUsersFound => 'Aucun utilisateur trouvé.';

  @override
  String get alreadyFriends => 'Déjà amis';

  @override
  String get requestSentLabel => 'Demande envoyée';

  @override
  String get add => 'Ajouter';

  @override
  String friendSummary(Object pair, int level, int count) {
    return '$pair · Niveau $level · $count mots mémorisés';
  }

  @override
  String get noFriendsYet =>
      'Pas encore d’amis. Recherche un pseudo ci-dessus pour envoyer ta première demande.';

  @override
  String get errorNetwork =>
      'Impossible de contacter le serveur. Vérifie ta connexion et réessaie.';

  @override
  String get errorSession => 'Session expirée ou non valide. Reconnecte-toi.';

  @override
  String get errorGeneric => 'Une erreur est survenue. Réessaie.';
}
