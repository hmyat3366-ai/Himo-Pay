import 'package:flutter/material.dart';

class ServiceItemModel {
  final String id;
  final String title;
  final IconData icon;
  final String routeName;
  final Color? color;

  const ServiceItemModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.routeName,
    this.color,
  });
}
