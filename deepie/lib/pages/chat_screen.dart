import 'dart:convert';
import 'package:deppie/pages/widgets/animate_gradient_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  final String initialMessage;

  const ChatScreen({super.key, required this.initialMessage});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> messages = [];
  bool isLoading = false;
  late AnimationController _dotsController;
  late Animation<int> _dotCount;

  @override
  void initState() {
    super.initState();
    _sendMessage(widget.initialMessage);

    _dotsController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _dotCount = StepTween(begin: 0, end: 3).animate(_dotsController);
  }

  @override
  void dispose() {
    _dotsController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String message) async {
    setState(() {
      messages.add({'sender': 'user', 'text': message});
      isLoading = true;
    });

    final url = Uri.parse('http://192.168.31.228:8000/chat');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'message': message});

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String responseText = data['textResponse'] ?? '';
        responseText = responseText.replaceAll('<think>', '').trim();

        setState(() {
          messages.add({'sender': 'bot', 'text': responseText});
          isLoading = false;
        });
      } else {
        setState(() {
          messages.add({'sender': 'bot', 'text': 'Something went wrong. Try again.'});
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        messages.add({'sender': 'bot', 'text': 'Failed to connect to server.'});
        isLoading = false;
      });
    }
  }

  Widget _buildChatBubble(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF5D5FEF) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: isUser ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildThinkingBubble() {
    return AnimatedBuilder(
      animation: _dotsController,
      builder: (context, child) {
        final dots = '.' * _dotCount.value;
        return _buildChatBubble("💭 Thinking$dots", false);
      },
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                textInputAction: TextInputAction.send,
                decoration: InputDecoration(
                  hintText: "Ask me anything...",
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.grey.shade600,
                    fontSize: 15,
                  ),
                  border: InputBorder.none,
                ),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    _sendMessage(value.trim());
                    _controller.clear();
                  }
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                final msg = _controller.text.trim();
                if (msg.isNotEmpty) {
                  _sendMessage(msg);
                  _controller.clear();
                }
              },
              child: Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(left: 8),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF5D5FEF), Color(0xFF8F6DFD)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x405D5FEF),
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    )
                  ],
                ),
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
        appBar: const AnimatedGradientAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                reverse: false,
                itemCount: messages.length + (isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == messages.length && isLoading) {
                    return _buildThinkingBubble();
                  }

                  final message = messages[index];
                  return _buildChatBubble(
                    message['text']!,
                    message['sender'] == 'user',
                  );
                },
              ),
            ),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }
}
