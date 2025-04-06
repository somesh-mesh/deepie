import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedGradientAppBar extends StatefulWidget implements PreferredSizeWidget {
  const AnimatedGradientAppBar({super.key});

  @override
  State<AnimatedGradientAppBar> createState() => _AnimatedGradientAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AnimatedGradientAppBarState extends State<AnimatedGradientAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _alignmentAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _alignmentAnimation = TweenSequence<Alignment>([
      TweenSequenceItem(
        tween: Tween(begin: Alignment.topLeft, end: Alignment.bottomRight),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: Alignment.bottomRight, end: Alignment.topLeft),
        weight: 1,
      ),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _alignmentAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: _alignmentAnimation.value,
              end: Alignment.center,
              colors: const [
                Color(0xFF6464B5),
                Color(0xFF5729EC),
              ],
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Row(
              children: [
                Image.asset(
                  "assets/images/chatbot.png",
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  "Deepie",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.white
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
