import 'package:flutter/material.dart';

import '../brightness_switch.dart';
import '../loading_adaptive_card.dart';

class PerformanceTestPage extends StatefulWidget {
  PerformanceTestPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PerformanceTestPageState();
}

class PerformanceTestPageState extends State<PerformanceTestPage> {
  static const sampleCount = 15;
  var currentSampleCount = 1;
  List<Widget> cards = List<Widget>();

  @override
  void initState() {
    cards.add(DemoAdaptiveCard("lib/samples/example1", supportMarkdown: false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Performance test"),
        actions: [
          BrightnessSwitch(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Text("Add"),
        onPressed: () {
          setState(() {
            currentSampleCount++;
            cards.add(DemoAdaptiveCard("lib/samples/example${(currentSampleCount + 1) % (sampleCount + 1)}", supportMarkdown: false));
          });
        },
      ),
      body: ListView.builder(
        addAutomaticKeepAlives: true,
        itemCount: currentSampleCount,
        itemBuilder: (context, index) {
          return cards[index];
        },
      ),
    );
  }
}
