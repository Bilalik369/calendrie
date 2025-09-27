import 'package:flutter/material.dart';
import '../models/calendar_models.dart';
import '../services/calendar_service.dart';

class CalendarWidget extends StatelessWidget {
  final DateTime currentMonth;
  final Set<int> selectedMonths;
  final Map<String, Set<int>> selectedDaysByMonthKey;
  final Map<String, Set<int>> selectedShiftsByDateKey;
  final Function(int) onDayToggle;
  final Function(int) onDayDoubleTap;
  final Function(int) onDayLongPress;

  const CalendarWidget({
    Key? key,
    required this.currentMonth,
    required this.selectedMonths,
    required this.selectedDaysByMonthKey,
    required this.selectedShiftsByDateKey,
    required this.onDayToggle,
    required this.onDayDoubleTap,
    required this.onDayLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int year = currentMonth.year;
    final int month = currentMonth.month;
    final String monthKey = CalendarService.monthKey(year, month);
    final Set<int> selectedDays = selectedDaysByMonthKey[monthKey] ?? <int>{};
    
    
    final DateTime firstDayOfMonth = DateTime(year, month, 1);
    final int firstWeekday = firstDayOfMonth.weekday; 
    final int daysInMonth = DateTime(year, month + 1, 0).day;
 
    final int totalCells = ((firstWeekday - 1) + daysInMonth);
    final int weeks = (totalCells / 7).ceil();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
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
        children: [
         
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${CalendarConstants.months[month - 1]} $year',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              if (!selectedMonths.contains(month))
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Mois non sélectionné',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          
          Row(
            children: CalendarConstants.weekDays.map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
    
          ...List.generate(weeks, (weekIndex) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: List.generate(7, (dayIndex) {
                  final int cellIndex = weekIndex * 7 + dayIndex;
                  final int dayNumber = cellIndex - (firstWeekday - 1) + 1;
                  
                
                  if (cellIndex < firstWeekday - 1) {
                    return const Expanded(child: SizedBox(height: 40));
                  }
                  
                  
                  if (dayNumber > daysInMonth) {
                    return const Expanded(child: SizedBox(height: 40));
                  }
                  
                  final bool isSelected = selectedDays.contains(dayNumber);
                  final String dateKey = CalendarService.dateKey(DateTime(year, month, dayNumber));
                  final Set<int> shifts = selectedShiftsByDateKey[dateKey] ?? <int>{};
                  final bool hasShifts = shifts.isNotEmpty;
                  
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onDayToggle(dayNumber),
                      onDoubleTap: () => onDayDoubleTap(dayNumber),
                      onLongPress: () => onDayLongPress(dayNumber),
                      child: Container(
                        height: 40,
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: isSelected 
                            ? (hasShifts ? Colors.blue.withOpacity(0.8) : Colors.blue.withOpacity(0.3))
                            : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? Colors.blue : Colors.grey.withOpacity(0.3),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Text(
                                dayNumber.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                            if (hasShifts)
                              Positioned(
                                top: 2,
                                right: 2,
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          }),
        ],
      ),
    );
  }
}
