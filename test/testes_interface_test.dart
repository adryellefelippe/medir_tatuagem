import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medir_tatuagem/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Verifica a tela inicial', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: TattoMeasure()));

    // Verifica se o título da tela aparece
    expect(find.text('Ink.Vitu'), findsOneWidget);

    // Verifica se o botão "Selecionar da Galeria" aparece
    expect(find.text('Selecionar da Galeria'), findsOneWidget);

    // Verifica se o botão "Capturar Imagem" aparece
    expect(find.text('Capturar Imagem'), findsOneWidget);

    // Verifica se a imagem do header está visível
    expect(find.byType(Image), findsOneWidget);
  });

}
