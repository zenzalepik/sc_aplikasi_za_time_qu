import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  List<String> alarms = [];

  @override
  void initState() {
    super.initState();
    loadAlarms();
  }

  Future<void> loadAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    alarms = prefs.getStringList("alarms") ?? [];
    setState(() {});
  }

  Future<void> saveAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("alarms", alarms);
  }

  Future<void> addAlarm() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      alarms.add("${picked.hour}:${picked.minute.toString().padLeft(2, '0')}");
      saveAlarms();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        onPressed: addAlarm,
        child: const Icon(Icons.add, color: Colors.black),
      ),
      body: ListView.builder(
        itemCount: alarms.length,
        itemBuilder: (_, i) {
          return ListTile(
            title: Text(
              alarms[i],
              style: const TextStyle(color: Colors.greenAccent, fontSize: 26),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.greenAccent),
              onPressed: () {
                alarms.removeAt(i);
                saveAlarms();
                setState(() {});
              },
            ),
          );
        },
      ),
    );
  }
}
