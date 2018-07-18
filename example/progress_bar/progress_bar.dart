import 'dart:html';
import 'package:tweenengine/tweenengine.dart';

TweenManager _manager = TweenManager();
num lastUpdate = 0;
RegExp percent = RegExp("%");

void main() {
  Tween.registerAccessor(CssStyleDeclaration, StyleAccessor());

  DivElement bar = querySelector(".progress-bar");
  var target = bar.style;

  //Animate fully from 0 to current value (60%)
  Tween.from(target, 1, 3)
    ..delay = 2
    ..targetValues = [0]
    ..easing = TweenEquations.easeOutExpo
    ..start(_manager);

  window.animationFrame.then(update);
}

void update(num delta) {
  num deltaTime = (delta - lastUpdate) / 1000;
  lastUpdate = delta;
  _manager.update(deltaTime);
  window.animationFrame.then(update);
}

class StyleAccessor implements TweenAccessor<CssStyleDeclaration> {
  static const int Width = 1;

  int getValues(CssStyleDeclaration target, Tween tween, int tweenType,
      List<num> returnValues) {
    if (tweenType != Width) return 0;

    //strip the % from the style
    num numericValue = num.parse(target.width.replaceAll(percent, ""));
    returnValues[0] = numericValue;

    return 1;
  }

  void setValues(CssStyleDeclaration target, Tween tween, int tweenType,
      List<num> newValues) {
    if (tweenType != Width) return;

    target.width = newValues[0].toString() + "%";
  }
}
