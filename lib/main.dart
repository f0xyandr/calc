// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WindowOptions windowOptions = WindowOptions(
    minimumSize: Size(500, 750),
    maximumSize: Size(500, 750),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
    await windowManager.getOpacity();
  });

  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _inputValue = "0";
  num _previousNumber = 0;
  String _operation = "";

  void _onNumberPressed(String value) {
    setState(() {
      if (_inputValue == "0" && value != "." || value == "0.0") {
        _inputValue = value;
      } else {
        _inputValue += value;
      }
    });
  }

  void _onOperationPressed(String operation) {
    setState(() {
      debugPrint("OnOperationPressed: $operation");
      if (_inputValue != "0" && _inputValue != "0.0" && operation.isNotEmpty) {
        switch (operation) {
          case "cos":
            _inputValue = math.cos(num.parse(_inputValue)).toString();
            break;
          case "sin":
            _inputValue = math.sin(num.parse(_inputValue)).toString();
            break;
          case "C":
            _clearAll();
          case "=":
            _calculateResult();
            break;
          case "+/-":
            _inputValue = (num.parse(_inputValue) * -1).toString();
            break;
          default:
            debugPrint("TRUE OR FALSE ${_operation == "cos"}");
            _previousNumber = num.parse(_inputValue);
            _operation = operation;
            _inputValue = "0";
        }
        //_clearAll();
      }
      // else if (operation == "+/-") {
      //   _inputValue = (num.parse(_inputValue) * -1).toString();
      // } else if (operation == "=") {
      //   _calculateResult();
      // } else {
      //   debugPrint("ELSEEEE");
      //   _previousNumber = num.parse(_inputValue);
      //   _operation = operation;
      //   _inputValue = "0";
      // }
    });
  }

  void _clearAll() {
    _inputValue = "0";
    _previousNumber = 0.0;
    _operation = "";
  }

  void _calculateResult() {
    try {
      num currentNumber = num.parse(_inputValue);
      late num result;

      // debugPrint("Operation is  $_operation");

      switch (_operation) {
        case "cos":
          debugPrint("cos!!!");
          result = math.cos(currentNumber);
          setState(() {
            _inputValue = result.toString();
            _operation = "";
          });
          break;
        case "＋":
          result = _previousNumber + currentNumber;
          break;
        case "－":
          result = _previousNumber - currentNumber;
          break;
        case "*":
          result = _previousNumber * currentNumber;
          break;
        case "/":
          result = currentNumber != 0 ? _previousNumber / currentNumber : 0;
          break;
      }

      setState(() {
        _inputValue = result.toString();
        _operation = "";
      });
    } catch (e) {
      debugPrint("🐈");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.all(24),
              child: FittedBox(
                child: Text(
                  _inputValue,
                  style: TextStyle(
                    fontSize: 60,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          _buildButtonWrap([
            "C",
            "sin",
            "cos",
            "/",
            "7",
            "8",
            "9",
            "*",
            "4",
            "5",
            "6",
            "－",
            "1",
            "2",
            "3",
            "＋",
            ".",
            "0",
            "+/-",
            "=",
          ]),
        ],
      ),
    );
  }

  Widget _buildButtonWrap(List<String> values) {
    return Wrap(
      spacing: 4,
      runSpacing: 1,
      alignment: WrapAlignment.start,
      children: values.map((value) {
        return _buildButton(value);
      }).toList(),
    );
  }

  Widget _buildButton(String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: Size(105, 90),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          padding: EdgeInsets.all(24),
          backgroundColor: Colors.grey[850],
        ),
        onPressed: () {
          if (value == "＋" ||
              value == "－" ||
              value == "*" ||
              value == "/" ||
              value == "=" ||
              value == "C" ||
              value == "sin" ||
              value == "cos" ||
              value == "+/-") {
            _onOperationPressed(value);
          } else {
            _onNumberPressed(value);
          }
        },
        child: Text(
          value,
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}
