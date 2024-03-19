import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// ignore: must_be_immutable
class SmallCards extends StatelessWidget {
  SmallCards({super.key, required this.image});
  String? image;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              image!,
              width: 166,
              height: 160,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'أساسيات مقاومة المواد #2',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(
                'مرحلة ثانية | فصل اول صباحي',
                style: TextStyle(
                    fontSize: 10,
                    color: const Color.fromARGB(255, 108, 108, 108)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
