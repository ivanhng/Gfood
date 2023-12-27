import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:gfood_app/components/constant.dart';

class WheelOfNamesScreen extends StatefulWidget {
  const WheelOfNamesScreen({super.key});

  @override
  _WheelOfNamesScreenState createState() => _WheelOfNamesScreenState();
}

class _WheelOfNamesScreenState extends State<WheelOfNamesScreen> {
  final TextEditingController _itemController = TextEditingController();
  final List<String> _items = [];
  final StreamController<int> _selected = StreamController<int>();

  void _addItem() {
    setState(() {
      _items.add(_itemController.text);
      _itemController.clear();
    });
  }

  @override
  void dispose() {
    _selected.close(); // Dispose the StreamController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wheel of Names'),
        backgroundColor: kPrimaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enter an item:'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _itemController,
                    onSubmitted: (_) => _addItem(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addItem,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_items.isNotEmpty)
              AspectRatio(
                aspectRatio: 1,
                child: FortuneWheel(
                  selected: _selected.stream,
                  items: _items
                      .map(
                        (item) => FortuneItem(
                          child: Text(item),
                        ),
                      )
                      .toList(),
                ),
              ),
            const SizedBox(height: 16),
            if (_items.isNotEmpty)
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    final newValue =
                        (_items.length - 1).clamp(0, _items.length);
                    _selected.add(newValue);
                  },
                  child: const Text('Spin'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
