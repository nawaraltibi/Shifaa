// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Your All-in-One Medical Center`
  String get onBoardingTitle1 {
    return Intl.message(
      'Your All-in-One Medical Center',
      name: 'onBoardingTitle1',
      desc: '',
      args: [],
    );
  }

  /// `Connect With Trusted Doctors`
  String get onBoardingTitle2 {
    return Intl.message(
      'Connect With Trusted Doctors',
      name: 'onBoardingTitle2',
      desc: '',
      args: [],
    );
  }

  /// `Your Health, Your Control`
  String get onBoardingTitle3 {
    return Intl.message(
      'Your Health, Your Control',
      name: 'onBoardingTitle3',
      desc: '',
      args: [],
    );
  }

  /// `Book appointments, view records, and track your health all in one app.`
  String get onBoardingSubtitle1 {
    return Intl.message(
      'Book appointments, view records, and track your health all in one app.',
      name: 'onBoardingSubtitle1',
      desc: '',
      args: [],
    );
  }

  /// `Choose from multiple specialists and manage your visits with ease.`
  String get onBoardingSubtitle2 {
    return Intl.message(
      'Choose from multiple specialists and manage your visits with ease.',
      name: 'onBoardingSubtitle2',
      desc: '',
      args: [],
    );
  }

  /// `Access your prescriptions, records, and updates securely in both Arabic and English.`
  String get onBoardingSubtitle3 {
    return Intl.message(
      'Access your prescriptions, records, and updates securely in both Arabic and English.',
      name: 'onBoardingSubtitle3',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to`
  String get welcome {
    return Intl.message(
      'Welcome to',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Shifaa!`
  String get Shifaa {
    return Intl.message(
      'Shifaa!',
      name: 'Shifaa',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get firstName {
    return Intl.message(
      'First Name',
      name: 'firstName',
      desc: '',
      args: [],
    );
  }

  /// `Last Name`
  String get lastName {
    return Intl.message(
      'Last Name',
      name: 'lastName',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get signup {
    return Intl.message(
      'Sign up',
      name: 'signup',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account? `
  String get haveAnAccount {
    return Intl.message(
      'Already have an account? ',
      name: 'haveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your first name`
  String get pleaseEnterFirstName {
    return Intl.message(
      'Please enter your first name',
      name: 'pleaseEnterFirstName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your last name`
  String get pleaseEnterLastName {
    return Intl.message(
      'Please enter your last name',
      name: 'pleaseEnterLastName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your phone number`
  String get pleaseEnterPhone {
    return Intl.message(
      'Please enter your phone number',
      name: 'pleaseEnterPhone',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account? `
  String get dontHaveAccount {
    return Intl.message(
      'Don\'t have an account? ',
      name: 'dontHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign up `
  String get singUpNow {
    return Intl.message(
      'Sign up ',
      name: 'singUpNow',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid Syrian number like 9XX XXX XXX`
  String get invalidPhoneFormat {
    return Intl.message(
      'Please enter a valid Syrian number like 9XX XXX XXX',
      name: 'invalidPhoneFormat',
      desc: '',
      args: [],
    );
  }

  /// `9XX XXX XXX`
  String get syrianPhoneHint {
    return Intl.message(
      '9XX XXX XXX',
      name: 'syrianPhoneHint',
      desc: '',
      args: [],
    );
  }

  /// `Verify OTP`
  String get verifyOtp {
    return Intl.message(
      'Verify OTP',
      name: 'verifyOtp',
      desc: '',
      args: [],
    );
  }

  /// `We have sent a code to`
  String get weSentCodeTo {
    return Intl.message(
      'We have sent a code to',
      name: 'weSentCodeTo',
      desc: '',
      args: [],
    );
  }

  /// `Resend code in `
  String get resendCodeIn {
    return Intl.message(
      'Resend code in ',
      name: 'resendCodeIn',
      desc: '',
      args: [],
    );
  }

  /// `Please enter all 4 digits of the OTP.`
  String get pleaseEnterOtp {
    return Intl.message(
      'Please enter all 4 digits of the OTP.',
      name: 'pleaseEnterOtp',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continueText {
    return Intl.message(
      'Continue',
      name: 'continueText',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a password`
  String get enterPassword {
    return Intl.message(
      'Please enter a password',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
