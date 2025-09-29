import 'package:flutter/material.dart';
import '../models/calendar_models.dart';
import '../services/calendar_service.dart';
import '../widgets/month_selector_widget.dart';
import '../widgets/calendar_widget.dart';
import 'notifications_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
  int selectedYear = DateTime.now().year;
  
  final Set<int> selectedMonths = {
    1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
  };
  
  final Map<String, Set<int>> selectedDaysByMonthKey = {};
  final Map<String, Set<int>> selectedShiftsByDateKey = {};

  @override
  void initState() {
    super.initState();

    CalendarService.ensureMonthDaysInitialized(
      currentMonth.year, 
      currentMonth.month, 
      selectedDaysByMonthKey, 
      selectedShiftsByDateKey
    );
  }
  void _toggleMonth(int month) {
    setState(() {
      if (selectedMonths.contains(month)) {
        selectedMonths.remove(month);
        final String mKey = CalendarService.monthKey(selectedYear, month);
        final Set<int>? days = selectedDaysByMonthKey[mKey];
        if (days != null) {
          for (final int d in days) {
            selectedShiftsByDateKey.remove(CalendarService.dateKey(DateTime(selectedYear, month, d)));
          }
        }
        selectedDaysByMonthKey.remove(mKey);
      } else {
        selectedMonths.add(month);
        CalendarService.ensureMonthDaysInitialized(
          selectedYear, 
          month, 
          selectedDaysByMonthKey, 
          selectedShiftsByDateKey
        );
      }
    });
  }

  void _toggleDay(int day) {
    final int year = currentMonth.year;
    final int month = currentMonth.month;
    final String mKey = CalendarService.monthKey(year, month);
    setState(() {
      if (!selectedMonths.contains(month)) {
        _toggleMonth(month);
      }
      CalendarService.ensureMonthDaysInitialized(year, month, selectedDaysByMonthKey, selectedShiftsByDateKey);
      final Set<int> selectedDays = selectedDaysByMonthKey[mKey]!;
      final String dKey = CalendarService.dateKey(DateTime(year, month, day));
      if (selectedDays.contains(day)) {
        selectedDays.remove(day);
        selectedShiftsByDateKey.remove(dKey);
      } else {
        selectedDays.add(day);
        selectedShiftsByDateKey[dKey] = {0, 1, 2};
      }
    });
  }

  void _editShiftsForDay(int day) async {
    final int year = currentMonth.year;
    final int month = currentMonth.month;
    final String dKey = CalendarService.dateKey(DateTime(year, month, day));
    CalendarService.ensureMonthDaysInitialized(year, month, selectedDaysByMonthKey, selectedShiftsByDateKey);
    if (!selectedShiftsByDateKey.containsKey(dKey)) {
      selectedShiftsByDateKey[dKey] = {0, 1, 2};
    }
    final Set<int> tempShifts = {...(selectedShiftsByDateKey[dKey] ?? {0, 1, 2})};
    final Set<int>? result = await showModalBottomSheet<Set<int>>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Sélectionner les shifts', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(3, (index) {
                      final bool selected = tempShifts.contains(index);
                      return ChoiceChip(
                        label: Text(CalendarConstants.shiftLabels[index]),
                        selected: selected,
                        onSelected: (_) {
                          setModalState(() {
                            if (selected) {
                              tempShifts.remove(index);
                            } else {
                              tempShifts.add(index);
                            }
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(null),
                        child: const Text('Annuler'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => Navigator.of(ctx).pop(tempShifts),
                        child: const Text('Enregistrer'),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
    );
    if (result != null) {
      setState(() {
        if (result.isEmpty) {
          _toggleDay(day);
        } else {
          selectedShiftsByDateKey[dKey] = result;
        }
      });
    }
  }

  void _openShiftsPickerDoubleTap(int day) {
    final int year = currentMonth.year;
    final int month = currentMonth.month;
    final String mKey = CalendarService.monthKey(year, month);
    
    setState(() {
      if (!selectedMonths.contains(month)) {
        _toggleMonth(month);
      }
      CalendarService.ensureMonthDaysInitialized(year, month, selectedDaysByMonthKey, selectedShiftsByDateKey);
      final Set<int> monthDays = selectedDaysByMonthKey[mKey] ?? <int>{};
      if (!monthDays.contains(day)) {
        monthDays.add(day);
        selectedDaysByMonthKey[mKey] = monthDays;
      }
      final String dKey = CalendarService.dateKey(DateTime(year, month, day));
    
      if (!selectedShiftsByDateKey.containsKey(dKey)) {
      selectedShiftsByDateKey[dKey] = {0, 1, 2};
      }
    });
    _editShiftsForDay(day);
  }

  void _selectAllMonths() {
    setState(() {
      if (selectedMonths.length == 12) {
        selectedMonths.clear();
        selectedDaysByMonthKey.clear();
        selectedShiftsByDateKey.clear();
      } else {
        selectedMonths
          ..clear()
          ..addAll({1,2,3,4,5,6,7,8,9,10,11,12});
      }
    });
  }

  void _navigateMonth(int direction) {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month + direction);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () {},
        ),
      

      
        title: const Text(
          'Calendrier',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            MonthSelectorWidget(
              selectedYear: selectedYear,
              selectedMonths: selectedMonths,
              onMonthToggle: _toggleMonth,
              onSelectAll: _selectAllMonths,
            ),
            const SizedBox(height: 20),
            CalendarWidget(
              currentMonth: currentMonth,
              selectedMonths: selectedMonths,
              selectedDaysByMonthKey: selectedDaysByMonthKey,
              selectedShiftsByDateKey: selectedShiftsByDateKey,
              onDayToggle: _toggleDay,
              onDayDoubleTap: _openShiftsPickerDoubleTap,
              onDayLongPress: _editShiftsForDay,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

