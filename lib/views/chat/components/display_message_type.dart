import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/constants/theme_constant.dart';
import 'package:whatsapp_clone/enums/message_enum.dart';
import 'package:whatsapp_clone/models/message_model.dart';

class DisplayMessageWithType extends StatelessWidget {
  final Message message;
  const DisplayMessageWithType({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return message.type == MessageEnum.text
        ? Text(
            message.text,
            style: CustomFont.regularText
                .copyWith(fontSize: 14, fontWeight: FontWeight.w500),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: 200,
                  width: 200,
                  child: FastCachedImage(
                    url: message.text,
                    fit: BoxFit.cover,
                  )),
              if (message.caption!.isNotEmpty) const SizedBox(height: 5),
              if (message.caption!.isNotEmpty)
                Text(
                  message.caption ?? '',
                  style: CustomFont.regularText
                      .copyWith(fontSize: 14, fontWeight: FontWeight.w500),
                ),
            ],
          );
  }
}
