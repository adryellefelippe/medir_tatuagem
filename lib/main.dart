import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'tela_edicao.dart';

void main() {
  runApp(MaterialApp(home: TattoMeasure()));
}

class TattoMeasure extends StatelessWidget {
  const TattoMeasure({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Scaffold(body: ListView(children: [TelaInicial(title: "Tattoo")])),
    );
  }
}

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key, required this.title});

  final String title;

  @override
  State<TelaInicial> createState() => _TelaInicial();
}

class _TelaInicial extends State<TelaInicial> {
  final imagePicker = ImagePicker();
  File? imageFile;

  pick(ImageSource source) async {
    final pickedFile = await imagePicker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Container(
          width: width,
          height: height,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Colors.white),
          child: Stack(
            children: [
              Positioned(
                left: 130,
                top: height * 0.36,
                child: SizedBox(
                  width: 241,
                  height: 106,
                  child: Text(
                    'Ink.Vitu',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF2F4156),
                      fontSize: 62,
                      fontFamily: 'Josefin Sans',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: Column(children: [Image.asset('image/01.Header.png')]),
              ),
              Positioned(
                left: (width / 2) - (224 / 2),
                top: height * 0.84,
                child: SizedBox(
                  width: 224,
                  height: 27,
                  child: ElevatedButton(
                    onPressed: () async {
                      await pick(ImageSource.gallery);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TelaEdicao(imageFile),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent, // Fundo transparente
                      shadowColor: Colors.transparent, // Sem sombra do botão
                      padding: EdgeInsets.zero, // Sem padding extra
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ), // Sem bordas arredondadas
                    ),
                    child: Text(
                      'Selecionar da Galeria',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFB7A7A9),
                        fontSize: 18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        shadows: [
                          Shadow(
                              offset: Offset(0, 1),
                              blurRadius: 2,
                              color: Color(0xFF000000).withValues(alpha: (0.25 * 255))
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: (width / 2) - (240 / 2),
                top: height * 0.75,
                child: SizedBox(
                  width: 240,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () async {
                      await pick(ImageSource.camera);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TelaEdicao(imageFile),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2F4156), // Cor do botão
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          20,
                        ), // Borda arredondada
                      ),
                      shadowColor: Color(0x3F000000), // Cor da sombra
                      elevation: 4, // Intensidade da sombra
                    ),
                    child: Text(
                      "Capturar Imagem", // Texto do botão
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: (width / 2) - (254 / 2),
                top: height * 0.65,
                child: SizedBox(
                  width: 254,
                  height: 55,
                  child: Text(
                    'Bora descorbir o tamanho para sua tattoo?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF292421),
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

