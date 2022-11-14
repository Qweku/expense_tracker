// ignore_for_file: file_names, prefer_const_constructors
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:expense_tracker/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

class DateTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final Color borderColor;
  final Color color;
  final TextStyle? style;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color hintColor;
  final Function(DateTime?)? onChanged;
  const DateTextField(
      {Key? key,
      this.hintText,
      this.controller,
      this.borderColor = Colors.transparent,
      this.color = Colors.transparent,
      this.style,
      this.prefixIcon,
      this.suffixIcon,
      this.onChanged,
      this.hintColor = Colors.grey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final fromDate = TextEditingController();
     //final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 0,
      ),
      child: Container(
        //width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            border: Border.all(
              color: borderColor,
            ),
            color: color,
            borderRadius: BorderRadius.circular(20)),
        child: Theme(
          data: ThemeData.from(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.blue,
              accentColor: Colors.white,
            ),
          ),
          child: DateTimeField(
            style: style ?? bodyText1,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: hintColor),
              prefixIcon: prefixIcon,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 15.0),
            ),
            // validator: MultiValidator([
            //   RequiredValidator(
            //       errorText: "*field cannot be empty"),
            // ]),
            format: dateformat,
            controller: controller,
            onChanged: onChanged,
            onShowPicker: (context, currentValue) {
              return showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  initialDate: currentValue ?? DateTime.now(),
                  lastDate: DateTime(2100));
            },
          ),
        ),
      ),
    );
  }
}
