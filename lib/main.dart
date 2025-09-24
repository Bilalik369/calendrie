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
  DateTime selectedDate = DateTime(2024, 10, 5);
  DateTime currentMonth = DateTime(2024, 10);
  
  final List<String> weekDays = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
  final List<String> months = [
    'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
    'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
  ];
  
  final Map<String, String> availability = {
    'Lundi': '10h00 - 18h00',
    'Mardi': '10h00 - 18h00',
    'Mercredi': '10h00 - 18h00',
    'Jeudi': 'Indisponible',
    'Vendredi': '10h00 - 18h00',
  };

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
                  // Month Header
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
                        
                        // Calendar days
                        ...buildCalendarGrid(),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 20),
                ],
              ),
            ),
            
            SizedBox(height: 30),
            
          
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Disponibilité',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  
                  ...availability.entries.map((entry) => 
                    buildAvailabilityItem(entry.key, entry.value)
                  ).toList(),
                ],
              ),
            ),
            
            SizedBox(height: 30),
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
    
  
    for (int i = 0; i < startWeekday; i++) {
      days.add(Container(width: 40, height: 40));
    }
    
  
    for (int day = 1; day <= daysInMonth; day++) {
      bool isSelected = day == selectedDate.day && 
                       currentMonth.month == selectedDate.month &&
                       currentMonth.year == selectedDate.year;
      
      days.add(
        GestureDetector(
          onTap: () {
            setState(() {
              selectedDate = DateTime(currentMonth.year, currentMonth.month, day);
            });
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isSelected ? Color(0xFF2196F3) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            child: Text(
              '$day',
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
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
            color: Colors.black.withOpacity(0.05),
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