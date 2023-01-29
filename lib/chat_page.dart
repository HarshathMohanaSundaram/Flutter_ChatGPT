import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'message_model.dart';

class ChatWithGPT extends StatefulWidget {
  const ChatWithGPT({super.key});

  @override
  State<ChatWithGPT> createState() => _ChatWithGPTState();
}

class _ChatWithGPTState extends State<ChatWithGPT> {
  final Color backgroundBotColor = const Color(0xFFF16A6A);
  final Color backgroundColor = const Color(0xF8FF9090);
  late bool _isLoading;
  final TextEditingController _controller = TextEditingController();
  final _scrollController = ScrollController();
  List<ChatMessage> _messages = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = false;
  }

  Future<String> generateResponse(String prompt) async {
    var url = Uri.https("api.openai.com", "/v1/completions");
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        "Authorization":
            "Bearer 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"
      },
      body: json.encode({
        "model": "text-davinci-003",
        "prompt": prompt,
        'temperature': 0,
        'max_tokens': 2000,
        'top_p': 1,
        'frequency_penalty': 0.0,
        'presence_penalty': 0.0,
      }),
    );

    Map<String, dynamic> newResponse = jsonDecode(response.body);
    return newResponse['choices'][0]['text'];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          centerTitle: true,
          elevation: 0,
          title: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "ChatGPT Chat bot",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          backgroundColor: backgroundBotColor,
        ),
        backgroundColor: backgroundColor,
        body: Column(
          children: [
            Expanded(
              child: _buildMessages(),
            ),
            Visibility(
              visible: _isLoading,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                  color: Colors.redAccent,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  _buildInput(),
                  _buildRequest(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Expanded _buildInput() {
    return Expanded(
        child: TextField(
      textCapitalization: TextCapitalization.sentences,
      autocorrect: true,
      controller: _controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
          fillColor: backgroundBotColor,
          filled: true,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none),
    ));
  }

  Widget _buildRequest() {
    return Visibility(
        visible: !_isLoading,
        child: Container(
          color: backgroundBotColor,
          child: IconButton(
              onPressed: () {
                setState(() {
                  _messages.add(ChatMessage(
                      text: _controller.text,
                      chatMessageType: ChatMessageType.you));
                  _isLoading = true;
                });
                var input = _controller.text;
                _controller.clear();
                Future.delayed(const Duration(milliseconds: 50))
                    .then((value) => _scrollDown());
                generateResponse(input).then((value) {
                  setState(() {
                    _isLoading = false;
                    _messages.add(ChatMessage(
                        text: value, chatMessageType: ChatMessageType.bot));
                  });
                });
                _controller.clear();
                Future.delayed(const Duration(milliseconds: 50))
                    .then((value) => _scrollDown());
              },
              icon: const Icon(
                Icons.send_rounded,
                color: Colors.white,
              )),
        ));
  }

  void _scrollDown() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 50), curve: Curves.easeOut);
  }

  ListView _buildMessages() {
    return ListView.builder(
        itemCount: _messages.length,
        controller: _scrollController,
        itemBuilder: ((context, index) {
          return ChatMessageShow(
            text: _messages[index].text,
            chatMessageType: _messages[index].chatMessageType,
          );
        }));
  }
}
