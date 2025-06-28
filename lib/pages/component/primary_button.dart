import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget{
  final VoidCallback onPressed;

  const PrimaryButton({super.key, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).highlightColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)
          )
      ),
      child: Text("Add",style: TextStyle(
          color: Theme.of(context).colorScheme.surface
      )),
    );
  }
}