import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

enum ChatMessageType { you, bot }

class ChatMessage {
  final String text;
  final ChatMessageType chatMessageType;
  ChatMessage({required this.text, required this.chatMessageType});
}

class ChatMessageShow extends StatelessWidget {
  final Color backgroundBotColor = const Color(0xFFF16A6A);
  final Color backgroundColor = const Color(0xF8FF9090);
  final String text;
  final ChatMessageType chatMessageType;
  const ChatMessageShow(
      {super.key, required this.text, required this.chatMessageType});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      color: chatMessageType == ChatMessageType.bot
          ? backgroundBotColor
          : backgroundColor,
      child: Row(
        children: [
          chatMessageType == ChatMessageType.bot
              ? Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: CircleAvatar(
                    backgroundColor: const Color.fromRGBO(16, 163, 127, 1),
                    child: Image.asset(
                      'assets/bot.png',
                      color: Colors.white,
                      scale: 1.5,
                    ),
                  ),
                )
              : Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: const CircleAvatar(child: Icon(Icons.person)),
                ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  child: Text(
                    text,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.white),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
