import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'providers/account_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/orders_provider.dart';
import 'providers/locale_provider.dart';
import 'screens/account_selection_screen.dart';

void main() {
  runApp(const BrewDirectApp());
}

class BrewDirectApp extends StatelessWidget {
  const BrewDirectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => AccountProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp(
            title: 'BrewDirect',
            debugShowCheckedModeBanner: false,
            locale: localeProvider.locale,
            supportedLocales: const [
              Locale('en'),
              Locale('zh', 'Hant'),
              Locale('zh', 'Hans'),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFFD4A054),
                primary: const Color(0xFFD4A054),
                secondary: const Color(0xFF8B5E3C),
                surface: Colors.white,
              ),
              scaffoldBackgroundColor: const Color(0xFFFAF6F2),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFFD4A054),
                foregroundColor: Colors.white,
                elevation: 0,
                centerTitle: true,
              ),
              cardTheme: const CardThemeData(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4A054),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFD4A054),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFD4A054), width: 2),
                ),
              ),
              fontFamily: 'Roboto',
            ),
            home: const AccountSelectionScreen(),
          );
        },
      ),
    );
  }
}
