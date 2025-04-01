import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medir_tatuagem/main.dart';
import 'package:medir_tatuagem/tela_edicao.dart';

void main() {

  test('Cálculo de pixels por cm na TelaEdicao', () {
    final measurement = Measurement(Offset(0, 0), Offset(0, 100), 10, Colors.red);
    expect(measurement.sizeCm, 10);
  });
}

