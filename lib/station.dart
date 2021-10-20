// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:equatable/equatable.dart';

class Station extends Equatable {
  final String radioUrl;
  final String imageUrl;
  final String name;

  Station(this.radioUrl, this.imageUrl, this.name);

  @override
  List<Object>get props => [radioUrl, imageUrl, name];
}

