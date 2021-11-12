// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/line_scale_pulse_out_indicator.dart';

// This class takes care of dots animation that shows whether some radio station is playing or not.

class PausedStatus extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final dots = List.generate(5, (_) {
      return Padding(
        padding: const EdgeInsets.all(0.8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.secondary,
          ),
          height: 4,
          width: 4,
        ),
      );
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: dots,
    );
  }
}

class PlayingStatus extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Loading(
      indicator: LineScalePulseOutIndicator(),
      size: 30,
      color: Theme.of(context).colorScheme.secondary,
    );
  }
}

