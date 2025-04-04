import 'package:cloud_firestore/cloud_firestore.dart';
import 'enum/message_type.dart';

class Message {
  String? content;
  String? senderUid;
  String? messageId;
  MessageType? type;
  Timestamp? time;

  Message({this.content, this.senderUid, this.messageId, this.type, this.time});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      content: json['content'] as String?,
      senderUid: json['senderUid'] as String?,
      messageId: json['messageId'] as String?,
      type:
          (json['type']?.toString().toLowerCase() == 'text')
              ? MessageType.TEXT
              : MessageType.IMAGE,
      time: json['time'] is Timestamp ? json['time'] as Timestamp : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'senderUid': senderUid,
      'messageId': messageId,
      'type': type == MessageType.TEXT ? 'text' : 'image',
      'time': time,
    };
  }
}
