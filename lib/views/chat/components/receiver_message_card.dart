import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:whatsapp_clone/models/message_model.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/views/chat/components/custom_painter.dart';
import 'package:whatsapp_clone/views/chat/components/display_message_type.dart';

class ReceiverMessageCard extends StatefulWidget {
 final Message message;
  final UserModel receiverUserModel;

  const ReceiverMessageCard({
    super.key,
    required this.message,
    required this.receiverUserModel,
  });

  @override
  State<ReceiverMessageCard> createState() => _ReceiverMessageCardState();
}

class _ReceiverMessageCardState extends State<ReceiverMessageCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
   padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(math.pi),
            child: CustomPaint(
              painter: Triangle  (const Color(0xFF3c6fe1),),
            ),
          ),
          Flexible(
            child: Container(
               padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 5),
              decoration: const BoxDecoration(
                color: Color(0xFF3c6fe1),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(19),
                  bottomLeft: Radius.circular(19),
                  bottomRight: Radius.circular(19),
                ),
              ),
              child: DisplayMessageWithType(message: widget.message,)
            ),
          ),
        ],
      ),
    );
  }
}
