// message_model.dart

class Message {
  final String text;
  final bool isSender;
  final bool hasTranslation;
  final String time;

  Message(
    this.text,
    this.isSender,
    this.hasTranslation,
    this.time,
  );
}
