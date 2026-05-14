import 'package:flutter/material.dart';

class CounterWithPlusMinus extends StatefulWidget {

  final String titel;
  final int max;
  final int min;

  const CounterWithPlusMinus({
    super.key,
    required this.titel,
    required this.max,
    required this.min,
  });

  @override
  State<CounterWithPlusMinus> createState() => _SliderContainerState();
}

class _SliderContainerState extends State<CounterWithPlusMinus> {
  double _currentValue = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.titel),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 0),

          child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                  Row(
                  children : [
                    ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if(_currentValue < widget.max) {
                          _currentValue++;
                        }
                      });
                    },
                    child: Icon(Icons.add_circle),
                  ),

                SizedBox(
                  width: 20,
                ),

                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if(_currentValue > widget.min) {
                          _currentValue--;
                        }
                      }
                      );
                    },
                    child: Icon(Icons.remove_circle)
                ),
                ],
                ),

                SizedBox(
                  width: 30,
                ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),

                  child: Text(_currentValue.toInt().toString(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ]
          ),
        ),
        Divider(

        )


      ],
    );
  }
}