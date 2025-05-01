import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

Future<void> main() async {
  // Initialize Flutter bindings
  WidgetsFlutterBinding.ensureInitialized();

  // Create a picture recorder
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  
  // Define the size (512x512 for high resolution)
  const size = Size(512, 512);
  
  // Draw the gradient icon
  final paint = Paint()
    ..shader = const LinearGradient(
      colors: [
        Color(0xFF35C3F3),  // Light blue
        Color(0xFF8B9FE8),  // Periwinkle
        Color(0xFFE681D8),  // Pink
        Color(0xFFFFA9A4),  // Coral
        Color(0xFFFED2CE),  // Light pink
      ],
      stops: [0.0, 0.25, 0.5, 0.75, 1.0],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Offset.zero & size);

  // Draw the auto_awesome icon path
  final path = Path()
    ..moveTo(256, 50)  // Adjust these coordinates to match the auto_awesome icon shape
    ..lineTo(462, 256)
    ..lineTo(256, 462)
    ..lineTo(50, 256)
    ..close();

  canvas.drawPath(path, paint);

  // Convert to an image
  final picture = recorder.endRecording();
  final img = await picture.toImage(size.width.toInt(), size.height.toInt());
  final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
  final buffer = byteData!.buffer.asUint8List();

  // Save the file
  final file = File('assets/splash_icon.png');
  await file.writeAsBytes(buffer);
  
  print('Splash icon generated successfully!');
  exit(0);
} 