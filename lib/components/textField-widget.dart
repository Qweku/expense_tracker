// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText, label;
  final TextEditingController? controller;
  final TextInputType? keyboard;
  final int? maxLines;
  final Color borderColor;
  final Color color;
  final TextStyle? style;
  final double? width;
  final bool obscure;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextAlign textAlign;
  final Function(String)? onChanged;
  final Color hintColor;
  final bool readOnly;
  final bool autoFocus;
  const CustomTextField(
      {Key? key,
      this.hintText,
      this.controller,
      this.keyboard,
      this.maxLines,
      this.borderColor = Colors.transparent,
      this.color = Colors.transparent,
      this.style,
      this.readOnly = false,
      this.obscure = false,
      this.suffixIcon,
      this.textAlign = TextAlign.justify,
      this.hintColor = Colors.grey,
      this.prefixIcon,
      this.onChanged,
      this.autoFocus = false,
      this.label,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
          border: Border.all(
            color: borderColor,
          ),
          color: color,
          borderRadius: BorderRadius.circular(20)),
      child: TextFormField(
        autofocus: autoFocus,
        obscureText: obscure,
        readOnly: readOnly,
        maxLines: maxLines,
        onChanged: onChanged,
        keyboardType: keyboard,
        controller: controller,
        textAlign: textAlign,
        style: style,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: label,
          labelStyle: style,
          hintStyle: TextStyle(color: hintColor),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15.0),
        ),
      ),
    );
  }
}

class CustomDropDownList extends StatefulWidget {
  final String? hintText;
  final List<String>? listItems;
  final Color color;
  final Color borderColor;
  final TextStyle? style;
  final Function(String)? onSet;

  const CustomDropDownList({
    Key? key,
    this.hintText,
    this.listItems,
    this.color = Colors.transparent,
    this.borderColor = Colors.transparent,
    this.style,
    this.onSet,
  }) : super(key: key);

  @override
  State<CustomDropDownList> createState() => _CustomDropDownListState();
}

class _CustomDropDownListState extends State<CustomDropDownList> {
  String? itemValue;
  @override
  Widget build(BuildContext context) {
    
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      decoration: BoxDecoration(
          border: Border.all(color: widget.borderColor),
          color: widget.color,
          borderRadius: BorderRadius.circular(20)),
      child: DropdownButtonFormField(
        style: widget.style,
        decoration: InputDecoration(
            border: InputBorder.none,
            fillColor: Colors.transparent,
            filled: true),
        hint: Text(widget.hintText!),
        value: itemValue,
        onChanged: (dynamic newValue) {
          setState(() {
            itemValue = newValue;
            widget.onSet!(itemValue!);
          });
        },
        items: widget.listItems!.map((location) {
          return DropdownMenuItem(
            value: location,
            child: Text(location, maxLines: 2),
          );
        }).toList(),
      ),
    );
  }
}
