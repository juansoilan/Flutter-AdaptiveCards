import 'package:flutter/material.dart';

import '../additional.dart';
import '../base.dart';

class AdaptiveTimeInput extends StatefulWidget with AdaptiveElementWidgetMixin {
  AdaptiveTimeInput({Key key, this.adaptiveMap}) : super(key: key);

  final Map adaptiveMap;

  @override
  _AdaptiveTimeInputState createState() => _AdaptiveTimeInputState();
}

class _AdaptiveTimeInputState extends State<AdaptiveTimeInput>
    with AdaptiveTextualInputMixin, AdaptiveElementMixin, AdaptiveInputMixin {
  TimeOfDay selectedTime;
  TimeOfDay min;
  TimeOfDay max;

  @override
  void initState() {
    super.initState();

    selectedTime = parseTime(value) ?? TimeOfDay.now();
    min = parseTime(adaptiveMap["min"]) ?? TimeOfDay(minute: 0, hour: 0);
    max = parseTime(adaptiveMap["max"]) ?? TimeOfDay(minute: 59, hour: 23);
  }

  TimeOfDay parseTime(String time) {
    if (time == null || time.isEmpty) return null;
    List<String> times = time.split(":");
    assert(times.length == 2, "Invalid TimeOfDay format");
    return TimeOfDay(
      hour: int.parse(times[0]),
      minute: int.parse(times[1]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SeparatorElement(
      adaptiveMap: adaptiveMap,
      child: ElevatedButton(
        onPressed: () async {
          TimeOfDay result = await widgetState.pickTime();
          if (result.hour >= min.hour && result.hour <= max.hour) {
            widgetState.showError("Time must be after ${min.format(widgetState.context)}"
                " and before ${max.format(widgetState.context)}");
          } else {
            setState(() {
              selectedTime = result;
            });
          }
        },
        child: Text(selectedTime == null ? placeholder : selectedTime.format(widgetState.context)),
      ),
    );
  }

  @override
  void appendInput(Map map) {
    map[id] = selectedTime.toString();
  }
}
