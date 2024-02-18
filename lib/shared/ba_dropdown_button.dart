import 'package:flutter/material.dart';

class BADropdownButton extends StatefulWidget {
  const BADropdownButton(
      {super.key,
      required this.labelText,
      required this.list,
      required this.controller});

  final String labelText;
  final List<String> list;
  final TextEditingController controller;

  @override
  State<BADropdownButton> createState() => _BADropdownButtonState();
}

class _BADropdownButtonState extends State<BADropdownButton> {
  String dropdownValue = '';

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.list.first;
    widget.controller.text = dropdownValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // label
        if (widget.labelText.isNotEmpty) ...{
          Text(
            widget.labelText,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.amber[800]!,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
        },

        // dropdown
        SizedBox(
          width: 395,
          child: DropdownButton<String>(
            isExpanded: true,
            value: dropdownValue,
            icon: const Icon(Icons.keyboard_arrow_down),
            elevation: 16,
            underline: Container(height: 1, color: Colors.black45),
            onChanged: (String? value) {
              setState(() {
                dropdownValue = value!;
                widget.controller.text = dropdownValue;
              });
            },
            items: widget.list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
