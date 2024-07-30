import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'timer_model.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late int _selectedFocusDuration;
  late int _selectedBreakDuration;

  final List<int> _durationOptions = [5, 10, 15, 20, 25, 30];

  @override
  void initState() {
    super.initState();
    final timerModel = Provider.of<TimerModel>(context, listen: false);
    _selectedFocusDuration = timerModel.focusDuration ~/ 60;
    _selectedBreakDuration = timerModel.breakDuration ~/ 60;
  }

  @override
  Widget build(BuildContext context) {
    final timerModel = Provider.of<TimerModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Focus Duration Dropdown
            DropdownButtonFormField<int>(
              value: _selectedFocusDuration,
              items: _durationOptions
                  .map((duration) => DropdownMenuItem(
                        value: duration,
                        child: Text('$duration minutes'),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedFocusDuration = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Focus Duration',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),

            // Break Duration Dropdown
            DropdownButtonFormField<int>(
              value: _selectedBreakDuration,
              items: _durationOptions
                  .map((duration) => DropdownMenuItem(
                        value: duration,
                        child: Text('$duration minutes'),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBreakDuration = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Break Duration',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),

            // Save Button
            ElevatedButton(
              onPressed: () {
                timerModel.setFocusDuration(_selectedFocusDuration);
                timerModel.setBreakDuration(_selectedBreakDuration);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Settings updated')),
                );

                Navigator.pop(context);
              },
              child: Text('Save Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
