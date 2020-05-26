import 'package:flutter/material.dart';

import '../additional.dart';
import '../base.dart';

class AdaptiveFactSet extends StatefulWidget with AdaptiveElementWidgetMixin {
  AdaptiveFactSet({Key key, this.adaptiveMap}) : super(key: key);

  final Map adaptiveMap;

  @override
  _AdaptiveFactSetState createState() => _AdaptiveFactSetState();
}

class _AdaptiveFactSetState extends State<AdaptiveFactSet> with AdaptiveElementMixin {
  List<Map> facts;

  @override
  void initState() {
    super.initState();
    facts = List<Map>.from(adaptiveMap["facts"]).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SeparatorElement(
      adaptiveMap: adaptiveMap,
      child: Row(
        children: [
          Column(
            children: facts
                .map((fact) => Text(
                      fact["title"],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))
                .toList(),
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          SizedBox(
            width: 8.0,
          ),
          Column(
            children: facts.map((fact) => Text(fact["value"])).toList(),
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }
}