///
/// This is a convenience because we build so many cards in the example
///
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_adaptive_cards/flutter_adaptive_cards.dart';

///
/// Adaptive card driven from network and not assets or URL
///
class RemoteAdaptiveCard extends StatelessWidget {
  const RemoteAdaptiveCard({Key key, this.url}) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return AdaptiveCard.network(
      hostConfigPath: "lib/host_config",
      url: url,
      showDebugJson: true,
    );
  }
}

///
/// Adaptive card driven from memory and not assets or URL
///
class LabAdaptiveCard extends StatelessWidget {
  const LabAdaptiveCard({Key key, this.payload}) : super(key: key);

  final String payload;

  @override
  Widget build(BuildContext context) {
    return AdaptiveCard.memory(
      hostConfigPath: "lib/host_config",
      content: json.decode(payload),
      showDebugJson: true,
    );
  }
}

///
/// Adaptive card driven from assets and not memory or URL
/// Missing the "Show the JSON" button
///
class DemoAdaptiveCard extends StatefulWidget {
  const DemoAdaptiveCard(
    this.assetPath, {
    Key key,
    this.hostConfig,
    this.approximateDarkThemeColors = true,
    this.supportMarkdown = true,
  }) : super(key: key);

  final String assetPath;
  final String hostConfig;
  final bool approximateDarkThemeColors;
  final bool supportMarkdown;

  @override
  _DemoAdaptiveCardState createState() => new _DemoAdaptiveCardState();
}

/// This exists as stateful to support the "show the JSON" function
/// Note that it means we load the JSON twice, once for this and once for the widget
class _DemoAdaptiveCardState extends State<DemoAdaptiveCard>
    with AutomaticKeepAliveClientMixin {
  String jsonFile;

  @override
  void initState() {
    super.initState();
    rootBundle.loadString(widget.assetPath).then((string) {
      jsonFile = string;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          AdaptiveCard.asset(
            assetPath: widget.assetPath,
            hostConfigPath: "lib/host_config",
            showDebugJson: false,
            hostConfig: widget.hostConfig,
            approximateDarkThemeColors: widget.approximateDarkThemeColors,
            supportMarkdown: widget.supportMarkdown,
          ),
          TextButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.indigo, // textColor
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("JSON"),
                      content: SingleChildScrollView(child: Text(jsonFile)),
                      actions: <Widget>[
                        Center(
                          child: TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text("Thanks"),
                          ),
                        )
                      ],
                      contentPadding: EdgeInsets.all(8.0),
                    );
                  });
            },
            child: Text("Show the JSON"),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
