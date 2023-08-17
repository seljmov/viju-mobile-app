import 'package:flutter/material.dart';

import '../../theme/theme_extention.dart';
import 'thesis_bottom_sheep_selector.dart';

class ThesisDropDownButton<T extends Object> extends StatelessWidget {
  const ThesisDropDownButton({
    super.key,
    required this.controller,
    required this.bottomSheepTitle,
    required this.itemBuilder,
    required this.items,
    required this.onSelected,
    this.title,
    this.singleSelection = true,
    this.decoration = const InputDecoration(),
    this.initialItem,
  });

  final TextEditingController controller;
  final String bottomSheepTitle;
  final Widget Function(T item) itemBuilder;
  final List<T> items;
  final bool singleSelection;
  final T? initialItem;
  final String? title;
  final InputDecoration? decoration;
  final void Function(T item) onSelected;

  @override
  Widget build(BuildContext context) {
    final pickedNotifier = ValueNotifier<T?>(initialItem);
    return ValueListenableBuilder<T?>(
      valueListenable: pickedNotifier,
      builder: (context, picked, child) {
        return TextFormField(
          readOnly: true,
          controller: controller,
          style: context.textTheme.titleLarge,
          decoration: decoration,
          onTap: () async {
            if (singleSelection) {
              await ThesisBottomSheepSelector.showSingle<T>(
                context,
                title: bottomSheepTitle,
                items: items,
                itemBuilder: itemBuilder,
                picked: picked,
                onSelected: (item) {
                  pickedNotifier.value = item;
                  onSelected(item);
                },
              );
            }
          },
        );
      },
    );
  }
}
