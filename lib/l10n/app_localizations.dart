import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;
  late Map<String, String> _localizedStrings;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  Future<bool> load() async {
    String jsonString = await rootBundle.loadString(
      'lib/l10n/app_${locale.languageCode}${locale.countryCode != null ? '_${locale.countryCode}' : ''}.arb',
    );

    // Try with country code first, then without
    try {
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      _localizedStrings = jsonMap.map((key, value) {
        return MapEntry(key, value.toString());
      });
    } catch (e) {
      // Fallback to base language code
      jsonString = await rootBundle.loadString(
        'lib/l10n/app_${locale.languageCode}.arb',
      );
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      _localizedStrings = jsonMap.map((key, value) {
        return MapEntry(key, value.toString());
      });
    }

    return true;
  }

  String translate(String key, [Map<String, String>? args]) {
    String text = _localizedStrings[key] ?? key;
    if (args != null) {
      args.forEach((argKey, argValue) {
        text = text.replaceAll('{$argKey}', argValue);
      });
    }
    return text;
  }

  String get appTitle => translate('appTitle');
  String get wholesaleDistribution => translate('wholesaleDistribution');
  String get selectAccount => translate('selectAccount');
  String get productCatalog => translate('productCatalog');
  String get orderHistory => translate('orderHistory');
  String get developerMenu => translate('developerMenu');
  String get switchAccount => translate('switchAccount');
  String get welcome => translate('welcome');
  String get cart => translate('cart');
  String get addToCart => translate('addToCart');
  String get shoppingCart => translate('shoppingCart');
  String get clear => translate('clear');
  String get clearCart => translate('clearCart');
  String get clearCartConfirm => translate('clearCartConfirm');
  String get cancel => translate('cancel');
  String get yourCartIsEmpty => translate('yourCartIsEmpty');
  String get browseProducts => translate('browseProducts');
  String get total => translate('total');
  String get proceedToCheckout => translate('proceedToCheckout');
  String get checkout => translate('checkout');
  String get deliveryAccount => translate('deliveryAccount');
  String get deliveryDate => translate('deliveryDate');
  String get tapToChangeDate => translate('tapToChangeDate');
  String get orderNotesOptional => translate('orderNotesOptional');
  String get deliveryInstructions => translate('deliveryInstructions');
  String get orderSummary => translate('orderSummary');
  String get placeOrder => translate('placeOrder');
  String get orderPlaced => translate('orderPlaced');
  String get orderSuccessMessage => translate('orderSuccessMessage');
  String get orderId => translate('orderId');
  String get totalAmount => translate('totalAmount');
  String get estimatedDelivery => translate('estimatedDelivery');
  String get viewOrderHistory => translate('viewOrderHistory');
  String get continueShopping => translate('continueShopping');
  String get noOrdersYet => translate('noOrdersYet');
  String get orderHistoryWillAppear => translate('orderHistoryWillAppear');
  String get orderNotes => translate('orderNotes');
  String get description => translate('description');
  String get packSize => translate('packSize');
  String get quantity => translate('quantity');
  String get password => translate('password');
  String get login => translate('login');
  String get passwordHint => translate('passwordHint');
  String get noAccountSelected => translate('noAccountSelected');
  String get processing => translate('processing');
  String get loading => translate('loading');
  String get apiCallTest => translate('apiCallTest');
  String get appInfo => translate('appInfo');
  String get versionAndBuild => translate('versionAndBuild');
  String get getCatFact => translate('getCatFact');
  String get pressButton => translate('pressButton');
  String get catFacts => translate('catFacts');
  String get settings => translate('settings');
  String get language => translate('language');
  String get english => translate('english');
  String get traditionalChinese => translate('traditionalChinese');
  String get simplifiedChinese => translate('simplifiedChinese');
  String get logout => translate('logout');
  String get confirmLogout => translate('confirmLogout');
  String get orders => translate('orders');
  String get pending => translate('pending');
  String get confirmed => translate('confirmed');
  String get delivered => translate('delivered');
  String get ordered => translate('ordered');
  String get delivery => translate('delivery');

  String productsAvailableText(int count) => '$count ${translate('productsAvailable')}';
  String itemsText(int count) => '$count ${count > 1 ? translate('items') : translate('item')}';
  String enterPasswordText(String account) => translate('enterPassword', {'account': account});
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
