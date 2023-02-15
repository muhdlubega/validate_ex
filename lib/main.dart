import 'dart:io';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'ValidateEX',
      home: ValidateEx(),
    );
  }
}

class ValidateEx extends StatefulWidget {
  const ValidateEx({super.key});

  @override
  _ValidateExState createState() => _ValidateExState();
}

class _ValidateExState extends State<ValidateEx> {
  final TextEditingController _controller = TextEditingController();
  String _cardType = '';
  String _isValid = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _validateCard(String cardNumber) {
    String isValid = validateLuhn(cardNumber);

    if (isValid == 'Card number is valid') {
      String cardType = getCardType(cardNumber);

      setState(() {
        _isValid = isValid;
        _cardType = cardType;
      });
    } else {
      setState(() {
        _isValid = isValid;
        _cardType = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/card.png',
              scale: 16,
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              "ValidateEX",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 28.0,
              ),
            ),
          ],
        ),
        toolbarHeight: 80,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(100),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter a credit card number',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                String cardNumber = _controller.text.trim();
                _validateCard(cardNumber);
              },
              child: const Text('Validate'),
            ),
            const SizedBox(height: 16.0),
            Text(
              _isValid,
              style: const TextStyle(
                /*color: _isValid ? Colors.green : Colors.red,*/
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            Text(
              _cardType,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

String validateLuhn(String cardNumber) {
  List<int> cardDigits = cardNumber.split('').reversed.map(int.parse).toList();

  int sum = 0;
  int digit;
  int i = 0;

  while (i < cardDigits.length) {
    digit = cardDigits[i];

    if (i % 2 == 1) {
      digit *= 2;
    }

    sum += digit % 10 + digit ~/ 10;
    i++;
  }

  if (sum % 10 == 0) {
    return 'Card number is valid';
  } else {
    return 'Card number is invalid';
  }
}

String getCardType(String cardNumber) {
  if (cardNumber.startsWith('4')) {
    return 'Card type is Visa';
  } else if (cardNumber.startsWith('5')) {
    return 'Card type is Mastercard';
  } else if (cardNumber.startsWith('34') || cardNumber.startsWith('37')) {
    return 'Card type is Amex';
  } else if (cardNumber.startsWith('30') || cardNumber.startsWith('38')) {
    return 'Card type is Diners Club';
  } else if (cardNumber.startsWith('35')) {
    return 'Card type is JCB';
  } else if (cardNumber.startsWith('60')) {
    return 'Card type is Discover';
  } else {
    return 'Card type is unknown';
  }
}
