import 'package:flutter/material.dart';

class SliderContainer extends StatefulWidget {
  final String titel;
  final double max;
  final double min;

  const SliderContainer({
    super.key,
    required this.titel,
    required this.max,
    required this.min,
  });

  @override
  State<SliderContainer> createState() => _SliderContainerState();
}

class _SliderContainerState extends State<SliderContainer> {
  double _currentValue = 0;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.min;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.titel),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 0),

          child: Row(
          children: [

            Expanded(
            child: Slider(
            value: _currentValue,
            min: widget.min,
            max: widget.max,
            divisions: (widget.max - widget.min).toInt(),
            label: _currentValue.round().toString(),
            onChanged: (double value) {
              setState(() {
                _currentValue = value;
              }
              );
            },
          ),
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