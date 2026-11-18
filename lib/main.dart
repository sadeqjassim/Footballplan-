
import 'package:flutter/material.dart';

void main() {
  runApp(const FootballPlanApp());
}

class FootballPlanApp extends StatelessWidget {
  const FootballPlanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'خطة كرة القدم',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const PitchScreen(),
    );
  }
}

class PlayerData {
  String name;
  Offset position;
  PlayerData(this.name, this.position);
}

class PitchScreen extends StatefulWidget {
  const PitchScreen({super.key});

  @override
  State<PitchScreen> createState() => _PitchScreenState();
}

class _PitchScreenState extends State<PitchScreen> {
  // تشكيلة 7 لاعبين بتوزيع تكتيكي دقيق وعالي الجودة
  final List<PlayerData> _players = [
    PlayerData('حارس', const Offset(180, 520)), // حارس المرمى
    PlayerData('مدافع يمين', const Offset(80, 380)),
    PlayerData('مدافع يسار', const Offset(280, 380)),
    PlayerData('وسط ارتكاز', const Offset(180, 280)),
    PlayerData('وسط يمين', const Offset(70, 180)),
    PlayerData('وسط يسار', const Offset(290, 180)),
    PlayerData('مهاجم', const Offset(180, 90)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تكتيك تشكيلة 7 لاعبين'),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: InteractiveViewer(
          boundaryMargin: const EdgeInsets.all(20),
          minScale: 0.8,
          maxScale: 2.5,
          child: Container(
            width: 360,
            height: 640,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade700, Colors.green.shade900],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              border: Border.all(color: Colors.white, width: 3),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ],
            ),
            child: Stack(
              children: [
                // رسم خطوط الملعب بتفاصيل عالية
                CustomPaint(
                  size: const Size(360, 640),
                  painter: PitchPainter(),
                ),
                // اللاعبون القابلون للسحب والإفلات
                for (int i = 0; i < _players.length; i++)
                  Positioned(
                    left: _players[i].position.dx - 30,
                    top: _players[i].position.dy - 30,
                    child: Draggable(
                      feedback: PlayerWidget(name: _players[i].name, isDragging: true),
                      childWhenDragging: Container(),
                      onDragEnd: (details) {
                        setState(() {
                          final RenderBox renderBox = context.findRenderObject() as RenderBox;
                          final localOffset = renderBox.globalToLocal(details.offset);
                          // الحفاظ على اللاعب داخل حدود الملعب
                          double newX = localOffset.dx.clamp(30.0, 330.0);
                          double newY = localOffset.dy.clamp(50.0, 600.0);
                          _players[i].position = Offset(newX, newY);
                        });
                      },
                      child: PlayerWidget(name: _players[i].name, isDragging: false),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// رسم تخطيط الملعب (المنتطق، المنتصف، والرميات)
class PitchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // خط المنتصف
    canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);
    
    // دائرة المنتصف
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 50, paint);

    // منطقة الجزاء العلوي (المرمى)
    canvas.drawRect(Rect.fromLTWH(size.width / 2 - 80, 0, 160, 100), paint);

    // منطقة الجزاء السفلي
    canvas.drawRect(Rect.fromLTWH(size.width / 2 - 80, size.height - 100, 160, 100), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// شكل تصميم اللاعب على الملعب
class PlayerWidget extends StatelessWidget {
  final String name;
  final bool isDragging;

  const PlayerWidget({super.key, required this.name, required this.isDragging});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isDragging ? 0.6 : 1.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.amber.shade600,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.5),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
              ],
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              name,
              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ],

        
