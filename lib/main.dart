import 'package:flutter/material.dart';

void main() {
  runApp(CalculadoraApp());
}

class CalculadoraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora Personalizable',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculadoraPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculadoraPage extends StatefulWidget {
  @override
  _CalculadoraPageState createState() => _CalculadoraPageState();
}

class _CalculadoraPageState extends State<CalculadoraPage> {
  String _output = "0";
  String _currentInput = "";
  double _num1 = 0;
  double _num2 = 0;
  String _operation = "";
  bool _waitingForSecondNumber = false;

  // Colores personalizables
  Color _backgroundColor = Colors.grey[900]!;
  Color _buttonColor = Colors.grey[800]!;
  Color _operationButtonColor = Colors.orange;
  Color _specialButtonColor = Colors.grey;
  Color _textColor = Colors.white;

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _output = "0";
        _currentInput = "";
        _num1 = 0;
        _num2 = 0;
        _operation = "";
        _waitingForSecondNumber = false;
      } else if (buttonText == "⌫") {
        if (_currentInput.isNotEmpty) {
          _currentInput = _currentInput.substring(0, _currentInput.length - 1);
          if (_currentInput.isEmpty) {
            _output = "0";
          } else {
            _output = _currentInput;
          }
        }
      } else if (buttonText == ".") {
        if (!_currentInput.contains(".")) {
          _currentInput += ".";
          _output = _currentInput;
        }
      } else if (buttonText == "+/-") {
        if (_currentInput.isNotEmpty) {
          if (_currentInput.startsWith("-")) {
            _currentInput = _currentInput.substring(1);
          } else {
            _currentInput = "-" + _currentInput;
          }
          _output = _currentInput;
        }
      } else if (["+", "-", "×", "÷"].contains(buttonText)) {
        if (_currentInput.isNotEmpty) {
          _num1 = double.parse(_currentInput);
          _operation = buttonText;
          _currentInput = "";
          _waitingForSecondNumber = true;
          _output = _num1.toString() + " " + _operation;
        }
      } else if (buttonText == "=") {
        if (_operation.isNotEmpty && _currentInput.isNotEmpty) {
          _num2 = double.parse(_currentInput);
          double result = 0;
          switch (_operation) {
            case "+":
              result = _num1 + _num2;
              break;
            case "-":
              result = _num1 - _num2;
              break;
            case "×":
              result = _num1 * _num2;
              break;
            case "÷":
              result = _num1 / _num2;
              break;
          }
          _output = result.toString();
          _currentInput = result.toString();
          _operation = "";
          _waitingForSecondNumber = false;
        }
      } else {
        if (_waitingForSecondNumber) {
          _currentInput = buttonText;
          _waitingForSecondNumber = false;
        } else {
          if (_currentInput == "0" || _currentInput == "-0") {
            _currentInput = _currentInput.replaceAll("0", buttonText);
          } else {
            _currentInput += buttonText;
          }
        }
        _output = _currentInput;
      }
    });
  }

  void _showColorPickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Personalizar colores"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildColorPickerOption(
                  "Fondo",
                  _backgroundColor,
                  (color) => _backgroundColor = color,
                ),
                _buildColorPickerOption(
                  "Botones",
                  _buttonColor,
                  (color) => _buttonColor = color,
                ),
                _buildColorPickerOption(
                  "Operaciones",
                  _operationButtonColor,
                  (color) => _operationButtonColor = color,
                ),
                _buildColorPickerOption(
                  "Especiales",
                  _specialButtonColor,
                  (color) => _specialButtonColor = color,
                ),
                _buildColorPickerOption(
                  "Texto",
                  _textColor,
                  (color) => _textColor = color,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text("Cancelar"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Aplicar"),
              onPressed: () {
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildColorPickerOption(
      String label, Color currentColor, Function(Color) onColorChanged) {
    return ListTile(
      title: Text(label),
      trailing: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: currentColor,
          border: Border.all(),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onTap: () async {
        final Color? pickedColor = await showDialog<Color>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Selecciona color para $label"),
              content: SingleChildScrollView(
                child: ColorPicker(
                  pickerColor: currentColor,
                  onColorChanged: (color) {
                    onColorChanged(color);
                  },
                ),
              ),
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () => Navigator.of(context).pop(currentColor),
                ),
              ],
            );
          },
        );
        if (pickedColor != null) {
          setState(() {
            onColorChanged(pickedColor);
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text("Calculadora"),
        backgroundColor: _backgroundColor,
        actions: [
          IconButton(
            icon: Icon(Icons.palette),
            onPressed: _showColorPickerDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.bottomRight,
              child: Text(
                _output,
                style: TextStyle(
                  color: _textColor,
                  fontSize: 48,
                ),
              ),
            ),
          ),
          _buildButtonRow(["C", "⌫", "+/-", "÷"]),
          _buildButtonRow(["7", "8", "9", "×"]),
          _buildButtonRow(["4", "5", "6", "-"]),
          _buildButtonRow(["1", "2", "3", "+"]),
          _buildButtonRow([".", "0", "", "="]),
        ],
      ),
    );
  }

  Widget _buildButtonRow(List<String> buttons) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: buttons.map((button) {
          return button.isEmpty
              ? Expanded(child: Container())
              : _buildButton(button);
        }).toList(),
      ),
    );
  }

  Widget _buildButton(String buttonText) {
    Color buttonColor;
    if (buttonText == "C" || buttonText == "⌫" || buttonText == "+/-") {
      buttonColor = _specialButtonColor;
    } else if (["+", "-", "×", "÷", "="].contains(buttonText)) {
      buttonColor = _operationButtonColor;
    } else {
      buttonColor = _buttonColor;
    }

    return Expanded(
      child: Container(
        margin: EdgeInsets.all(6),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () => _onButtonPressed(buttonText),
          child: Text(
            buttonText,
            style: TextStyle(
              color: _textColor,
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }
}

// Widget básico para selección de color (simplificado)
class ColorPicker extends StatefulWidget {
  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;

  ColorPicker({required this.pickerColor, required this.onColorChanged});

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late Color _currentColor;

  @override
  void initState() {
    super.initState();
    _currentColor = widget.pickerColor;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildColorRow([
          Colors.red,
          Colors.pink,
          Colors.purple,
          Colors.deepPurple,
        ]),
        _buildColorRow([
          Colors.indigo,
          Colors.blue,
          Colors.lightBlue,
          Colors.cyan,
        ]),
        _buildColorRow([
          Colors.teal,
          Colors.green,
          Colors.lightGreen,
          Colors.lime,
        ]),
        _buildColorRow([
          Colors.yellow,
          Colors.amber,
          Colors.orange,
          Colors.deepOrange,
        ]),
        _buildColorRow([
          Colors.brown,
          Colors.grey,
          Colors.blueGrey,
          Colors.black,
        ]),
        SizedBox(height: 20),
        Container(
          width: 100,
          height: 50,
          decoration: BoxDecoration(
            color: _currentColor,
            border: Border.all(),
          ),
        ),
      ],
    );
  }

  Widget _buildColorRow(List<Color> colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: colors.map((color) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _currentColor = color;
            });
            widget.onColorChanged(color);
          },
          child: Container(
            margin: EdgeInsets.all(4),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(
                color: _currentColor == color ? Colors.white : Colors.transparent,
                width: 2,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}