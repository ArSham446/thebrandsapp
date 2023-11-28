import 'package:flutter/material.dart';

class OrangeButton extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final double width;
  const OrangeButton(
      {Key? key,
      required this.label,
      required this.onPressed,
      required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: MediaQuery.of(context).size.width * width,
      decoration: BoxDecoration(
          color: Colors.orange, borderRadius: BorderRadius.circular(20,)),
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
