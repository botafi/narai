import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:narai/etc/theme.dart';

class StarsWidget extends StatelessWidget {
  double size;
  int numOfStars;
  int stars;
  StarsWidget(this.stars, {this.numOfStars = 3, this.size = 24});
  Widget build(BuildContext context) {
    return Container(
      width: size * 3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List<Widget>.generate(numOfStars, (i) =>  Stack(
            children: [
              i < stars ?
              Icon(Icons.star, color: Colors.yellow, size: size)
              :
              Icon(Icons.star, color: Colors.grey, size: size / 1.2),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: i < stars ?
                  Icon(Icons.star, color: Colors.yellow, size: size)
                  :
                  Container(width: 0, height: 0),
              ),
            ]
          ))
      )
    );
  }
}