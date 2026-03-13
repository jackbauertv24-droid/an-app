import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CloudflareAiService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final Dio _dio = Dio();
  
  static const String _accountId = '546112abca8ae8f6f23c6181dc119865';
  static const String _gatewayId = 'cheapy';
  static const String _authKey = 'cf-aig-authorization';
  static const String _tokenKey = 'cloudflare_ai_token';
  static const String _modelKey = 'cloudflare_ai_model';
  
  static const String _defaultToken = 'rLQ_QHv6PhdVw0OXb_VHQU5ZHJ_OrDHHE31tFno0';
  static const String _defaultModel = 'groq/llama-3.3-70b-versatile';

  CloudflareAiService() {
    _dio.options.baseUrl = 'https://gateway.ai.cloudflare.com/v1/$_accountId/$_gatewayId/compat/chat/completions';
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };
  }

  Future<String> _getToken() async {
    String? token = await _storage.read(key: _tokenKey);
    if (token == null || token.isEmpty) {
      await _storage.write(key: _tokenKey, value: _defaultToken);
      token = _defaultToken;
    }
    return token;
  }

  Future<String> _getModel() async {
    String? model = await _storage.read(key: _modelKey);
    if (model == null || model.isEmpty) {
      await _storage.write(key: _modelKey, value: _defaultModel);
      model = _defaultModel;
    }
    return model;
  }

  Future<void> setToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<void> setModel(String model) async {
    await _storage.write(key: _modelKey, value: model);
  }

  Future<String> chat(String message, {List<Map<String, String>>? conversationHistory}) async {
    final token = await _getToken();
    final model = await _getModel();
    
    final List<Map<String, String>> messages = conversationHistory ?? [];
    messages.add({'role': 'user', 'content': message});

    final response = await _dio.post(
      '',
      data: {
        'model': model,
        'messages': messages,
      },
      options: Options(
        headers: {
          _authKey: 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed to get AI response: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> chatWithDetails(
    String message, {
    List<Map<String, String>>? conversationHistory,
  }) async {
    final token = await _getToken();
    final model = await _getModel();
    
    final List<Map<String, String>> messages = conversationHistory ?? [];
    messages.add({'role': 'user', 'content': message});

    final response = await _dio.post(
      '',
      data: {
        'model': model,
        'messages': messages,
      },
      options: Options(
        headers: {
          _authKey: 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      return {
        'response': data['choices'][0]['message']['content'],
        'model': data['model'],
        'usage': data['usage'],
      };
    } else {
      throw Exception('Failed to get AI response: ${response.statusCode}');
    }
  }
}
