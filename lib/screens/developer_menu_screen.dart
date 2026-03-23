import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DeveloperMenuScreen extends StatefulWidget {
  const DeveloperMenuScreen({super.key});

  @override
  State<DeveloperMenuScreen> createState() => _DeveloperMenuScreenState();
}

class _DeveloperMenuScreenState extends State<DeveloperMenuScreen> {
  String _catFact = 'Press the button to get a cat fact!';
  bool _isLoading = false;
  final Dio _dio = Dio();

  Future<void> _fetchCatFact() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _dio.get('https://catfact.ninja/fact');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        setState(() {
          _catFact = data['fact'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _catFact = 'Failed to load cat fact: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _catFact = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer Menu'),
        backgroundColor: Colors.grey[800],
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Developer Tools',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.pets, color: Colors.orange),
            ),
            title: const Text('Cat Facts'),
            subtitle: const Text('API call test'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CatFactsScreen()),
              );
            },
          ),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.info_outline, color: Colors.blue),
            ),
            title: const Text('App Info'),
            subtitle: const Text('Version and build information'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'BrewDirect',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2024 BrewDirect Demo',
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'A demo beer distributor order placement system built with Flutter.',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class CatFactsScreen extends StatefulWidget {
  const CatFactsScreen({super.key});

  @override
  State<CatFactsScreen> createState() => _CatFactsScreenState();
}

class _CatFactsScreenState extends State<CatFactsScreen> {
  String _catFact = 'Press the button to get a cat fact!';
  bool _isLoading = false;
  final Dio _dio = Dio();

  Future<void> _fetchCatFact() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _dio.get('https://catfact.ninja/fact');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        setState(() {
          _catFact = data['fact'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _catFact = 'Failed to load cat fact: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _catFact = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cat Facts'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.pets,
                size: 80,
                color: Colors.orange,
              ),
              const SizedBox(height: 32),
              Text(
                _catFact,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _fetchCatFact,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.refresh),
                label: Text(_isLoading ? 'Loading...' : 'Get Cat Fact'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
