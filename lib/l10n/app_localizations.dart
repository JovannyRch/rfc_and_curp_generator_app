import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'CURP & RFC Calculator'**
  String get appTitle;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @curpCalculator.
  ///
  /// In en, this message translates to:
  /// **'CURP Calculator'**
  String get curpCalculator;

  /// No description provided for @rfcCalculator.
  ///
  /// In en, this message translates to:
  /// **'RFC Calculator'**
  String get rfcCalculator;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @calculateCurp.
  ///
  /// In en, this message translates to:
  /// **'Calculate CURP'**
  String get calculateCurp;

  /// No description provided for @calculateRfc.
  ///
  /// In en, this message translates to:
  /// **'Calculate RFC'**
  String get calculateRfc;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @secondLastName.
  ///
  /// In en, this message translates to:
  /// **'Second Last Name'**
  String get secondLastName;

  /// No description provided for @birthDate.
  ///
  /// In en, this message translates to:
  /// **'Birth Date'**
  String get birthDate;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State of Birth'**
  String get state;

  /// No description provided for @calculate.
  ///
  /// In en, this message translates to:
  /// **'Calculate'**
  String get calculate;

  /// No description provided for @result.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get result;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard!'**
  String get copied;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'No calculation history yet'**
  String get noHistory;

  /// No description provided for @clearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear History'**
  String get clearHistory;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @removeAds.
  ///
  /// In en, this message translates to:
  /// **'Remove Ads'**
  String get removeAds;

  /// No description provided for @removeAdsDesc.
  ///
  /// In en, this message translates to:
  /// **'Remove advertisements from the app'**
  String get removeAdsDesc;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rateApp;

  /// No description provided for @rateAppDesc.
  ///
  /// In en, this message translates to:
  /// **'Rate us in the app store'**
  String get rateAppDesc;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @curpResult.
  ///
  /// In en, this message translates to:
  /// **'CURP Result'**
  String get curpResult;

  /// No description provided for @rfcResult.
  ///
  /// In en, this message translates to:
  /// **'RFC Result'**
  String get rfcResult;

  /// No description provided for @homeBadge.
  ///
  /// In en, this message translates to:
  /// **'Professional MVP'**
  String get homeBadge;

  /// No description provided for @homeTagline.
  ///
  /// In en, this message translates to:
  /// **'Fast bilingual estimates for CURP and RFC with private local history.'**
  String get homeTagline;

  /// No description provided for @homeMetricPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get homeMetricPrivacy;

  /// No description provided for @fast.
  ///
  /// In en, this message translates to:
  /// **'Fast'**
  String get fast;

  /// No description provided for @bilingual.
  ///
  /// In en, this message translates to:
  /// **'Bilingual'**
  String get bilingual;

  /// No description provided for @private.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get private;

  /// No description provided for @curpHeroDetail.
  ///
  /// In en, this message translates to:
  /// **'Build an approximate CURP using personal data, gender, and state of birth.'**
  String get curpHeroDetail;

  /// No description provided for @rfcHeroDetail.
  ///
  /// In en, this message translates to:
  /// **'Generate an approximate RFC key in seconds with a streamlined form.'**
  String get rfcHeroDetail;

  /// No description provided for @recentCalculations.
  ///
  /// In en, this message translates to:
  /// **'Recent calculations'**
  String get recentCalculations;

  /// No description provided for @noHistoryDescription.
  ///
  /// In en, this message translates to:
  /// **'Your recent CURP and RFC estimates will appear here once you start calculating.'**
  String get noHistoryDescription;

  /// No description provided for @settingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Language, appearance, premium controls, and review shortcuts.'**
  String get settingsSubtitle;

  /// No description provided for @historySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Saved calculations available offline'**
  String get historySubtitle;

  /// No description provided for @clearHistoryMessage.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete your local calculation history.'**
  String get clearHistoryMessage;

  /// No description provided for @premiumEnabled.
  ///
  /// In en, this message translates to:
  /// **'Ad-free placeholder enabled'**
  String get premiumEnabled;

  /// No description provided for @adsPlaceholderTitle.
  ///
  /// In en, this message translates to:
  /// **'Ad placement placeholder'**
  String get adsPlaceholderTitle;

  /// No description provided for @adsPlaceholderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This area is reserved for future AdMob integration after production IDs are configured.'**
  String get adsPlaceholderSubtitle;

  /// No description provided for @personalData.
  ///
  /// In en, this message translates to:
  /// **'Personal data'**
  String get personalData;

  /// No description provided for @approximateCalculation.
  ///
  /// In en, this message translates to:
  /// **'This is an approximate result and should be verified against official government records.'**
  String get approximateCalculation;

  /// No description provided for @enterFirstName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your first name'**
  String get enterFirstName;

  /// No description provided for @enterLastName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your last name'**
  String get enterLastName;

  /// No description provided for @enterSecondLastName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your second last name'**
  String get enterSecondLastName;

  /// No description provided for @selectBirthDate.
  ///
  /// In en, this message translates to:
  /// **'Please select your birth date'**
  String get selectBirthDate;

  /// No description provided for @selectGender.
  ///
  /// In en, this message translates to:
  /// **'Please select your gender'**
  String get selectGender;

  /// No description provided for @selectState.
  ///
  /// In en, this message translates to:
  /// **'Please select your state of birth'**
  String get selectState;

  /// No description provided for @calculationSaved.
  ///
  /// In en, this message translates to:
  /// **'Calculation saved to history'**
  String get calculationSaved;

  /// No description provided for @historyCleared.
  ///
  /// In en, this message translates to:
  /// **'History cleared'**
  String get historyCleared;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
