class CalendarData {
  final Set<int> selectedMonths;
  final Map<String, Set<int>> selectedDaysByMonthKey;
  final Map<String, Set<int>> selectedShiftsByDateKey;
  final int selectedYear;

  CalendarData({
    this.selectedMonths = const {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12},
    this.selectedDaysByMonthKey = const {},
    this.selectedShiftsByDateKey = const {},
    this.selectedYear = 2025,
  });

  CalendarData copyWith({
    Set<int>? selectedMonths,
    Map<String, Set<int>>? selectedDaysByMonthKey,
    Map<String, Set<int>>? selectedShiftsByDateKey,
    int? selectedYear,
  }) {
    return CalendarData(
      selectedMonths: selectedMonths ?? this.selectedMonths,
      selectedDaysByMonthKey: selectedDaysByMonthKey ?? this.selectedDaysByMonthKey,
      selectedShiftsByDateKey: selectedShiftsByDateKey ?? this.selectedShiftsByDateKey,
      selectedYear: selectedYear ?? this.selectedYear,
    );
  }
}

class CalendarConstants {
  static const List<String> months = [
    'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
    'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
  ];
  
  static const List<String> weekDays = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
  
  static const List<String> shiftLabels = [
    '00:00 - 08:00',
    '08:00 - 16:00',
    '16:00 - 00:00',
  ];
}

