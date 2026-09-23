import 'package:flutter_test/flutter_test.dart';
import 'package:turnia_app/main.dart';

void main() {
  testWidgets('La app arranca en el splash con el logo de Turnia', (WidgetTester tester) async {
    await tester.pumpWidget(const TurniaApp());
    expect(find.text('Turnia'), findsOneWidget);
    expect(find.text('Tu agenda, simple y ordenada'), findsOneWidget);
  });
}