import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart'; //package generate ai

import 'widgets/chat_bubble.dart';

const apiKey = 'AIzaSyAhSl_KUcxFhscqEwfdi95q6JdscqqD1Hs'; //API generate ai

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //inisiasi generate ai
  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
  TextEditingController messageController = TextEditingController();
  bool isLoading = false; //variabel kondisi untuk proses loading

  //kata pengantar chat
  List<ChatBubble> chatBubbles = [
    const ChatBubble(
      direction: Direction.left,
      message: 'Halo, saya GEMINI AI. Ada yang bisa saya bantu?',
      photoUrl: 'https://i.pravatar.cc/150?img=47',
      type: BubbleType.alone,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CupertinoButton(
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Gemini Personal Assistant AI',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              reverse: true,
              padding: const EdgeInsets.all(10),
              children: chatBubbles.reversed.toList(), //kata pengantar chat
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController, //variabel untuk input pesan
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                isLoading
                    ? const CircularProgressIndicator.adaptive() //jika klik send pesan maka progress loading
                    : IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () async{
                          // Send message logic here
                          setState(() {
                            //proses loading atau indikator
                            isLoading = true;
                          });
                          //inisiasi proses kirim pesan
                          final content = [
                            Content.text(messageController.text)
                          ];
                          final GenerateContentResponse responseAI =
                              await model.generateContent(content);

                          //response setelah kirim pesan
                          chatBubbles = [
                            ...chatBubbles,
                            ChatBubble(
                              direction: Direction.right, //posisi chat sebelah kanan
                              message: messageController.text,
                              photoUrl: null,
                              type: BubbleType.alone,
                            )
                          ];

                          //response balesan dari AI
                          chatBubbles = [
                            ...chatBubbles,
                            ChatBubble(
                              direction: Direction.left, //posisi chat sebelah kiri
                              message: responseAI.text ??
                                  'Maaf, saya tidak mengerti',
                              photoUrl: 'https://i.pravatar.cc/150?img=47',
                              type: BubbleType.alone,
                            )
                          ];

                          messageController.clear(); //kosongkan pesan
                          setState(() {
                            isLoading = false; //proses loading atau indikator berhenti
                          });

                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
