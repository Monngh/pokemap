import 'package:flutter/material.dart';

class SplitScreenDemo extends StatefulWidget {
  const SplitScreenDemo({super.key});

  @override
  _SplitScreenDemoState createState() => _SplitScreenDemoState();
}

class _SplitScreenDemoState extends State<SplitScreenDemo> {
  bool _capturado = false;
  double _leftImageX = 0;
  double _rightImageX =
      0; // ajusta este valor según la posición inicial de la imagen derecha

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top side
        Expanded(
          flex: 5,
          child: Container(
            color: Colors.grey[200],
            child: Text("Top Side Content"),
          ),
        ),

        // Bottom side
        Expanded(
          flex: 3,
          child: Container(
            color: Colors.blue[50],
            child: Stack(
              children: [
                _capturado
                    ? Center(
                        child: Text("Capturado!"),
                      )
                    : Container(),
                AnimatedPositioned(
                  duration: Duration(milliseconds: 500),
                  right: _rightImageX,
                  child: SizedBox(
                    width: 100, // ancho de la imagen
                    height: 100, // alto de la imagen
                    child: Image.asset('assets/sad.jpg',
                        fit: BoxFit
                            .cover), // reemplaza con la ruta de la imagen derecha
                  ),
                ),
                AnimatedPositioned(
                  duration: Duration(milliseconds: 500),
                  left: _leftImageX,
                  child: SizedBox(
                    width: 50, // ancho de la imagen
                    height: 50, // alto de la imagen
                    child: Image.asset('assets/sprite1.gif',
                        fit: BoxFit
                            .cover), // reemplaza con la ruta de la imagen izquierda
                  ),
                ),
                Positioned(
                  top: 50, // ajusta este valor según la posición del botón
                  left: 100, // ajusta este valor según la posición del botón
                  child: ElevatedButton(
                    onPressed: _handleCaptureButtonPress,
                    child: Text("Capturar"),
                  ),
                ),
                Positioned(
                  top: 100, // ajusta este valor según la posición del botón
                  left: 100, // ajusta este valor según la posición del botón
                  child: ElevatedButton(
                    onPressed: _resetAnimation,
                    child: Text("Reiniciar"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _handleCaptureButtonPress() {
    setState(() {
      _leftImageX =
          300; // ajusta este valor según la posición final de la imagen izquierda
      _capturado = true;
    });
  }

  void _resetAnimation() {
    setState(() {
      _leftImageX = 0;
      _capturado = false;
    });
  }
}
