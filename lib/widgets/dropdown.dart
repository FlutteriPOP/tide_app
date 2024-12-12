import 'package:flutter/material.dart';
import 'package:ipop_tracker/config/colors.dart';

class CustomDropdown<T> extends StatefulWidget {
  final List<T> items;
  final T selectedItem;
  final ValueChanged<T> onChanged;
  final TextStyle itemTextStyle;
  final IconData dropdownIcon;
  final BoxDecoration? dropdownContainerDecoration;

  const CustomDropdown(
      {super.key,
      required this.items,
      required this.selectedItem,
      required this.onChanged,
      this.itemTextStyle = const TextStyle(color: tTextblackColor),
      this.dropdownIcon = Icons.arrow_drop_down,
      this.dropdownContainerDecoration});

  @override
  CustomDropdownState<T> createState() => CustomDropdownState<T>();
}

class CustomDropdownState<T> extends State<CustomDropdown<T>> {
  bool _isDropdownOpen = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isDropdownOpen = !_isDropdownOpen;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: widget.dropdownContainerDecoration,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.selectedItem.toString(),
                  style: widget.itemTextStyle,
                ),
                Icon(_isDropdownOpen
                    ? Icons.arrow_drop_up
                    : widget.dropdownIcon),
              ],
            ),
          ),
        ),
        if (_isDropdownOpen)
          Container(
            decoration: widget.dropdownContainerDecoration,
            margin: const EdgeInsets.only(top: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: widget.items.map((item) {
                return GestureDetector(
                  onTap: () {
                    widget.onChanged(item);
                    setState(() {
                      _isDropdownOpen = false;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: item == widget.selectedItem
                          ? tContainerColor
                          : tTextwhiteColor,
                    ),
                    child: Text(
                      item.toString(),
                      style: widget.itemTextStyle,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}