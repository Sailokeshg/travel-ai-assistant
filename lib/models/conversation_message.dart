class ConversationMessage {
  final String type;
  final String content;
  final DateTime timestamp;

  ConversationMessage({
    required this.type,
    required this.content,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  bool get isUser => type == 'user';
  bool get isAI => type == 'ai';

  Map<String, String> toMap() {
    return {'type': type, 'content': content};
  }

  factory ConversationMessage.fromMap(Map<String, String> map) {
    return ConversationMessage(type: map['type']!, content: map['content']!);
  }
}
