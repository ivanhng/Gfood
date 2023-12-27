import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gfood_app/components/data/models/restaurant.dart';

class SpinningWheel extends StatefulWidget {
  final List<Item> items;
  final Function(Item) onItemSelected;
  final String imagePath;

  const SpinningWheel({
    Key? key,
    required this.items,
    required this.onItemSelected,
    this.imagePath = 'assets/images/wheel_of_fortune.svg',
  }) : super(key: key);

  @override
  SpinningWheelState createState() => SpinningWheelState();
}

class SpinningWheelState extends State<SpinningWheel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _currentRotation = 0.0;
  bool _isSpinning = false;

  void _spinWheel() {
    setState(() {
      _isSpinning = true;
    });
    // Calculate a random spin angle.
    final randomAngle = Random().nextDouble() * 2 * pi;
    _controller.duration = const Duration(seconds: 5) +
        Duration(milliseconds: (500 * randomAngle).toInt());
    _controller.forward(from: 0.0).then((value) {
      _controller.reset();
      final selectedIndex =
          ((randomAngle / (2 * pi)) * widget.items.length).floor();
      widget.onItemSelected(widget.items[selectedIndex]);
      setState(() {
        _isSpinning = false;
      });
    });
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )
      ..addListener(() {
        setState(() {
          _currentRotation = (_currentRotation + _controller.value) % (2 * pi);
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _isSpinning = false;
          });
        }
      });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Transform.rotate(
          angle: _currentRotation,
          child: GestureDetector(
            onTap: _spinWheel,
            child: Container(
              child: SvgPicture.asset(
                widget.imagePath,
                height: 300,
                width: 300,
              ),
            ),
          ),
        ),
        if (_isSpinning)
          Positioned.fill(
            child: Container(
              color: Colors.black38,
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }
}
