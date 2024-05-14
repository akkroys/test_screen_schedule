import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:test_screen_schedule/create_task_screen.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  final Map<DateTime, List<Map<String, String>>> _events = {
    DateTime(2024, 5, 7): [
      {'time': '12 PM', 'task': 'Prepare for presentation about new project'},
      {'time': '13 PM', 'task': 'Meeting with colleagues'},
      {'time': '15 PM', 'task': 'Meeting with colleagues again'}
    ]
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  List<Map<String, String>> _getEventsForDay(DateTime day) {
    final date = DateTime(day.year, day.month, day.day);
    return _events[date] ?? [];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onLeftArrowTapped() {
    setState(() {
      _focusedDay =
          DateTime(_focusedDay.year, _focusedDay.month - 1, _focusedDay.day);
    });
  }

  void _onRightArrowTapped() {
    setState(() {
      _focusedDay =
          DateTime(_focusedDay.year, _focusedDay.month + 1, _focusedDay.day);
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MMMM yyyy').format(now);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 143, 115, 94),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(''),
            Text(formattedDate, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
      drawer: Drawer(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.75,
          child: ListView(
            padding: EdgeInsets.zero,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: const Color.fromARGB(255, 143, 115, 94),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFFCBB495)),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white,
                indicator: BoxDecoration(
                  color: const Color.fromARGB(255, 143, 115, 94),
                  borderRadius: BorderRadius.circular(10),
                ),
                dividerColor: Colors.transparent,
                indicatorPadding: const EdgeInsets.symmetric(vertical: 8.0),
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: const [
                  Tab(text: 'Day'),
                  Tab(text: 'Week'),
                  Tab(text: 'Month'),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDayView(),
                _buildWeekView(),
                _buildMonthView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayView() {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 8),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Search ',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              suffixIcon: const Icon(Icons.search),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            ),
            onChanged: (value) {},
          ),
        ),
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TableCalendar(
                focusedDay: _focusedDay,
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: const Color.fromARGB(171, 141, 110, 99),
                    shape: BoxShape.rectangle,
                  ),
                  todayDecoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xFF8D6E63), width: 2.0),
                    shape: BoxShape.rectangle,
                  ),
                  todayTextStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  cellMargin:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  outsideDaysVisible: false,
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  leftChevronVisible: false,
                  rightChevronVisible: false,
                ),
                startingDayOfWeek: StartingDayOfWeek.monday,
              ),
            ),
            Positioned(
              left: 0,
              top: 50,
              bottom: 0,
              child: IconButton(
                icon: const Icon(Icons.arrow_left),
                onPressed: _onLeftArrowTapped,
              ),
            ),
            Positioned(
              right: 0,
              top: 50,
              bottom: 0,
              child: IconButton(
                icon: const Icon(Icons.arrow_right),
                onPressed: _onRightArrowTapped,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 143, 115, 94)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMMM d').format(_selectedDay),
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Row(
                  children: [
                    Text(
                      '0 / ${_getEventsForDay(_selectedDay).length}',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.arrow_right,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Scrollbar(
              thickness: 6.0,
              radius: const Radius.circular(10),
              thumbVisibility: true,
              child: ListView.builder(
                itemCount: _getEventsForDay(_selectedDay).length,
                itemBuilder: (context, index) {
                  final event = _getEventsForDay(_selectedDay)[index];
                  return ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event['time']!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          event['task']!,
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    leading: Checkbox(
                      value: false,
                      onChanged: (value) {},
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateTask()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF553327),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Create new task',
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: const Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeekView() {
    return const Center(
      child: Text('Week View'),
    );
  }

  Widget _buildMonthView() {
    return const Center(
      child: Text('Month View'),
    );
  }
}
