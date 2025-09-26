import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendrier',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: CalendarScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
  int selectedYear = DateTime.now().year;
  

  final Set<int> selectedMonths = {
    1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
  };
  
   final Map<String, Set<int>> selectedDaysByMonthKey = {};
  
   final Map<String, Set<int>> selectedShiftsByDateKey = {};
  
  final List<String> weekDays = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
  final List<String> months = [
    'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
    'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
  ];
  
  final List<String> shiftLabels = [
    '00:00 - 08:00',
    '08:00 - 16:00',
    '16:00 - 00:00',
  ];

  String _monthKey(int year, int month) {
    return '$year-${month.toString().padLeft(2, '0')}';
  }

  String _dateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _ensureMonthDaysInitialized(int year, int month) {
    final String key = _monthKey(year, month);
    if (!selectedDaysByMonthKey.containsKey(key)) {
      final int daysInMonth = DateTime(year, month + 1, 0).day;
      selectedDaysByMonthKey[key] = {
        for (int d = 1; d <= daysInMonth; d++) d
      };
      
      for (int d = 1; d <= daysInMonth; d++) {
        final String dKey = _dateKey(DateTime(year, month, d));
        selectedShiftsByDateKey[dKey] = {0, 1, 2};
      }
    }
  }

  void _toggleMonth(int month) {
    setState(() {
      if (selectedMonths.contains(month)) {
        
        selectedMonths.remove(month);
        final String mKey = _monthKey(selectedYear, month);
        final Set<int>? days = selectedDaysByMonthKey[mKey];
        if (days != null) {
          for (final int d in days) {
            selectedShiftsByDateKey.remove(_dateKey(DateTime(selectedYear, month, d)));
          }
        }
        selectedDaysByMonthKey.remove(mKey);
      } else {
        
        selectedMonths.add(month);
        _ensureMonthDaysInitialized(selectedYear, month);
      }
    });
  }

  void _toggleDay(int day) {
    final int year = currentMonth.year;
    final int month = currentMonth.month;
    final String mKey = _monthKey(year, month);
    setState(() {
      if (!selectedMonths.contains(month)) {
        
        _toggleMonth(month);
      }
      _ensureMonthDaysInitialized(year, month);
      final Set<int> selectedDays = selectedDaysByMonthKey[mKey]!;
      final String dKey = _dateKey(DateTime(year, month, day));
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
    final String dKey = _dateKey(DateTime(year, month, day));
    _ensureMonthDaysInitialized(year, month);
    if (!selectedShiftsByDateKey.containsKey(dKey)) {
      selectedShiftsByDateKey[dKey] = {0, 1, 2};
    }
    final Set<int> tempShifts = {...(selectedShiftsByDateKey[dKey] ?? {0, 1, 2})};
    final Set<int>? result = await showModalBottomSheet<Set<int>>(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sélectionner les shifts', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(3, (index) {
                      final bool selected = tempShifts.contains(index);
                      return ChoiceChip(
                        label: Text(shiftLabels[index]),
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
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(null),
                        child: Text('Annuler'),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => Navigator.of(ctx).pop(tempShifts),
                        child: Text('Enregistrer'),
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
    final String mKey = _monthKey(year, month);
    
    setState(() {
      if (!selectedMonths.contains(month)) {
        _toggleMonth(month);
      }
      _ensureMonthDaysInitialized(year, month);
      final Set<int> monthDays = selectedDaysByMonthKey[mKey] ?? <int>{};
      if (!monthDays.contains(day)) {
        monthDays.add(day);
        selectedDaysByMonthKey[mKey] = monthDays;
      }
      final String dKey = _dateKey(DateTime(year, month, day));
      selectedShiftsByDateKey[dKey] = {0, 1, 2};
    });
    _editShiftsForDay(day);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () {},
        ),
        title: Text(
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
            SizedBox(height: 20),
         
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
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
                        'Mois ${selectedYear}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
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
                        },
                        child: Text(selectedMonths.length == 12 ? 'Tout désélectionner' : 'Tout sélectionner'),
                      )
                    ],
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(12, (index) {
                      final int month = index + 1;
                      final bool isSelected = selectedMonths.contains(month);
                      return ChoiceChip(
                        label: Text(months[index]),
                        selected: isSelected,
                        onSelected: (_) => _toggleMonth(month),
                      );
                    }),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 20),
            
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
               
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.chevron_left, color: Colors.grey[600], size: 24),
                          onPressed: () {
                            setState(() {
                              currentMonth = DateTime(currentMonth.year, currentMonth.month - 1);
                            });
                          },
                        ),
                        Text(
                          '${months[currentMonth.month - 1]} ${currentMonth.year}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.chevron_right, color: Colors.grey[600], size: 24),
                          onPressed: () {
                            setState(() {
                              currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  
                
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                       
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: weekDays.map((day) => 
                            Container(
                              width: 40,
                              height: 30,
                              alignment: Alignment.center,
                              child: Text(
                                day,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ).toList(),
                        ),
                        
                        SizedBox(height: 10),
                 
                        ...buildCalendarGrid(),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 20),
                ],
              ),
            ),
            
            SizedBox(height: 30),
            
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
  
  List<Widget> buildCalendarGrid() {
    List<Widget> rows = [];
    DateTime firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    int daysInMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
    int startWeekday = firstDayOfMonth.weekday - 1; 
    
    List<Widget> days = [];
   
    if (selectedMonths.contains(currentMonth.month)) {
      _ensureMonthDaysInitialized(currentMonth.year, currentMonth.month);
    }
    final String mKey = _monthKey(currentMonth.year, currentMonth.month);
    final Set<int> selectedDays = selectedDaysByMonthKey[mKey] ?? <int>{};
    final bool isMonthSelected = selectedMonths.contains(currentMonth.month);

    for (int i = 0; i < startWeekday; i++) {
      days.add(Container(width: 40, height: 40));
    }
    
    Color daySelectedColor = Color(0xFF2196F3);
    Color dayDisabledText = Colors.grey[400]!;
    for (int day = 1; day <= daysInMonth; day++) {
      bool isSelected = isMonthSelected && selectedDays.contains(day);
      
      days.add(
        GestureDetector(
          onTap: () => _toggleDay(day),
          onDoubleTap: () => _openShiftsPickerDoubleTap(day),
          onLongPress: () => _editShiftsForDay(day),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isSelected ? daySelectedColor : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isMonthSelected ? Colors.transparent : Colors.grey[300]!,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              '$day',
              style: TextStyle(
                color: isMonthSelected
                    ? (isSelected ? Colors.white : Colors.black)
                    : dayDisabledText,
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ),
      );
    }
    
 
    for (int i = 0; i < days.length; i += 7) {
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: days.skip(i).take(7).toList(),
        ),
      );
      if (i + 7 < days.length) {
        rows.add(SizedBox(height: 8));
      }
    }
    
    return rows;
  }
  
  Widget buildAvailabilityItem(String day, String time) {
    bool isUnavailable = time == 'Indisponible';
    
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                day,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4),
              Text(
                time,
                style: TextStyle(
                  fontSize: 14,
                  color: isUnavailable ? Color(0xFFE57373) : Colors.grey[600],
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          Icon(
            Icons.edit_outlined,
            color: Colors.grey[400],
            size: 20,
          ),
        ],
      ),
    );
  }
}