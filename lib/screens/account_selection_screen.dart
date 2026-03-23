import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/account_provider.dart';
import '../providers/locale_provider.dart';
import 'home_screen.dart';

class AccountSelectionScreen extends StatelessWidget {
  const AccountSelectionScreen({super.key});

  void _showPasswordDialog(BuildContext context, dynamic account) {
    final l10n = context.l10n;
    final passwordController = TextEditingController();
    final accountName = l10n.getAccountName(account.id);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.password),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.enterPasswordText(accountName)),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: l10n.password,
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) {
                _performLogin(context, dialogContext, account);
              },
            ),
            const SizedBox(height: 8),
            Text(
              l10n.passwordHint,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => _performLogin(context, dialogContext, account),
            child: Text(l10n.login),
          ),
        ],
      ),
    );
  }

  void _performLogin(BuildContext context, dialogContext, dynamic account) {
    context.read<AccountProvider>().selectAccount(account);
    Navigator.of(dialogContext).pop();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFD4A054), Color(0xFF8B5E3C)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Language selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Consumer<LocaleProvider>(
                      builder: (context, localeProvider, _) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: '${localeProvider.locale.languageCode}_${localeProvider.locale.countryCode ?? ''}',
                              dropdownColor: const Color(0xFF8B5E3C),
                              style: const TextStyle(color: Colors.white),
                              icon: const Icon(Icons.language, color: Colors.white),
                              items: [
                                DropdownMenuItem(
                                  value: 'zh_Hant',
                                  child: Text(l10n.traditionalChinese),
                                ),
                                DropdownMenuItem(
                                  value: 'zh_Hans',
                                  child: Text(l10n.simplifiedChinese),
                                ),
                                DropdownMenuItem(
                                  value: 'en_',
                                  child: Text(l10n.english),
                                ),
                              ],
                              onChanged: (value) {
                                if (value == 'zh_Hant') {
                                  localeProvider.setTraditionalChinese();
                                } else if (value == 'zh_Hans') {
                                  localeProvider.setSimplifiedChinese();
                                } else {
                                  localeProvider.setEnglish();
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: const Icon(
                    Icons.local_drink,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    l10n.appTitle,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    l10n.wholesaleDistribution,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                Text(
                  l10n.selectAccount,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Consumer<AccountProvider>(
                    builder: (context, accountProvider, child) {
                      return ListView.builder(
                        itemCount: accountProvider.accounts.length,
                        itemBuilder: (context, index) {
                          final account = accountProvider.accounts[index];
                          final accountName = l10n.getAccountName(account.id);
                          final accountType = l10n.getAccountType(account.type);

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: InkWell(
                                onTap: () => _showPasswordDialog(context, account),
                                borderRadius: BorderRadius.circular(16),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 56,
                                        height: 56,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFD4A054).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          account.typeIcon,
                                          color: const Color(0xFFD4A054),
                                          size: 28,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              accountName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              accountType,
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 13,
                                              ),
                                            ),
                                            Text(
                                              account.address,
                                              style: TextStyle(
                                                color: Colors.grey[500],
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(
                                        Icons.chevron_right,
                                        color: Color(0xFFD4A054),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
