import 'dart:async';

import 'package:sensors_plus/sensors_plus.dart';

class MotionSample {
  const MotionSample(this.x, this.y, this.z);

  final double x;
  final double y;
  final double z;
}

Future<bool> requestMotionPermission() async => true;

Stream<MotionSample> motionSamples() {
  return accelerometerEventStream().map(
    (event) => MotionSample(event.x, event.y, event.z),
  );
}
