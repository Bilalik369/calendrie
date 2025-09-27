import '../models/calendar_models.dart';

class CalendarService {
  static String monthKey(int year, int month) {
    return '$year-${month.toString().padLeft(2, '0')}';
  }

  static String dateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  static void ensureMonthDaysInitialized(
    int year, 
    int month, 
    Map<String, Set<int>> selectedDaysByMonthKey,
    Map<String, Set<int>> selectedShiftsByDateKey,
  ) {
    final String key = monthKey(year, month);
    if (!selectedDaysByMonthKey.containsKey(key)) {
      final int daysInMonth = DateTime(year, month + 1, 0).day;
     
      selectedDaysByMonthKey[key] = {
        for (int d = 1; d <= daysInMonth; d++) d
      };
      
   
      for (int d = 1; d <= daysInMonth; d++) {
        final String dKey = dateKey(DateTime(year, month, d));
        selectedShiftsByDateKey[dKey] = {0, 1, 2};
      }
    }
  }
}

