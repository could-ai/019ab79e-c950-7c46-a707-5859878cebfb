import 'package:flutter/material.dart';
import 'dart:async';

class VoiceInputWidget extends StatefulWidget {
  final bool isListening;
  final VoidCallback onStartListening;
  final VoidCallback onStopListening;

  const VoiceInputWidget({
    super.key,
    required this.isListening,
    required this.onStartListening,
    required this.onStopListening,
  });

  @override
  State<VoiceInputWidget> createState() => _VoiceInputWidgetState();
}

class _VoiceInputWidgetState extends State<VoiceInputWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) => widget.onStartListening(),
      onLongPressEnd: (_) => widget.onStopListening(),
      // Also support tap toggle for web/desktop where long press might be awkward
      onTap: () {
        if (widget.isListening) {
          widget.onStopListening();
        } else {
          widget.onStartListening();
        }
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.isListening ? Colors.redAccent : const Color(0xFF6200EA),
              boxShadow: [
                if (widget.isListening)
                  BoxShadow(
                    color: Colors.redAccent.withOpacity(0.5),
                    blurRadius: 10 * _scaleAnimation.value,
                    spreadRadius: 5 * _scaleAnimation.value,
                  ),
              ],
            ),
            child: Icon(
              widget.isListening ? Icons.mic : Icons.mic_none,
              color: Colors.white,
              size: 28,
            ),
          );
        },
      ),
    );
  }
}
