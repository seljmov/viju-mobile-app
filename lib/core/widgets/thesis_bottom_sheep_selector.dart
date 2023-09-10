import 'package:flutter/material.dart';

import '../../theme/theme_colors.dart';
import '../../theme/theme_constants.dart';
import '../../theme/theme_extention.dart';
import '../constants/constants.dart';
import 'button/thesis_button.dart';
import 'button/thesis_outlined_button.dart';
import 'thesis_bottom_sheep.dart';

/// BottomSheep для выбора точки инцидента
class ThesisBottomSheepSelector {
  static Future<void> showSingle<T extends Object>(
    BuildContext context, {
    required String title,
    required List<T> items,
    required Widget Function(T item) itemBuilder,
    required void Function(T item) onSelected,
    T? picked,
  }) async {
    final checkedNotifier = ValueNotifier<T?>(picked);
    await ThesisBottomSheep.showBarModalAsync(
      context,
      expand: false,
      builder: (context) => SingleChildScrollView(
        physics: kDefaultPhysics,
        padding: kBottomSheepDefaultPaddingHorizontal,
        child: Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Text(
                title,
                style: context.textTheme.headlineSmall,
              ),
            ),
            ValueListenableBuilder<T?>(
              valueListenable: checkedNotifier,
              builder: (context, checked, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(items.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: GestureDetector(
                        onTap: () => checkedNotifier.value = items[index],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: itemBuilder(items[index]),
                            ),
                            Visibility(
                              visible: items[index] == checked,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: const BoxDecoration(
                                  border: Border.fromBorderSide(
                                    BorderSide(
                                      color: kPrimaryColor,
                                      width: 6,
                                    ),
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const SizedBox.shrink(),
                              ),
                              replacement: Container(
                                width: 20,
                                height: 20,
                                decoration: const BoxDecoration(
                                  border: Border.fromBorderSide(
                                    BorderSide(
                                      color: Colors.black,
                                      width: 1,
                                    ),
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const SizedBox.shrink(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
            const SizedBox(height: 48),
            Row(
              children: [
                Expanded(
                  child: ThesisOutlinedButton(
                    text: 'Отмена',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 16),
                ValueListenableBuilder(
                  valueListenable: checkedNotifier,
                  builder: (context, checked, child) {
                    return Expanded(
                      child: ThesisButton.fromText(
                        text: 'Готово',
                        isDisabled: checked == null,
                        onPressed: () {
                          onSelected(checked!);
                          Navigator.of(context).pop();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
