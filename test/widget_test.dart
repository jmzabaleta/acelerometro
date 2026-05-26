import 'package:flutter_test/flutter_test.dart';

import 'package:acelerometro/main.dart';

void main() {
  testWidgets('shows the tilt ball screen', (WidgetTester tester) async {
    await tester.pumpWidget(const TiltBallApp());

    expect(find.text('Tilt Ball - Demo Acelerometro'), findsOneWidget);
    expect(find.text('Inclina el celular para mover la bola'), findsOneWidget);
    expect(find.text('Reiniciar'), findsOneWidget);
  });
}
