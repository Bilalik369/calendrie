import 'package:flutter/material.dart';
import '../models/calendar_models.dart';

class MonthSelectorWidget extends StatelessWidget {
  final int selectedYear;
  final Set<int> selectedMonths;
  final Function(int) onMonthToggle;
  final VoidCallback onSelectAll;

  const MonthSelectorWidget({
    Key? key,
    required this.selectedYear,
    required this.selectedMonths,
    required this.onMonthToggle,
    required this.onSelectAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mois $selectedYear',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextButton(
                onPressed: onSelectAll,
                child: Text(
                  selectedMonths.length == 12 ? 'Tout désélectionner' : 'Tout sélectionner',
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(12, (index) {
              final int month = index + 1;
              final bool isSelected = selectedMonths.contains(month);
              return ChoiceChip(
                label: Text(CalendarConstants.months[index]),
                selected: isSelected,
                onSelected: (_) => onMonthToggle(month),
              );
            }),
          ),
        ],
      ),
    );
  }
}

