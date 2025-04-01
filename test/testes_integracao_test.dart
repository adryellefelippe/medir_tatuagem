import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:medir_tatuagem/tela_edicao.dart';
import 'dart:io';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Teste de edição e medição na TelaEdicao', (WidgetTester tester) async {
    final File testImage = File('test/assets/test_image.png');
    await tester.pumpWidget(MaterialApp(home: TelaEdicao(testImage)));

    // Verifica se a imagem foi carregada
    expect(find.byType(Image), findsOneWidget);

    // Simula um toque para marcar um ponto de medição
    await tester.tap(find.byType(GestureDetector).first);
    await tester.pump();

    // Simula um segundo toque para definir o tamanho
    await tester.tap(find.byType(GestureDetector).first);
    await tester.pumpAndSettle();

    // Verifica se a medição foi adicionada
    expect(find.byType(CustomPaint), findsWidgets);
  });
}
