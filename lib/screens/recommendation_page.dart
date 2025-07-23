import 'package:flutter/material.dart';
import '../models/conversation_message.dart';
import '../services/recommendation_service.dart';
import '../widgets/conversation_list.dart';
import '../widgets/error_display.dart';
import '../widgets/message_input.dart';
import '../constants/app_constants.dart';

class RecommendationPage extends StatefulWidget {
  const RecommendationPage({super.key});

  @override
  State<RecommendationPage> createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
  final TextEditingController _controller = TextEditingController();
  final List<ConversationMessage> _conversationHistory = [];
  bool _loading = false;
  String _error = '';

  Future<void> _sendMessage(String userInput) async {
    if (userInput.trim().isEmpty) return;

    setState(() {
      _loading = true;
      _error = '';
    });

    // Add user message immediately
    final userMessage = ConversationMessage(
      type: AppConstants.userMessageType,
      content: userInput,
    );

    setState(() {
      _conversationHistory.add(userMessage);
    });

    try {
      final response = await RecommendationService.getRecommendation(userInput);

      final aiMessage = ConversationMessage(
        type: AppConstants.aiMessageType,
        content: response,
      );

      setState(() {
        _conversationHistory.add(aiMessage);
        _loading = false;
        _controller.clear();
      });
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
          Expanded(
            child: ConversationList(
              messages: _conversationHistory,
              isLoading: _loading,
            ),
          ),
          if (_error.isNotEmpty) ErrorDisplay(error: _error),
          MessageInput(
            controller: _controller,
            isLoading: _loading,
            onSendMessage: () => _sendMessage(_controller.text),
            onSubmit: _sendMessage,
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
