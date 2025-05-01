import 'dart:io';
import 'dart:ui' as ui;
import 'dart:math' show pi, sin, min, sqrt;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  
  // Initialize any resources, load preferences, etc.
  await Future.delayed(const Duration(milliseconds: 500)); // Minimum display time
  
  runApp(const FaceDrawingApp());
}

class FaceDrawingApp extends StatelessWidget {
  const FaceDrawingApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Remove splash screen when the app is ready
    FlutterNativeSplash.remove();
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SketchXtract',
      theme: ThemeData(
        primaryColor: const Color(0xFFbfd7ed),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Proxima Nova',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFbfd7ed),
          titleTextStyle: TextStyle(
            fontFamily: 'Proxima Nova',
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFbfd7ed),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontWeight: FontWeight.w700),
          displayMedium: TextStyle(fontWeight: FontWeight.w600),
          displaySmall: TextStyle(fontWeight: FontWeight.w600),
          headlineLarge: TextStyle(fontWeight: FontWeight.w600),
          headlineMedium: TextStyle(fontWeight: FontWeight.w600),
          headlineSmall: TextStyle(fontWeight: FontWeight.w600),
          titleLarge: TextStyle(fontWeight: FontWeight.w600),
          titleMedium: TextStyle(fontWeight: FontWeight.w500),
          titleSmall: TextStyle(fontWeight: FontWeight.w500),
          bodyLarge: TextStyle(fontWeight: FontWeight.w400),
          bodyMedium: TextStyle(fontWeight: FontWeight.w400),
          bodySmall: TextStyle(fontWeight: FontWeight.w400),
          labelLarge: TextStyle(fontWeight: FontWeight.w500),
          labelMedium: TextStyle(fontWeight: FontWeight.w500),
          labelSmall: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      home: const DrawingPage(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 60.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40.0,
      ),
    ]).animate(_controller);

    _fadeAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 60.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.0),
        weight: 40.0,
      ),
    ]).animate(_controller);

    _controller.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const DrawingPage(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 500),
            ),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Center(
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) {
                        return LinearGradient(
                          colors: const [
                            Color(0xFF35C3F3),  // Light blue
                            Color(0xFF8B9FE8),  // Periwinkle
                            Color(0xFFE681D8),  // Pink
                            Color(0xFFFFA9A4),  // Coral
                            Color(0xFFFED2CE),  // Light pink
                          ],
                          stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds);
                      },
                      child: const Icon(
                        Icons.auto_awesome,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ShaderMask(
                      shaderCallback: (bounds) {
                        return const LinearGradient(
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
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.srcIn,
                      child: const Text(
                        'SketchXtract',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class DrawingAction {
  final bool isErase;
  final List<Offset?> points;
  final List<List<Offset?>> erasedPoints;

  DrawingAction({
    required this.isErase,
    required this.points,
    this.erasedPoints = const [],
  });
}

class AnimatedTitle extends StatefulWidget {
  const AnimatedTitle({super.key});

  @override
  State<AnimatedTitle> createState() => _AnimatedTitleState();
}

class _AnimatedTitleState extends State<AnimatedTitle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: const [
                Color(0xFF35C3F3),  // Light blue
                Color(0xFF8B9FE8),  // Periwinkle
                Color(0xFFE681D8),  // Pink
                Color(0xFFFFA9A4),  // Coral
                Color(0xFFFED2CE),  // Light pink
                Color(0xFF35C3F3),  // Light blue (repeat first color)
              ],
              stops: const [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
              tileMode: TileMode.repeated,
              begin: Alignment(-1 + (_controller.value * 2), 0),
              end: Alignment(1 + (_controller.value * 2), 0),
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcIn,
          child: const Text(
            'SketchXtract',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}

class ShakeCurve extends Curve {
  final double count;

  const ShakeCurve({this.count = 3});

  @override
  double transformInternal(double t) {
    return t;
  }
}

class ShakeWidget extends StatefulWidget {
  final Widget child;
  final double shakeOffset;
  final double shakeCount;
  final Duration duration;

  const ShakeWidget({
    super.key,
    required this.child,
    this.shakeOffset = 10.0,
    this.shakeCount = 3,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  State<ShakeWidget> createState() => _ShakeWidgetState();
}

class _ShakeWidgetState extends State<ShakeWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: ShakeCurve(count: widget.shakeCount),
    ))..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.stop();
      }
    });

    // Start the animation when the widget is built
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final double offset = sin(_animation.value * pi * widget.shakeCount) * 
                           (1 - _animation.value) *
                           (1 - _animation.value) *
                           widget.shakeOffset;
        return Transform.translate(
          offset: Offset(offset, 0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class GenderSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const GenderSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        onChanged(!value);
      },
      child: Container(
        width: 64,
        height: 32,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withOpacity(0.2),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: value 
                      ? const Color(0xFF4A90E2)  // Male blue
                      : const Color(0xFFFF69B4), // Female pink
                ),
                child: Center(
                  child: Text(
                    value ? 'M' : 'F',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            // Background letters with reduced opacity
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Opacity(
                  opacity: value ? 0.5 : 0.0,
                  child: const Text(
                    'F',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Opacity(
                  opacity: value ? 0.0 : 0.5,
                  child: const Text(
                    'M',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EraserIcon extends StatelessWidget {
  final Color color;
  final double size;

  const EraserIcon({
    super.key,
    required this.color,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _EraserIconPainter(color),
      ),
    );
  }
}

class _EraserIconPainter extends CustomPainter {
  final Color color;

  _EraserIconPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    
    // Eraser body (3D perspective)
    path.moveTo(size.width * 0.3, size.height * 0.7);  // Bottom left
    path.lineTo(size.width * 0.7, size.height * 0.3);  // Top right
    path.lineTo(size.width * 0.85, size.height * 0.45); // Right point
    path.lineTo(size.width * 0.45, size.height * 0.85); // Bottom point
    path.close();

    // Top face of eraser
    path.moveTo(size.width * 0.5, size.height * 0.15);  // Top left
    path.lineTo(size.width * 0.7, size.height * 0.3);   // Bottom right
    path.lineTo(size.width * 0.85, size.height * 0.45); // Right point
    path.lineTo(size.width * 0.65, size.height * 0.3);  // Top right

    canvas.drawPath(path, paint);

    // Fill the eraser body with a lighter color
    final fillPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final fillPath = Path();
    fillPath.moveTo(size.width * 0.3, size.height * 0.7);
    fillPath.lineTo(size.width * 0.7, size.height * 0.3);
    fillPath.lineTo(size.width * 0.85, size.height * 0.45);
    fillPath.lineTo(size.width * 0.45, size.height * 0.85);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DrawingPage extends StatefulWidget {
  const DrawingPage({super.key});

  @override
  _DrawingPageState createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  final GlobalKey _drawingKey = GlobalKey();
  bool _isLoading = false;
  String? _outputImagePath;
  String _apiUrl = 'https://d30c-34-142-175-1.ngrok-free.app';
  bool _isMaleSelected = true;
  ui.Image? _stencilImage;
  bool _showStencil = true;
  double _stencilOpacity = 0.15;
  bool _showOpacitySlider = false;
  Timer? _sliderTimer;

  final List<DrawingAction> _undoStack = [];
  final List<DrawingAction> _redoStack = [];
  List<Offset?> _currentLine = [];
  bool _isErasing = false;
  final double _strokeWidth = 2.0;
  final double _eraserSize = 20.0;
  Offset? _currentEraserPosition;
  List<List<Offset?>> _activePoints = [];
  int _clearShakeTrigger = 0;

  @override
  void initState() {
    super.initState();
    _loadApiUrl();
    _loadStencilImage();
  }

  @override
  void dispose() {
    _sliderTimer?.cancel();
    super.dispose();
  }

  void _startSliderTimer() {
    _sliderTimer?.cancel();
    _sliderTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showOpacitySlider = false;
        });
      }
    });
  }

  Future<void> _loadApiUrl() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _apiUrl = prefs.getString('api_url') ?? _apiUrl;
    });
  }

  Future<void> _loadStencilImage() async {
    try {
      final ByteData data = await rootBundle.load('assets/canvas/face_stencil.png');
      final Uint8List bytes = data.buffer.asUint8List();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      setState(() {
        _stencilImage = frame.image;
      });
    } catch (e) {
      debugPrint('Error loading stencil: $e');
    }
  }

  void _addLine() {
    if (_currentLine.isNotEmpty) {
      setState(() {
        _undoStack.add(DrawingAction(
          isErase: false,
          points: List.from(_currentLine),
        ));
        _activePoints.add(List.from(_currentLine));
        _currentLine = [];
        _redoStack.clear();
      });
    }
  }

  void _undo() {
    if (_undoStack.isNotEmpty) {
      HapticFeedback.lightImpact();
      setState(() {
        final action = _undoStack.removeLast();
        _redoStack.add(action);
        // Remove last drawn stroke only
        _activePoints.removeLast();
      });
    }
  }

  void _redo() {
    if (_redoStack.isNotEmpty) {
      HapticFeedback.lightImpact();
      setState(() {
        final action = _redoStack.removeLast();
        _undoStack.add(action);
        // Re-add the entire stroke
        _activePoints.add(action.points);
      });
    }
  }

  void _toggleEraser() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isErasing = !_isErasing;
      _currentEraserPosition = null;
    });
  }

  Future<void> _clearTemporaryDirectory() async {
    final tempDir = await getTemporaryDirectory();
    final directory = Directory(tempDir.path);

    if (directory.existsSync()) {
      final files = directory.listSync();
      for (var file in files) {
        try {
          if (file is File) {
            await file.delete();
          }
        } catch (e) {
          debugPrint('Error deleting file: $e');
        }
      }
    }

    setState(() {
      _outputImagePath = null;
    });
  }

  Future<void> _generateImage() async {
    try {
      HapticFeedback.heavyImpact();
      await _clearTemporaryDirectory();
      setState(() {
        _isLoading = true;
        _outputImagePath = null;
      });

      // First, check if the API is accessible
      try {
        final healthCheck = await Dio().get(
          '$_apiUrl/health',
          options: Options(
            validateStatus: (status) => true,
            sendTimeout: const Duration(seconds: 5),
            receiveTimeout: const Duration(seconds: 5),
          ),
        );
        
        if (healthCheck.statusCode != 200) {
          throw Exception('API server is not running. Please check your API URL and try again.');
        }
      } catch (e) {
        throw Exception('Cannot connect to the API server. Please check if:\n\n1. The backend server is running\n2. The ngrok URL is up-to-date\n3. Your internet connection is stable');
      }

      final boundary = _drawingKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 2.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final tempFile = File('${tempDir.path}/drawing_$timestamp.png');
      await tempFile.writeAsBytes(byteData!.buffer.asUint8List());

      final ui.Image processedImage = await _processSketchImage(image);
      final processedByteData = await processedImage.toByteData(format: ui.ImageByteFormat.png);
      final processedTempFile = File('${tempDir.path}/processed_drawing_$timestamp.png');
      await processedTempFile.writeAsBytes(processedByteData!.buffer.asUint8List());

      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(processedTempFile.path, filename: 'drawing_$timestamp.png'),
        'gender': _isMaleSelected ? 'male' : 'female',
        'timestamp': timestamp.toString(),
      });

      final response = await Dio().post(
        '$_apiUrl/process-image',
        data: formData,
        options: Options(
          responseType: ResponseType.bytes,
          validateStatus: (status) => status! < 500,
          headers: {
            'Cache-Control': 'no-cache, no-store, must-revalidate',
            'Pragma': 'no-cache',
            'Expires': '0',
          },
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      if (response.statusCode == 500) {
        if (!_isMaleSelected) {
          throw Exception('The female model is currently experiencing issues. Please try using the male model or draw with more defined facial features.');
        } else {
          throw Exception('Failed to process the image. Please try again.');
        }
      }

      if (response.data == null || response.data.length < 100) {  // Basic check for valid image data
        throw Exception('Invalid response from server. Please check if the backend is running properly.');
      }

      final outputFile = File('${tempDir.path}/output_$timestamp.jpg');
      await outputFile.writeAsBytes(response.data);

      // Verify the output file is a valid image
      try {
        final bytes = await outputFile.readAsBytes();
        await decodeImageFromList(bytes);
      } catch (e) {
        throw Exception('Invalid image received from server. Please check if the backend is running properly.');
      }

      if (_outputImagePath != null) {
        try {
          final oldFile = File(_outputImagePath!);
          if (await oldFile.exists()) {
            await oldFile.delete();
          }
        } catch (e) {
          debugPrint('Error deleting old file: $e');
        }
      }

      setState(() {
        _outputImagePath = outputFile.path;
      });
    } catch (e) {
      String errorMessage = e.toString().replaceAll('Exception: ', '');
      _showErrorPopup(context, errorMessage);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<ui.Image> _processSketchImage(ui.Image inputImage) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    const targetSize = Size(512, 512);
    
    final double scale = min(
      targetSize.width / inputImage.width,
      targetSize.height / inputImage.height
    );
    
    final double scaledWidth = inputImage.width * scale;
    final double scaledHeight = inputImage.height * scale;
    
    final double left = (targetSize.width - scaledWidth) / 2;
    final double top = (targetSize.height - scaledHeight) / 2;

    canvas.drawRect(
      Offset.zero & targetSize,
      Paint()..color = Colors.white,
    );

    canvas.drawImageRect(
      inputImage,
      Rect.fromLTWH(0, 0, inputImage.width.toDouble(), inputImage.height.toDouble()),
      Rect.fromLTWH(left, top, scaledWidth, scaledHeight),
      Paint()
        ..filterQuality = FilterQuality.high
        ..isAntiAlias = true,
    );

    final picture = recorder.endRecording();
    final processedImage = await picture.toImage(
      targetSize.width.toInt(),
      targetSize.height.toInt(),
    );

    return processedImage;
  }

  void _showErrorPopup(BuildContext context, String message) {
    // Two quick heavy impacts for error
    HapticFeedback.heavyImpact();
    Future.delayed(const Duration(milliseconds: 100), () {
      HapticFeedback.heavyImpact();
    });

    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Stack(
          children: [
            BackdropFilter(
              filter: ui.ImageFilter.blur(
                sigmaX: 5.0,
                sigmaY: 5.0,
              ),
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: child,
                );
              },
              child: Center(
                child: ShakeWidget(
                  duration: const Duration(milliseconds: 500),
                  shakeOffset: 15.0,
                  shakeCount: 8.0,
                  child: Dialog(
                    backgroundColor: Colors.white.withOpacity(0.95),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Color(0xFFFF5252),
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Error',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _generateImage();
                                },
                                child: const Text(
                                  'Retry',
                                  style: TextStyle(
                                    color: Color(0xFF2C5282),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _resetDrawing() async {
    HapticFeedback.heavyImpact();
    setState(() {
      _clearShakeTrigger++;
    });
    await _clearTemporaryDirectory();
    setState(() {
      _undoStack.clear();
      _redoStack.clear();
      _currentLine.clear();
      _activePoints.clear();
      _outputImagePath = null;
      _currentEraserPosition = null;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Canvas cleared',
            textAlign: TextAlign.center,
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF2C5282),
          margin: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      );
    }
  }

  void _changeApiUrl() async {
    // Two quick heavy impacts
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.heavyImpact();
    
    final apiController = TextEditingController(text: _apiUrl);
    if (!mounted) return;
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Stack(
          children: [
            BackdropFilter(
              filter: ui.ImageFilter.blur(
                sigmaX: 5.0,
                sigmaY: 5.0,
              ),
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: child,
                );
              },
              child: Dialog(
                backgroundColor: Colors.white.withOpacity(0.95),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Change API URL',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: apiController,
                              decoration: const InputDecoration(
                                labelText: 'API URL',
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFbfd7ed),
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFbfd7ed),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.content_paste,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                HapticFeedback.selectionClick();
                                final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
                                if (clipboardData?.text != null) {
                                  apiController.text = clipboardData!.text!;
                                }
                              },
                              tooltip: 'Paste from clipboard',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          TextButton(
                            onPressed: () async {
                              setState(() {
                                _apiUrl = apiController.text.trim();
                              });
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setString('api_url', _apiUrl);
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Save',
                              style: TextStyle(
                                color: Color(0xFF2C5282), // Darker shade of blue
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  bool _segmentIntersectsCircle(Offset p1, Offset p2, Offset center, double radius) {
    final dx = p2.dx - p1.dx;
    final dy = p2.dy - p1.dy;
    final fx = p1.dx - center.dx;
    final fy = p1.dy - center.dy;
    final a = dx * dx + dy * dy;
    final b = 2 * (dx * fx + dy * fy);
    final c = fx * fx + fy * fy - radius * radius;
    double disc = b * b - 4 * a * c;
    if (disc < 0) return false;
    disc = sqrt(disc);
    final t1 = (-b - disc) / (2 * a);
    final t2 = (-b + disc) / (2 * a);
    return (t1 >= 0 && t1 <= 1) || (t2 >= 0 && t2 <= 1);
  }

  void _handleErase(Offset offset) {
    setState(() {
      List<List<Offset?>> updated = [];
      for (var stroke in _activePoints) {
        List<Offset?> segment = [];
        for (int i = 0; i < stroke.length; i++) {
          final point = stroke[i];
          if (point == null) continue;
          bool erasePoint = (point - offset).distance <= _eraserSize / 2;
          if (!erasePoint && i < stroke.length - 1 && stroke[i + 1] != null) {
            // Check if segment intersects eraser circle
            erasePoint = _segmentIntersectsCircle(
                point, stroke[i + 1]!, offset, _eraserSize / 2);
          }
          if (erasePoint) {
            // flush current segment
            if (segment.isNotEmpty) {
              updated.add(segment);
              segment = [];
            }
          } else {
            segment.add(point);
          }
        }
        if (segment.isNotEmpty) updated.add(segment);
      }
      _activePoints = updated;
    });
  }

  /// Save the generated image into the app's local gallery
  Future<void> _saveImage() async {
    if (_outputImagePath == null) return;
    try {
      final outputFile = File(_outputImagePath!);
      final bytes = await outputFile.readAsBytes();

      // Prepare app directory
      final docDir = await getApplicationDocumentsDirectory();
      final galleryDir = Directory('${docDir.path}/saved_images');
      if (!await galleryDir.exists()) {
        await galleryDir.create(recursive: true);
      }
      final filename = 'sketch_${DateTime.now().millisecondsSinceEpoch}.png';
      final savedPath = '${galleryDir.path}/$filename';
      await File(savedPath).writeAsBytes(bytes);

      // Record path in preferences
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList('saved_images') ?? [];
      list.insert(0, savedPath);
      await prefs.setStringList('saved_images', list);

      if (!mounted) return;
      HapticFeedback.mediumImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image saved'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      _showErrorPopup(context, 'Failed to save image');
    }
  }

  /// Navigate to the Saved Images page
  void _showSavedImages() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SavedImagesPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AnimatedTitle(),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            tooltip: 'About',
            onPressed: () {
              HapticFeedback.selectionClick();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.link),
            tooltip: 'Change API URL',
            onPressed: () {
              HapticFeedback.mediumImpact();
              _changeApiUrl();
            },
          ),
          IconButton(
            icon: const Icon(Icons.photo_library),
            tooltip: 'Saved Images',
            onPressed: _showSavedImages,
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 1,
                child: Stack(
                  children: [
                    if (_outputImagePath != null) ...[
                      Image.file(
                        File(_outputImagePath!),
                        height: double.infinity,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 16,
                        right: 16,
                        child: FloatingActionButton(
                          heroTag: 'save_overlay',
                          mini: true,
                          backgroundColor: Colors.black54,
                          child: const Icon(
                            Icons.save,
                            size: 20,
                            color: Colors.white,
                          ),
                          onPressed: _saveImage,
                        ),
                      ),
                    ] else if (_isLoading)
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        period: const Duration(milliseconds: 800),
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.white,
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: CircularProgressIndicator(
                                    color: Color(0xFFbfd7ed),
                                    strokeWidth: 3,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Generating photorealistic image...',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'This may take a few moments',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    else
                      Center(
                        child: Shimmer.fromColors(
                          period: const Duration(seconds: 3),
                          baseColor: const Color(0xFF2C3E50),  // deep blue
                          highlightColor: const Color(0xFFC0392B),  // deep red
                          child: const Text(
                            'Generated photorealistic image \n appears here',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                color: const Color(0xFFbfd7ed),
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.undo,
                              color: _undoStack.isEmpty ? Colors.grey : Colors.white),
                          onPressed: _undoStack.isEmpty ? null : _undo,
                          tooltip: 'Undo',
                        ),
                        IconButton(
                          icon: Icon(Icons.redo,
                              color: _redoStack.isEmpty ? Colors.grey : Colors.white),
                          onPressed: _redoStack.isEmpty ? null : _redo,
                          tooltip: 'Redo',
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                      child: VerticalDivider(
                        color: Colors.white,
                        thickness: 1,
                      ),
                    ),
                    GenderSwitch(
                      value: _isMaleSelected,
                      onChanged: (bool value) {
                        HapticFeedback.mediumImpact();
                        setState(() {
                          _isMaleSelected = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 30,
                      child: VerticalDivider(
                        color: Colors.white,
                        thickness: 1,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: !_isErasing 
                                ? Colors.white.withOpacity(0.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: AnimatedScale(
                            scale: !_isErasing ? 1.1 : 1.0,
                            duration: const Duration(milliseconds: 200),
                            child: IconButton(
                              icon: SvgPicture.asset(
                                'assets/icons/pen_icon.svg',
                                colorFilter: ColorFilter.mode(
                                  !_isErasing ? Colors.white : Colors.grey.withOpacity(0.5),
                                  BlendMode.srcIn,
                                ),
                                width: 24,
                                height: 24,
                              ),
                              onPressed: () {
                                if (_isErasing) {
                                  HapticFeedback.mediumImpact();
                                  _toggleEraser();
                                }
                              },
                              tooltip: 'Draw',
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: _isErasing 
                                ? Colors.white.withOpacity(0.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: AnimatedScale(
                            scale: _isErasing ? 1.1 : 1.0,
                            duration: const Duration(milliseconds: 200),
                            child: IconButton(
                              icon: SvgPicture.asset(
                                'assets/icons/eraser_icon.svg',
                                colorFilter: ColorFilter.mode(
                                  _isErasing ? Colors.white : Colors.grey.withOpacity(0.5),
                                  BlendMode.srcIn,
                                ),
                                width: 24,
                                height: 24,
                              ),
                              onPressed: () {
                                if (!_isErasing) {
                                  HapticFeedback.mediumImpact();
                                  _toggleEraser();
                                }
                              },
                              tooltip: 'Erase',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Stack(
                  children: [
                    RepaintBoundary(
                      key: _drawingKey,
                      child: Container(
                        color: Colors.white,
                        child: GestureDetector(
                          onPanStart: (details) {
                            _currentLine = [];
                            if (_isErasing) {
                              final RenderBox renderBox =
                              _drawingKey.currentContext!.findRenderObject() as RenderBox;
                              _currentEraserPosition = renderBox.globalToLocal(details.globalPosition);
                            }
                          },
                          onPanUpdate: (details) {
                            final RenderBox renderBox =
                                _drawingKey.currentContext!.findRenderObject() as RenderBox;
                            final offset = renderBox.globalToLocal(details.globalPosition);

                            if (offset.dy >= renderBox.size.height / 16) {
                              if (_isErasing) {
                                setState(() {
                                  _currentEraserPosition = offset;
                                  _handleErase(offset);
                                });
                              } else {
                                setState(() {
                                  _currentLine.add(offset);
                                });
                              }
                            }
                          },
                          onPanEnd: (details) {
                            if (!_isErasing) {
                              _addLine();
                            }
                            _currentEraserPosition = null;
                          },
                          child: CustomPaint(
                            painter: _FacePainter(
                              points: [..._activePoints, if (!_isErasing) _currentLine],
                              strokeWidth: _strokeWidth,
                              drawingColor: Colors.black,
                              isErasing: _isErasing,
                              eraserPosition: _currentEraserPosition,
                              eraserSize: _eraserSize,
                              stencilImage: _showStencil ? _stencilImage : null,
                              stencilOpacity: _stencilOpacity,
                            ),
                            child: Container(),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                HapticFeedback.selectionClick();
                                setState(() {
                                  _showStencil = !_showStencil;
                                });
                              },
                              onLongPress: () {
                                HapticFeedback.mediumImpact();
                                setState(() {
                                  _showOpacitySlider = true;
                                });
                                _startSliderTimer();
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: _showStencil 
                                      ? const Color(0xFFbfd7ed).withOpacity(0.9)
                                      : Colors.grey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  Icons.face,
                                  color: _showStencil ? Colors.white : Colors.grey[600],
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                          if (_showOpacitySlider)
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              margin: const EdgeInsets.only(top: 8, right: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFbfd7ed).withOpacity(0.9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'Opacity',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 100,
                                    width: 30,
                                    child: RotatedBox(
                                      quarterTurns: -1,
                                      child: SliderTheme(
                                        data: SliderThemeData(
                                          trackHeight: 4,
                                          activeTrackColor: Colors.white,
                                          inactiveTrackColor: Colors.white.withOpacity(0.3),
                                          thumbColor: Colors.white,
                                          overlayColor: Colors.white.withOpacity(0.1),
                                          thumbShape: const RoundSliderThumbShape(
                                            enabledThumbRadius: 6,
                                          ),
                                          overlayShape: const RoundSliderOverlayShape(
                                            overlayRadius: 12,
                                          ),
                                        ),
                                        child: Slider(
                                          value: _stencilOpacity,
                                          min: 0.05,
                                          max: 0.3,
                                          onChanged: (value) {
                                            setState(() {
                                              _stencilOpacity = value;
                                            });
                                            _startSliderTimer();
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.transparent,
              ),
            ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              heroTag: 'generate_fab',
              onPressed: _isLoading ? null : _generateImage,
              backgroundColor: const Color(0xFFbfd7ed),
              child: Shimmer.fromColors(
                period: const Duration(seconds: 3),
                baseColor: const Color(0xFF2C3E50),  // deep blue
                highlightColor: const Color(0xFFC0392B),  // deep red
                child: const Icon(
                  Icons.auto_awesome,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: ShakeWidget(
              key: ValueKey(_clearShakeTrigger),
              shakeOffset: 8.0,
              shakeCount: 4.0,
              duration: const Duration(milliseconds: 500),
              child: FloatingActionButton(
                heroTag: 'delete_fab',
                onPressed: _resetDrawing,
                backgroundColor: const Color(0xFFbfd7ed),
                child: const Icon(
                  Icons.delete,
                  size: 30,
                  color: Color(0xFFFF5252),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FacePainter extends CustomPainter {
  final List<List<Offset?>> points;
  final double strokeWidth;
  final Color drawingColor;
  final bool isErasing;
  final Offset? eraserPosition;
  final double eraserSize;
  final ui.Image? stencilImage;
  final double stencilOpacity;

  _FacePainter({
    required this.points,
    required this.strokeWidth,
    required this.drawingColor,
    this.isErasing = false,
    this.eraserPosition,
    this.eraserSize = 20.0,
    this.stencilImage,
    this.stencilOpacity = 0.15,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw stencil first with custom opacity
    if (stencilImage != null) {
      final double stencilWidth = size.width * 0.6;
      final double stencilHeight = stencilImage!.height * (stencilWidth / stencilImage!.width);
      
      final double x = (size.width - stencilWidth) / 2;
      final double y = (size.height * 0.45) - (stencilHeight / 2);
      
      final paint = Paint()
        ..color = Colors.grey.withOpacity(stencilOpacity)
        ..filterQuality = FilterQuality.high;
      
      canvas.drawImageRect(
        stencilImage!,
        Rect.fromLTWH(0, 0, stencilImage!.width.toDouble(), stencilImage!.height.toDouble()),
        Rect.fromLTWH(x, y, stencilWidth, stencilHeight),
        paint,
      );
    }

    // Draw user strokes
    final paint = Paint()
      ..color = drawingColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    for (var line in points) {
      if (line.isNotEmpty) {
        for (var i = 0; i < line.length - 1; i++) {
          if (line[i] != null && line[i + 1] != null) {
            canvas.drawLine(line[i]!, line[i + 1]!, paint);
          }
        }
      }
    }

    if (isErasing && eraserPosition != null) {
      final eraserPaint = Paint()
        ..color = Colors.grey.withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      canvas.drawCircle(eraserPosition!, eraserSize / 2, eraserPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SketchXtract',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Version 1.0',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'SketchXtract is an advanced forensic tool designed for law enforcement and criminal investigations. It transforms witness-described facial sketches into photorealistic images using AI technology, enhancing suspect identification when photographic evidence is unavailable.\n\nThis tool bridges the gap between witness descriptions and real-world identification, providing investigators with more accurate visual representations for their cases.',
              style: TextStyle(
                height: 1.5,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Page to view images saved in-app
class SavedImagesPage extends StatefulWidget {
  const SavedImagesPage({super.key});

  @override
  State<SavedImagesPage> createState() => _SavedImagesPageState();
}

class _SavedImagesPageState extends State<SavedImagesPage> {
  List<String> _saved = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _saved = prefs.getStringList('saved_images') ?? [];
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Images')),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFbfd7ed)))
          : _saved.isEmpty
          ? const Center(child: Text('No saved images found', style: TextStyle(color: Colors.grey)))
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: _saved.length,
              itemBuilder: (context, index) {
                final path = _saved[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Scaffold(
                          appBar: AppBar(),
                          body: Center(child: Image.file(File(path), fit: BoxFit.contain)),
                        ),
                      ),
                    );
                  },
                  child: Image.file(File(path), fit: BoxFit.cover),
                );
              },
            ),
    );
  }
}