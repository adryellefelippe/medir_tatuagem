import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

class TelaEdicao extends StatelessWidget {
  final File? imageFile;

  const TelaEdicao(this.imageFile, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: _TelaEdicao(imageFile));
  }
}

class _TelaEdicao extends StatefulWidget {
  final File? imageFile;

  const _TelaEdicao(this.imageFile);

  @override
  _TelaEdicaoState createState() => _TelaEdicaoState();
}

class _TelaEdicaoState extends State<_TelaEdicao> {
  late GlobalKey key1;
  bool isSelecting = false;
  bool selectingReference = true;
  Offset? startPosition;
  Offset? endPosition;
  double? referenceSizeCm;
  double? pixelsPerCm;
  List<Measurement> measurements = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text("Edição"),
        backgroundColor: Color(0xFF2F4156),
        toolbarHeight: 50,
      ),
      body: Stack(
        children: [
          if (widget.imageFile != null)
            Positioned.fill(
              child: Image.file(
                widget.imageFile!,
                fit: BoxFit.cover,
              ),
            )
          else
            Center(
              child: Text(
                "Nenhuma imagem selecionada",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
          for (var measurement in measurements)
            Positioned.fill(
              child: CustomPaint(
                painter: MeasurementPainter(measurement),
              ),
            ),
          if (startPosition != null && endPosition != null && isSelecting)
          // Aqui desenhamos a linha enquanto o usuário arrasta
            Positioned.fill(
              child: CustomPaint(
                painter: MeasurementPainter(
                  Measurement(startPosition!, endPosition!, 0.0, Colors.grey),
                ),
              ),
            ),
          GestureDetector(
            onPanStart: (details) {
              if (isSelecting) {
                setState(() {
                  startPosition = details.localPosition;
                  endPosition = details.localPosition;
                });
              }
            },
            onPanUpdate: (details) {
              if (isSelecting) {
                setState(() {
                  endPosition = details.localPosition;
                });
              }
            },
            onPanEnd: (details) {
              if (isSelecting) {
                setState(() {
                  isSelecting = false;
                });
                _askUserForMeasurementSize();
              }
            },
            child: Container(color: Colors.transparent),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0xFF2F4156),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.straighten, color: Colors.white),
              onPressed: () {
                setState(() {
                  isSelecting = true;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.white),
              onPressed: () {
                setState(() {
                  if (measurements.isNotEmpty && measurements.length > 1) {
                    // Indica que está apagando a media anterior e não é a de referencia
                    measurements.removeLast();
                  } else {
                    // Se a medição de referência for apagada, apaga todas
                    measurements.clear();
                    selectingReference =
                    true; // A próxima medição será a de referência
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _askUserForMeasurementSize() {
    if (selectingReference) {
      // Só pede o valor para a primeira medição
      showDialog(
        context: context,
        builder: (context) {
          TextEditingController controller = TextEditingController();
          return AlertDialog(
            title: Text("Definir tamanho da referência"),
            content: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Digite a altura em cm",
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancelar"),
              ),
              TextButton(
                onPressed: () {
                  double? enteredSize = double.tryParse(controller.text);
                  if (enteredSize != null) {
                    setState(() {
                      double pixelHeight = (endPosition!.dy - startPosition!.dy)
                          .abs() * 1.05;
                      referenceSizeCm = enteredSize;
                      pixelsPerCm = pixelHeight / referenceSizeCm!;
                      measurements.add(Measurement(
                          startPosition!, endPosition!, enteredSize,
                          Colors.red));
                      selectingReference =
                      false; // Impede novas medições de pedirem o valor
                    });
                  }
                  Navigator.pop(context);
                },
                child: Text("Confirmar"),
              ),
            ],
          );
        },
      );
    } else {
      // Se não for a medição de referência, calcula diretamente o valor sem pedir ao usuário
      double pixelHeight = (endPosition!.dy - startPosition!.dy).abs() * 1.05;
      double realSizeCm = pixelHeight / pixelsPerCm!;
      measurements.add(
          Measurement(startPosition!, endPosition!, realSizeCm, Colors.blue));
    }
  }
}

class Measurement {
  final Offset start;
  final Offset end;
  final double sizeCm;
  final Color color;

  Measurement(this.start, this.end, this.sizeCm, this.color);
}

class MeasurementPainter extends CustomPainter {
  final Measurement measurement;

  MeasurementPainter(this.measurement);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = measurement.color
      ..strokeWidth = 4;

    // Desenhar a linha
    canvas.drawLine(measurement.start, measurement.end, paint);

    // Calcular a posição do texto ao lado da linha
    double textX = (measurement.start.dx + measurement.end.dx) / 2 + 10; // 10 para deixar um espaço
    double textY = (measurement.start.dy + measurement.end.dy) / 2;

    TextSpan span = TextSpan(
      style: TextStyle(color: measurement.color, fontSize: 14, fontWeight: FontWeight.bold),
      text: "${measurement.sizeCm.toStringAsFixed(2)} cm",
    );
    TextPainter tp = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas, Offset(textX, textY));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
