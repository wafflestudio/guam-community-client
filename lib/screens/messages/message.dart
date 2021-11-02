import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Message extends StatelessWidget {
  bool newMessage = true;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: SvgPicture.asset(
          newMessage
            ? 'assets/icons/message_new.svg'
            : 'assets/icons/message_default.svg',
          width: 24,
          height: 24,
        ),
    onPressed: () {}
    );
  }
}
