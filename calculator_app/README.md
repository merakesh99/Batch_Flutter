# calculator_app

## Step 1: Setup Flutter Environment
Ensure you have Flutter installed and set up on your machine. Create a new Flutter project:

 
- flutter create basic_calculator
- cd basic_calculator


## Step 2: Define the UI
Open lib/main.dart and define the basic UI for your calculator:


  
import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basic Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = "0";
  String _input = "";
  double _num1 = 0.0;
  double _num2 = 0.0;
  String _operand = "";

  void _buttonPressed(String buttonText) {
    if (buttonText == "CLEAR") {
      _input = "";
      _output = "0";
      _num1 = 0.0;
      _num2 = 0.0;
      _operand = "";
    } else if (buttonText == "+" || buttonText == "-" || buttonText == "/" || buttonText == "*") {
      _num1 = double.parse(_input);
      _operand = buttonText;
      _input = "";
    } else if (buttonText == ".") {
      if (_input.contains(".")) {
        return;
      } else {
        _input += buttonText;
      }
    } else if (buttonText == "=") {
      _num2 = double.parse(_input);

      switch (_operand) {
        case "+":
          _output = (_num1 + _num2).toString();
          break;
        case "-":
          _output = (_num1 - _num2).toString();
          break;
        case "*":
          _output = (_num1 * _num2).toString();
          break;
        case "/":
          _output = (_num1 / _num2).toString();
          break;
      }

      _num1 = 0.0;
      _num2 = 0.0;
      _operand = "";
      _input = _output;
    } else {
      _input += buttonText;
    }

    setState(() {
      _output = double.parse(_input).toStringAsFixed(2);
    });
  }

  Widget _buildButton(String buttonText) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () => _buttonPressed(buttonText),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            buttonText,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Basic Calculator'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
            child: Text(
              _output,
              style: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Divider(),
          ),
          Column(
            children: [
              Row(
                children: [
                  _buildButton("7"),
                  _buildButton("8"),
                  _buildButton("9"),
                  _buildButton("/"),
                ],
              ),
              Row(
                children: [
                  _buildButton("4"),
                  _buildButton("5"),
                  _buildButton("6"),
                  _buildButton("*"),
                ],
              ),
              Row(
                children: [
                  _buildButton("1"),
                  _buildButton("2"),
                  _buildButton("3"),
                  _buildButton("-"),
                ],
              ),
              Row(
                children: [
                  _buildButton("."),
                  _buildButton("0"),
                  _buildButton("00"),
                  _buildButton("+"),
                ],
              ),
              Row(
                children: [
                  _buildButton("CLEAR"),
                  _buildButton("="),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}


## Explanation
Setup: The main function initializes the CalculatorApp, which sets up the MaterialApp and its theme.

- State Management: The CalculatorScreen is a StatefulWidget, handling the state changes of the calculator operations.

- UI Components:

The _buildButton method creates buttons for the calculator.
The Scaffold widget structures the app, with an AppBar and a body containing the display and buttons.
Logic:

_buttonPressed handles the logic for different button presses (numbers, operations, and special buttons like CLEAR and =).
The input and output are updated using setState.


## Step 3: Run the App
Run your Flutter app using:

 
flutter run
You should see a basic calculator app where you can perform basic arithmetic operations.

Self-Assessment Areas
Flutter Setup: Ensure that your Flutter environment is correctly set up and you can run the app without issues.
Widgets: Understand how to use basic Flutter widgets like MaterialApp, Scaffold, Column, Row, OutlinedButton, and Text.
Dart Basics: Practice Dart basics such as state management, functions, and updating the UI using setState.