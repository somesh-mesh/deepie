import 'package:deppie/pages/widgets/capabilty_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chat_screen.dart';

class CapabilitiesScreen extends StatefulWidget {
  const CapabilitiesScreen({super.key});

  @override
  State<CapabilitiesScreen> createState() => _CapabilitiesScreenState();
}

class _CapabilitiesScreenState extends State<CapabilitiesScreen> {
  final TextEditingController _controller = TextEditingController();

  void _navigateToChat(BuildContext context) {
    final message = _controller.text.trim();
    if (message.isNotEmpty) {
      context.go('/chat?msg=${Uri.encodeComponent(message)}');
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
        title: Text(
          'Deepie',
          style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Image.asset('assets/images/chatbot.png', height: 80), // Replace with your logo
          const SizedBox(height: 8),
          Text(
            "Capabilities",
            style: GoogleFonts.poppins(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),

          /// Capability Cards
          CapabilityCard(
            title: "Answer all your questions.",
            subtitle: "(Just ask me anything you like!)",
          ),
          CapabilityCard(
            title: "Generate all the text you want.",
            subtitle: "(essays, articles, reports, stories, & more)",
          ),
          CapabilityCard(
            title: "Conversational AI.",
            subtitle: "(I can talk to you like a natural human)",
          ),

          const Spacer(),

          /// Bottom Note
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              "These are just a few examples of what I can do.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13),
            ),
          ),

          /// Message Input Field
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Ask me anything...",
                      hintStyle: GoogleFonts.poppins(color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: (){
                    _navigateToChat(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFF5D5FEF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
