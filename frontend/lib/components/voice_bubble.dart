import 'package:flutter/cupertino.dart';

class VoiceBubble extends StatefulWidget {
  final Color color;
  const VoiceBubble({super.key, required this.color});

  @override
  State<VoiceBubble> createState() => _VoiceBubbleState();
}

class _VoiceBubbleState extends State<VoiceBubble>
    with SingleTickerProviderStateMixin {

  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween(begin: 1.0, end: 1.2)
          .animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      )),
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
