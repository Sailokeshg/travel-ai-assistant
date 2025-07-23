import 'package:flutter/material.dart';

class MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onSendMessage;
  final Function(String) onSubmit;

  const MessageInput({
    super.key,
    required this.controller,
    required this.isLoading,
    required this.onSendMessage,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
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
                controller: controller,
                decoration: InputDecoration(
                  hintText:
                      'Ask about destinations, activities, travel tips...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  filled: true,
                  fillColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: onSubmit,
                enabled: !isLoading,
              ),
            ),
            SizedBox(width: 8),
            FloatingActionButton(
              mini: true,
              onPressed: isLoading ? null : onSendMessage,
              child: Icon(isLoading ? Icons.hourglass_empty : Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
