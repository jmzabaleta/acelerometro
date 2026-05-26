import 'dart:async';
import 'dart:html' as html;
import 'dart:js_util' as js_util;

class MotionSample {
  const MotionSample(this.x, this.y, this.z);

  final double x;
  final double y;
  final double z;
}

Future<bool> requestMotionPermission() async {
  final bridge = js_util.getProperty<Object?>(html.window, 'tiltBallMotion');
  if (bridge == null) return false;

  final result = js_util.callMethod<Object?>(bridge, 'start', const []);
  if (result == null) return false;

  final allowed = await js_util.promiseToFuture<Object?>(result);
  return allowed == true;
}

Stream<MotionSample> motionSamples() {
  return html.window.on['tilt-ball-motion'].map((event) {
    final customEvent = event as html.CustomEvent;
    final detail = customEvent.detail as Object;
    final x = _readNumber(detail, 'x');
    final y = _readNumber(detail, 'y');
    final z = _readNumber(detail, 'z');

    return MotionSample(x, y, z);
  });
}

double _readNumber(Object source, String key) {
  final value = js_util.getProperty<Object?>(source, key);
  if (value is num) return value.toDouble();
  return 0.0;
}
