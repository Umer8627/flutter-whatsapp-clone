// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whatsapp_clone/constants/theme_constant.dart';
import '../../constants/color_constant.dart';

class CustomTextfield extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final IconData? suffixIcon2;
  final double? iconSize;
  bool isVisible;
  bool isRead;
  final String? imagePath;

  final Colors? color;
  final TextInputType? inputType;

  final String? errorText;

  final Color? imageIconColor;

  CustomTextfield({
    Key? key,
    this.imagePath,
    this.isVisible = false,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.iconSize,
    this.color,
    this.isRead = true,
    required this.controller,
    this.inputType,
    this.suffixIcon2,
    this.errorText,
    this.imageIconColor,
  }) : super(key: key);

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  bool visibility = false;
  @override
  Widget build(BuildContext context) {
    return TextField(
      style: CustomFont.regularText.copyWith(fontWeight: FontWeight.w500),
      enabled: widget.isRead,
      controller: widget.controller,
      keyboardType: widget.inputType,
      obscureText: widget.isVisible,
      decoration: InputDecoration(
      hintStyle: CustomFont.regularText.copyWith(
                            fontWeight: FontWeight.w500, color: Colors.white),
        hintText: widget.hintText,
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: tabColor),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: tabColor),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: tabColor),
        ),
        prefixIcon: widget.prefixIcon != null
            ? Icon(
                widget.prefixIcon,
                color: widget.imageIconColor ?? tabColor,
                size: widget.iconSize ?? 20,
              )
            : widget.imagePath != null
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      "${widget.imagePath}",
                      color: widget.imageIconColor ?? tabColor,
                      height: 20,
                      fit: BoxFit.cover,
                    ),
                  )
                : null,
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              widget.isVisible = !widget.isVisible;
            });
          },
          child: Icon(
            widget.isVisible ? widget.suffixIcon2 : widget.suffixIcon,
            color: blackColor,
            size: 18,
          ),
        ),
        fillColor: backgroundColor,
        filled: true,
        errorText: widget.errorText,
      ),
      inputFormatters: widget.inputType == TextInputType.number
          ? <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
            ]
          : null,
    );
  }
}
