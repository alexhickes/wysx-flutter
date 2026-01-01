import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';

class AuthBackground extends StatelessWidget {
  const AuthBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base background
        Container(
          color: Colors.black,
        ), // Or white based on theme, but user asked for black/white base
        // Animated Blobs
        Positioned(
          top: -100,
          left: -100,
          child:
              Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.purple9.withOpacity(0.4),
                    ),
                  )
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
                  .scale(
                    duration: 4.seconds,
                    begin: const Offset(1, 1),
                    end: const Offset(1.5, 1.5),
                  )
                  .move(
                    duration: 5.seconds,
                    begin: const Offset(0, 0),
                    end: const Offset(50, 50),
                  ),
        ),
        Positioned(
          bottom: -100,
          right: -100,
          child:
              Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.purple7.withOpacity(0.3),
                    ),
                  )
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
                  .scale(
                    duration: 3.seconds,
                    begin: const Offset(1, 1),
                    end: const Offset(1.2, 1.2),
                  )
                  .move(
                    duration: 4.seconds,
                    begin: const Offset(0, 0),
                    end: const Offset(-30, -30),
                  ),
        ),

        // Blur Effect
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
          child: Container(color: Colors.transparent),
        ),
      ],
    );
  }
}
