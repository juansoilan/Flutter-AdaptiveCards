import 'package:flutter/material.dart';

import '../additional.dart';
import '../base.dart';

class AdaptiveDateInput extends StatefulWidget with AdaptiveElementWidgetMixin {
  AdaptiveDateInput({Key key, this.adaptiveMap}) : super(key: key);

  final Map adaptiveMap;

  @override
  _AdaptiveDateInputState createState() => _AdaptiveDateInputState();
}

class _AdaptiveDateInputState extends State<AdaptiveDateInput>
    with AdaptiveTextualInputMixin, AdaptiveElementMixin, AdaptiveInputMixin {
  DateTime selectedDateTime;
  DateTime min;
  DateTime max;

  @override
  void initState() {
    super.initState();

    try {
      selectedDateTime = DateTime.parse(value);
      min = DateTime.parse(adaptiveMap["min"]);
      max = DateTime.parse(adaptiveMap["max"]);
    } catch (formatException) {}
  }

  @override
  Widget build(BuildContext context) {
    return SeparatorElement(
      adaptiveMap: adaptiveMap,
      child: ElevatedButton(
        onPressed: () async {
          selectedDateTime = await widgetState.pickDate(min, max);
          setState(() {});
        },
        child: Text(selectedDateTime == null ? placeholder : selectedDateTime.toIso8601String()),
      ),
    );
  }

  @override
  void appendInput(Map map) {
    map[id] = selectedDateTime.toIso8601String();
  }
}
