import 'package:flutter/material.dart';

class BaDropdownButton extends StatefulWidget {
  const BaDropdownButton({super.key, required this.list});

  final List<String> list;

  @override
  State<BaDropdownButton> createState() => _BaDropdownButtonState();
}

class _BaDropdownButtonState extends State<BaDropdownButton> {
  String dropdownValue = '';

  @override
  Widget build(BuildContext context) {
    dropdownValue = widget.list.first;
    return DropdownMenu<String>(
      width: 340,
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
    );
  }
}
