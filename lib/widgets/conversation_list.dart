import 'package:flutter/material.dart';
import '../models/conversation_message.dart';
import 'message_card.dart';
import 'loading_card.dart';
import 'empty_state.dart';

class ConversationList extends StatelessWidget {
  final List<ConversationMessage> messages;
  final bool isLoading;

  const ConversationList({
    super.key,
    required this.messages,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty && !isLoading) {
      return EmptyState();
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: messages.length + (isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == messages.length && isLoading) {
          return LoadingCard();
        }

        final message = messages[index];
        return MessageCard(message: message);
      },
    );
  }
}
