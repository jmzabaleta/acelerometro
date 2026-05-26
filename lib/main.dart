import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(const TiltBallApp());
}

class TiltBallApp extends StatelessWidget {
  const TiltBallApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tilt Ball',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F1113),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.tealAccent.shade200,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const TiltBallPage(),
    );
  }
}

class TiltBallPage extends StatefulWidget {
  const TiltBallPage({super.key});

  @override
  State<TiltBallPage> createState() => _TiltBallPageState();
}

class _TiltBallPageState extends State<TiltBallPage> {
  late StreamSubscription<AccelerometerEvent> _sub;
  double _ax = 0.0;
  double _ay = 0.0;

  // Alignment coordinates in range [-1, 1]
  double _alignX = 0.0;
  double _alignY = 0.0;

  // Sensitivity tuning — lower value = less movement
  final double _sensitivity = 0.12;

  @override
  void initState() {
    super.initState();
    _sub = accelerometerEvents.listen((event) {
      // Map raw sensor values to desired alignment range and update state
      setState(() {
        _ax = event.x;
        _ay = event.y;

        // In many devices: tilting right increases negative x, so we invert x
        _alignX = (_ax * -_sensitivity).clamp(-1.0, 1.0);
        // Tilt forward/back often maps to y - we use positive -> down on screen
        _alignY = (_ay * _sensitivity).clamp(-1.0, 1.0);
      });
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  void _resetBall() {
    setState(() {
      _alignX = 0.0;
      _alignY = 0.0;
      _ax = 0.0;
      _ay = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tilt Ball — Demo Acelerómetro'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Inclina el celular para mover la bola',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 12),

              // Zona de movimiento
              Expanded(
                child: Center(
                  child: LayoutBuilder(builder: (context, constraints) {
                    final zoneSize = constraints.biggest.shortestSide * 0.95;
                    return Container(
                      width: zoneSize,
                      height: zoneSize,
                      decoration: BoxDecoration(
                        color: const Color(0xFF121417),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.6),
                            offset: const Offset(0, 6),
                            blurRadius: 20,
                          )
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Smooth animated alignment
                          AnimatedAlign(
                            alignment: Alignment(_alignX, _alignY),
                            duration: const Duration(milliseconds: 120),
                            curve: Curves.easeOutCubic,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [accent.withOpacity(0.95), Colors.white],
                                    stops: const [0.0, 1.0],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: accent.withOpacity(0.4),
                                      blurRadius: 18,
                                      spreadRadius: 1,
                                    )
                                  ],
                                ),
                                child: const SizedBox(width: 48, height: 48),
                              ),
                            ),
                          ),

                          // Subtle center crosshair
                          Center(
                            child: IgnorePointer(
                              child: Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Colors.white12,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 12),

              // Valores y controles
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('X: ${_ax.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white70)),
                      Text('Y: ${_ay.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: _resetBall,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      foregroundColor: Colors.black,
                    ),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reiniciar'),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Sección extra explicativa
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0B0C0D),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('¿Qué es el acelerómetro?', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    SizedBox(height: 6),
                    Text('Sensor que mide la aceleración del dispositivo en m/s².', style: TextStyle(color: Colors.white70)),
                    SizedBox(height: 8),
                    Text('Ejes:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    SizedBox(height: 6),
                    Text('• X: movimiento lateral (izquierda/derecha).', style: TextStyle(color: Colors.white70)),
                    Text('• Y: movimiento adelante/atrás (inclinación).', style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
