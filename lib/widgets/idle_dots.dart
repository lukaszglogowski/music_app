// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class IdleDots extends StatelessWidget {
  final Color color;
  IdleDots({this.color = Colors.grey});

  @override
  Widget build(BuildContext context) {
    final dots = List.generate(5, (_) {
      return Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Theme.of(context).colorScheme.secondary),
          height: 15,
          width: 15,
        ),
      );
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: dots,
    );
  }
}