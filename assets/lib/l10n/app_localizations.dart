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
    String jsonString;

    // Try with country code first
    if (locale.countryCode != null && locale.countryCode!.isNotEmpty) {
      try {
        jsonString = await rootBundle.loadString(
          'lib/l10n/app_${locale.languageCode}_${locale.countryCode}.arb',
        );
        Map<String, dynamic> jsonMap = json.decode(jsonString);
        _localizedStrings = jsonMap.map((key, value) {
          return MapEntry(key, value.toString());
        });
        return true;
      } catch (e) {
        // Fall through to base language
      }
    }

    // Try base language code
    try {
      jsonString = await rootBundle.loadString(
        'lib/l10n/app_${locale.languageCode}.arb',
      );
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      _localizedStrings = jsonMap.map((key, value) {
        return MapEntry(key, value.toString());
      });
    } catch (e) {
      // Fallback to English
      jsonString = await rootBundle.loadString('lib/l10n/app_en.arb');
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

  // General strings
  String get appTitle => translate('appTitle');
  String get wholesalerBrand => translate('wholesalerBrand');
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
  String get loginId => translate('loginId');
  String get loginIdRequired => translate('loginIdRequired');
  String get demoHint => translate('demoHint');
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

  // Brand
  String get tsingtaoBrewery => translate('tsingtaoBrewery');

  // Products
  String get productLager330 => translate('productLager330');
  String get productLager640 => translate('productLager640');
  String get productPureDraft330 => translate('productPureDraft330');
  String get product1903_500 => translate('product1903_500');
  String get productStout330 => translate('productStout330');
  String get productWhiteAle330 => translate('productWhiteAle330');
  String get productPremium500 => translate('productPremium500');

  // Accounts
  String get accountDowntownBar => translate('accountDowntownBar');
  String get accountItalianKitchen => translate('accountItalianKitchen');
  String get accountCornerMarket => translate('accountCornerMarket');

  // Account Types
  String get barType => translate('barType');
  String get restaurantType => translate('restaurantType');
  String get retailType => translate('retailType');

  // Product Descriptions
  String get descLager => translate('descLager');
  String get descLagerLarge => translate('descLagerLarge');
  String get descPureDraft => translate('descPureDraft');
  String get desc1903 => translate('desc1903');
  String get descStout => translate('descStout');
  String get descWhiteAle => translate('descWhiteAle');
  String get descPremium => translate('descPremium');

  // Helper methods
  String productsAvailableText(int count) => '$count ${translate('productsAvailable')}';
  String itemsText(int count) => '$count ${count > 1 ? translate('items') : translate('item')}';
  String enterPasswordText(String account) => translate('enterPassword', {'account': account});

  // Product name by ID
  String getProductName(String productId) {
    switch (productId) {
      case 'tsingtao-001':
      case 'tsingtao-002':
      case 'tsingtao-003':
        return productLager330;
      case 'tsingtao-004':
      case 'tsingtao-005':
        return productLager640;
      case 'tsingtao-006':
      case 'tsingtao-007':
        return productPureDraft330;
      case 'tsingtao-008':
      case 'tsingtao-009':
        return product1903_500;
      case 'tsingtao-010':
      case 'tsingtao-011':
        return productStout330;
      case 'tsingtao-012':
      case 'tsingtao-013':
        return productWhiteAle330;
      case 'tsingtao-014':
      case 'tsingtao-015':
        return productPremium500;
      default:
        return productId;
    }
  }

  // Product description by ID
  String getProductDescription(String productId) {
    switch (productId) {
      case 'tsingtao-001':
      case 'tsingtao-002':
      case 'tsingtao-003':
        return descLager;
      case 'tsingtao-004':
      case 'tsingtao-005':
        return descLagerLarge;
      case 'tsingtao-006':
      case 'tsingtao-007':
        return descPureDraft;
      case 'tsingtao-008':
      case 'tsingtao-009':
        return desc1903;
      case 'tsingtao-010':
      case 'tsingtao-011':
        return descStout;
      case 'tsingtao-012':
      case 'tsingtao-013':
        return descWhiteAle;
      case 'tsingtao-014':
      case 'tsingtao-015':
        return descPremium;
      default:
        return '';
    }
  }

  // Account name by ID
  String getAccountName(String accountId) {
    switch (accountId) {
      case 'acc-001':
        return accountDowntownBar;
      case 'acc-002':
        return accountItalianKitchen;
      case 'acc-003':
        return accountCornerMarket;
      default:
        return accountId;
    }
  }

  // Account type by type string
  String getAccountType(String type) {
    switch (type.toLowerCase()) {
      case 'bar':
        return barType;
      case 'restaurant':
        return restaurantType;
      case 'retail':
        return retailType;
      default:
        return type;
    }
  }
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
