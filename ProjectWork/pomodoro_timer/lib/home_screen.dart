import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'timer_model.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final timerModel = Provider.of<TimerModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Pomodoro Timer'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Current Timer',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              timerModel.currentDurationFormatted,
              style: TextStyle(fontSize: 48.0),
            ),
            SizedBox(height: 20),
            timerModel.isRunning
                ? ElevatedButton(
                    onPressed: () {
                      timerModel.stopTimer();
                    },
                    child: Text('Stop'),
                  )
                : ElevatedButton(
                    onPressed: () {
                      timerModel.startTimer();
                    },
                    child: Text('Start'),
                  ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                timerModel.resetTimer();
              },
              child: Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
