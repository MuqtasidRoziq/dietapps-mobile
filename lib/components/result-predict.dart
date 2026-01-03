import 'dart:ui';
import 'package:flutter/material.dart';

Widget buildResultRow(
  IconData icon,
  String label,
  String value,
  Color statusColor,
) {
  return Row(
    children: [
      CircleAvatar(
        backgroundColor: statusColor.withOpacity(0.1),
        child: Icon(icon, color: statusColor),
      ),
      const SizedBox(width: 15),
      Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      const Spacer(),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          value,
          style: TextStyle(
            color: statusColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    ],
  );
}
