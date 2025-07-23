import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/conversation_message.dart';

class MessageCard extends StatelessWidget {
  final ConversationMessage message;

  const MessageCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      color: message.isUser
          ? Theme.of(context).colorScheme.primaryContainer
          : Theme.of(context).colorScheme.secondaryContainer,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMessageHeader(context),
            SizedBox(height: 8),
            _buildMessageContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageHeader(BuildContext context) {
    return Row(
      children: [
        Icon(
          message.isUser ? Icons.person : Icons.smart_toy,
          size: 20,
          color: message.isUser
              ? Theme.of(context).colorScheme.onPrimaryContainer
              : Theme.of(context).colorScheme.onSecondaryContainer,
        ),
        SizedBox(width: 8),
        Text(
          message.isUser ? 'You' : 'AI Assistant',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: message.isUser
                ? Theme.of(context).colorScheme.onPrimaryContainer
                : Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
      ],
    );
  }

  Widget _buildMessageContent(BuildContext context) {
    if (message.isUser) {
      return Text(
        message.content,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      );
    } else {
      return MarkdownBody(
        data: message.content,
        styleSheet: _buildMarkdownStyleSheet(context),
        onTapLink: _handleLinkTap,
      );
    }
  }

  MarkdownStyleSheet _buildMarkdownStyleSheet(BuildContext context) {
    final onSecondaryContainer = Theme.of(
      context,
    ).colorScheme.onSecondaryContainer;

    return MarkdownStyleSheet(
      p: TextStyle(color: onSecondaryContainer),
      h1: TextStyle(color: onSecondaryContainer, fontWeight: FontWeight.bold),
      h2: TextStyle(color: onSecondaryContainer, fontWeight: FontWeight.bold),
      h3: TextStyle(color: onSecondaryContainer, fontWeight: FontWeight.bold),
      listBullet: TextStyle(color: onSecondaryContainer),
      code: TextStyle(
        backgroundColor: Colors.grey[300],
        fontFamily: 'monospace',
      ),
      codeblockDecoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Future<void> _handleLinkTap(String text, String? href, String title) async {
    if (href != null && await canLaunchUrl(Uri.parse(href))) {
      await launchUrl(Uri.parse(href));
    }
  }
}
