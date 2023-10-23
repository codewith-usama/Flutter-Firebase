import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final bool isLoading;
  const RoundButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.deepPurpleAccent,
        ),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
        ),
      ),
    );
  }
}
