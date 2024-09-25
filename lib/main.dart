import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora Avanzada',
      theme: ThemeData.light(),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String display = "0";
  String previousInput = "";
  bool isCalculated = false;

  // Método para evaluar la expresión matemática
  double? evaluateExpression(String input) {
    try {
      // Parsear y evaluar la expresión
      final expression = Expression.parse(input);
      final evaluator = const ExpressionEvaluator();
      return evaluator.eval(expression, null) as double?;
    } catch (e) {
      return null;
    }
  }

  // Formatear el resultado para mostrarlo adecuadamente
  String formatDisplay(double value) {
    return value.toStringAsFixed(value == value.toInt() ? 0 : 3);
  }

  // Manejo de los botones presionados
  void onButtonTap(String buttonValue) {
    setState(() {
      if (buttonValue == "C") {
        display = "0";
        previousInput = "";
        isCalculated = false;
      } else if (buttonValue == "←") {
        if (display.length > 1) {
          display = display.substring(0, display.length - 1);
        } else {
          display = "0";
        }
      } else if (buttonValue == "=") {
        if (!isCalculated) {
          previousInput = display;
          double? result = evaluateExpression(display);
          display = result != null ? formatDisplay(result) : "Error";
          isCalculated = true;
        }
      } else if (buttonValue == ".") {
        if (!isCalculated && !display.endsWith(".")) {
          display += buttonValue;
        }
      } else {
        if (isCalculated) {
          display = buttonValue;
          isCalculated = false;
        } else if (display == "0" && buttonValue != ".") {
          display = buttonValue;
        } else {
          display += buttonValue;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora Avanzada'),
        backgroundColor: const Color.fromARGB(255, 9, 57, 141),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.centerRight,
            child: Text(
              previousInput,
              style: const TextStyle(fontSize: 18, color: Colors.black54),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.centerRight,
            child: Text(
              display,
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildButtonRow(["C", "←", "/", "*"]),
                buildButtonRow(["7", "8", "9", "-"]),
                buildButtonRow(["4", "5", "6", "+"]),
                buildButtonRow(["1", "2", "3", "="]),
                buildButtonRow(["0", "."]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Método para construir filas de botones
  Row buildButtonRow(List<String> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((buttonText) => createButton(buttonText)).toList(),
    );
  }

  // Método para crear un botón
  Widget createButton(String buttonText) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => onButtonTap(buttonText),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(70, 70),
            backgroundColor: Colors.blueGrey[800],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Text(
            buttonText,
            style: const TextStyle(fontSize: 30, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
