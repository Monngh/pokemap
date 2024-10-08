import 'package:flutter/material.dart';

class CustomMarkerWidget extends StatelessWidget {
  final double price;
  const CustomMarkerWidget({
    super.key,
    required this.price,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      width: 75,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Align(
            alignment: Alignment.bottomCenter,
            child: Icon(
              Icons.arrow_drop_down,
              color: Colors.black,
              size: 50,
            ),
          ),
          Container(
              margin: const EdgeInsets.only(bottom: 15.0),
              padding: const EdgeInsets.all(5.0),
              color: Colors.black,
              child: Text(
                '\$$price',
                style: const TextStyle(
                    color: Colors.white), // Text ), // Container Colors.white),
              ))
        ],
      ),
    ); // Stack ); // SizedBox
  }
}
