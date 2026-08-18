import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class ColorSwatchSelector extends StatelessWidget {
  final List<Color> colors;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const ColorSwatchSelector({
    super.key,
    required this.colors,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('CHOOSE FINISH', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.onSurface)),
        const SizedBox(height: 12),
        Row(
          children: List.generate(colors.length, (index) {
            final isSelected = index == selectedIndex;
            return Padding(
              padding: const EdgeInsets.only(right: 14),
              child: GestureDetector(
                onTap: () => onSelected(index),
                child: Container(
                  width: 40,
                  height: 40,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.outlineVariant,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(shape: BoxShape.circle, color: colors[index]),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}