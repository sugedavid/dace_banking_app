import 'package:flutter/material.dart';

class BaDropdownButton extends StatefulWidget {
  const BaDropdownButton(
      {super.key,
      required this.labelText,
      required this.list,
      required this.textEditingController});

  final String labelText;
  final List<String> list;
  final TextEditingController textEditingController;

  @override
  State<BaDropdownButton> createState() => _BaDropdownButtonState();
}

class _BaDropdownButtonState extends State<BaDropdownButton> {
  String dropdownValue = '';

  @override
  Widget build(BuildContext context) {
    dropdownValue = widget.list.first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(widget.labelText),
        const SizedBox(
          height: 5,
        ),
        DropdownMenu<String>(
          width: 395,
          controller: widget.textEditingController,
          initialSelection: widget.list.first,
          onSelected: (String? value) {
            // This is called when the user selects an item.
            setState(() {
              dropdownValue = value!;
            });
          },
          dropdownMenuEntries:
              widget.list.map<DropdownMenuEntry<String>>((String value) {
            return DropdownMenuEntry<String>(value: value, label: value);
          }).toList(),
        ),
      ],
    );
  }
}
