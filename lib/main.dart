import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'services/cloudflare_ai_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cat Facts Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CatFactsPage(),
    );
  }
}

class CatFactsPage extends StatefulWidget {
  const CatFactsPage({super.key});

  @override
  State<CatFactsPage> createState() => _CatFactsPageState();
}

class _CatFactsPageState extends State<CatFactsPage> {
  String _catFact = 'Press the button to get a cat fact!';
  bool _isLoading = false;
  final Dio _dio = Dio();
  final CloudflareAiService _aiService = CloudflareAiService();

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

  Future<void> _showAiChatDialog() async {
    final messageController = TextEditingController();
    String? aiResponse;
    bool isProcessing = false;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.smart_toy, color: Colors.deepPurple),
              SizedBox(width: 8),
              Text('AI Chat'),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (aiResponse != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your question:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(messageController.text),
                        const Divider(height: 24),
                        const Text(
                          'AI Response:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(aiResponse!),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                TextField(
                  controller: messageController,
                  decoration: const InputDecoration(
                    labelText: 'Ask the AI...',
                    hintText: 'e.g., Tell me a joke about cats',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.chat),
                  ),
                  maxLines: 3,
                  enabled: !isProcessing,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isProcessing ? null : () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              onPressed: isProcessing
                  ? null
                  : () async {
                      if (messageController.text.trim().isEmpty) return;

                      setDialogState(() {
                        isProcessing = true;
                      });

                      try {
                        final response = await _aiService.chat(
                          messageController.text.trim(),
                        );

                        setDialogState(() {
                          aiResponse = response;
                          isProcessing = false;
                        });
                      } catch (e) {
                        setDialogState(() {
                          aiResponse = 'Error: $e';
                          isProcessing = false;
                        });
                      }
                    },
              icon: isProcessing
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.send),
              label: Text(isProcessing ? 'Asking...' : 'Ask AI'),
            ),
          ],
        ),
      ),
    );

    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('🐱 Cat Facts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.smart_toy),
            tooltip: 'AI Chat',
            onPressed: _showAiChatDialog,
          ),
        ],
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _showAiChatDialog,
                icon: const Icon(Icons.smart_toy),
                label: const Text('Ask AI Chat'),
                style: OutlinedButton.styleFrom(
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
