import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(TravelApp());
}

class TravelApp extends StatelessWidget {
  const TravelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Travel Guide',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: RecommendationPage(),
    );
  }
}

class RecommendationPage extends StatefulWidget {
  const RecommendationPage({super.key});

  @override
  _RecommendationPageState createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
  final TextEditingController _controller = TextEditingController();
  String _result = '';
  bool _loading = false;
  String _error = '';
  List<Map<String, String>> _conversationHistory = []; // Changed to store message and content separately

  Future<void> fetchRecommendation(String userInput) async {
    if (userInput.trim().isEmpty) return;

    setState(() {
      _loading = true;
      _error = '';
    });

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/recommendations'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_input': userInput}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _result = data['response'];
          _conversationHistory.add({'type': 'user', 'content': userInput});
          _conversationHistory.add({'type': 'ai', 'content': data['response']});
          _loading = false;
          _controller.clear();
        });
      } else {
        throw Exception('Backend error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _clearHistory() {
    setState(() {
      _conversationHistory.clear();
      _result = '';
      _error = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Travel Assistant'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (_conversationHistory.isNotEmpty)
            IconButton(
              icon: Icon(Icons.clear_all),
              onPressed: _clearHistory,
              tooltip: 'Clear conversation',
            ),
        ],
      ),
      body: Column(
        children: [
          // Conversation History
          Expanded(
            child:
                _conversationHistory.isEmpty &&
                    _result.isEmpty &&
                    _error.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.travel_explore,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Ask me anything about travel!',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Get personalized recommendations and travel advice',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: _conversationHistory.length + (_loading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _conversationHistory.length && _loading) {
                        return Card(
                          margin: EdgeInsets.only(bottom: 8),
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Row(
                              children: [
                                CircularProgressIndicator(strokeWidth: 2),
                                SizedBox(width: 16),
                                Text('AI is thinking...'),
                              ],
                            ),
                          ),
                        );
                      }

                      final message = _conversationHistory[index];
                      final isUser = message['type'] == 'user';

                      return Card(
                        margin: EdgeInsets.only(bottom: 8),
                        color: isUser
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(context).colorScheme.secondaryContainer,
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    isUser ? Icons.person : Icons.smart_toy,
                                    size: 20,
                                    color: isUser
                                        ? Theme.of(
                                            context,
                                          ).colorScheme.onPrimaryContainer
                                        : Theme.of(
                                            context,
                                          ).colorScheme.onSecondaryContainer,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    isUser ? 'You' : 'AI Assistant',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isUser
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.onPrimaryContainer
                                          : Theme.of(
                                              context,
                                            ).colorScheme.onSecondaryContainer,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              // Use Markdown for AI responses, regular Text for user messages
                              if (isUser)
                                Text(
                                  message['content']!,
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryContainer,
                                  ),
                                )
                              else
                                MarkdownBody(
                                  data: message['content']!,
                                  styleSheet: MarkdownStyleSheet(
                                    p: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSecondaryContainer,
                                    ),
                                    h1: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSecondaryContainer,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    h2: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSecondaryContainer,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    h3: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSecondaryContainer,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    listBullet: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSecondaryContainer,
                                    ),
                                    code: TextStyle(
                                      backgroundColor: Colors.grey[300],
                                      fontFamily: 'monospace',
                                    ),
                                    codeblockDecoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  onTapLink: (text, href, title) async {
                                    if (href != null &&
                                        await canLaunchUrl(Uri.parse(href))) {
                                      await launchUrl(Uri.parse(href));
                                    }
                                  },
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Error display
          if (_error.isNotEmpty)
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red[50],
                border: Border.all(color: Colors.red[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Error: $_error',
                style: TextStyle(color: Colors.red[700]),
              ),
            ),

          // Input section
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText:
                            'Ask about destinations, activities, travel tips...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surfaceVariant,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (value) => fetchRecommendation(value),
                      enabled: !_loading,
                    ),
                  ),
                  SizedBox(width: 8),
                  FloatingActionButton(
                    onPressed: _loading
                        ? null
                        : () => fetchRecommendation(_controller.text),
                    child: Icon(_loading ? Icons.hourglass_empty : Icons.send),
                    mini: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
