import 'package:flutter_test/flutter_test.dart';
import 'package:temu_batik/src/app.dart';

void main() {
  testWidgets('Temu Batik app loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const TemuBatikApp());

    expect(find.text('Deteksi'), findsOneWidget);
  });
}
