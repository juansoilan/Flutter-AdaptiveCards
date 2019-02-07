import 'package:flutter/material.dart';
import 'package:flutter_adaptive_cards/flutter_adaptive_cards.dart';
import 'package:flutter_adaptive_cards/src/elements/basics.dart';

/// Actions

abstract class AdaptiveAction extends AdaptiveElement {
  AdaptiveAction(
      {Map adaptiveMap,
        ReferenceResolver resolver,
        widgetState,
        AtomicIdGenerator idGenerator, @required CardRegistry cardRegistry})
      : super(
      adaptiveMap: adaptiveMap,
      resolver: resolver,
      widgetState: widgetState,
      cardRegistry: cardRegistry,
      idGenerator: idGenerator);

  String get title => adaptiveMap["title"];

  void onTapped();
}

class AdaptiveActionShowCard extends AdaptiveAction {
  AdaptiveActionShowCard(Map adaptiveMap, ReferenceResolver resolver,
      widgetState, AtomicIdGenerator idGenerator, this._adaptiveCardElement, CardRegistry cardRegistry)
      : super(
      adaptiveMap: adaptiveMap,
      resolver: resolver,
      cardRegistry: cardRegistry,
      widgetState: widgetState,
      idGenerator: idGenerator);

  AdaptiveElement card;

  final AdaptiveCardElement _adaptiveCardElement;

  bool expanded = false;

  @override
  void loadTree() {
    super.loadTree();
    card = cardRegistry.getElement(adaptiveMap["card"], resolver, widgetState, idGenerator);
  }

  @override
  Widget build() {
    return RaisedButton(
      onPressed: onTapped,
      child: Row(
        children: <Widget>[
          Text(title),
          expanded
              ? Icon(Icons.keyboard_arrow_up)
              : Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }

  @override
  void onTapped() {
    if (_adaptiveCardElement != null) {
      _adaptiveCardElement.showCard(this);
    }
  }

  @override
  void visitChildren(AdaptiveElementVisitor visitor) {
    card.visitChildren(visitor);
  }
}

class AdaptiveActionSubmit extends AdaptiveAction {
  AdaptiveActionSubmit(Map adaptiveMap, ReferenceResolver resolver,
      widgetState, AtomicIdGenerator idGenerator, CardRegistry cardRegistry)
      : super(
      adaptiveMap: adaptiveMap,
      resolver: resolver,
      cardRegistry: cardRegistry,
      widgetState: widgetState,
      idGenerator: idGenerator);

  Map data;

  @override
  void loadTree() {
    super.loadTree();
    data = adaptiveMap["data"] ?? {};
  }

  @override
  Widget build() {
    return RaisedButton(
      onPressed: onTapped,
      child: Text(title),
    );
  }

  @override
  void onTapped() {
    widgetState.submit(data);
  }
}

class AdaptiveActionOpenUrl extends AdaptiveAction with IconButtonMixin {
  AdaptiveActionOpenUrl(Map adaptiveMap, ReferenceResolver resolver,
      widgetState, AtomicIdGenerator idGenerator, CardRegistry cardRegistry)
      : super(
      adaptiveMap: adaptiveMap,
      resolver: resolver,
      cardRegistry: cardRegistry,
      widgetState: widgetState,
      idGenerator: idGenerator);

  String url;
  String iconUrl;

  @override
  void loadTree() {
    super.loadTree();
    url = adaptiveMap["url"];
    iconUrl = adaptiveMap["iconUrl"];
  }

  @override
  Widget build() {
    return getButton();
  }

  @override
  void onTapped() {
    widgetState.openUrl(url);
  }
}