import 'package:tweenengine/tweenengine.dart';
import 'dart:html' as html;
import 'dart:svg';

TweenManager _tweenManager;
num lastUpdate = 0;
bool _paused = false;

void main() {
  Tween.combinedAttributesLimit = 2;
  Tween.registerAccessor(RectElement, RectAccessor());

  html.ButtonElement btn = html.querySelector('#btnToggle');
  btn.onClick.listen((event) => _paused = !_paused);

  SvgSvgElement svg_box = html.querySelector('#svg');
  RectElement rectangle = svg_box.children.first as RectElement;

  //these are the keyframes...they could be loaded from some other svg
  RectElement kf1 = RectElement()
    ..attributes = {
      'x': '50',
      'y': '100',
      'rx': '20',
      'ry': '20',
      'width': '250',
      'height': '150',
    };

  RectElement kf2 = RectElement()
    ..attributes = {
      'x': '0',
      'y': '50',
      'rx': '20',
      'ry': '20',
      'width': '350',
      'height': '250',
    };

  _tweenManager = TweenManager();
  Timeline.sequence()
    ..beginParallel()
    ..push(Tween.to(rectangle, RectAccessor.xy, 0)
      ..targetValues = [kf1.x.baseVal.value, kf1.y.baseVal.value])
    ..push(Tween.to(rectangle, RectAccessor.rxry, 0)
      ..targetValues = [kf1.rx.baseVal.value, kf1.ry.baseVal.value])
    ..push(Tween.to(rectangle, RectAccessor.wh, 0)
      ..targetValues = [kf1.width.baseVal.value, kf1.height.baseVal.value])
    ..end()
    ..beginParallel()
    ..push(Tween.to(rectangle, RectAccessor.xy, 0.5)
      ..targetValues = [kf2.x.baseVal.value, kf2.y.baseVal.value])
    ..push(Tween.to(rectangle, RectAccessor.rxry, 0.5)
      ..targetValues = [kf2.rx.baseVal.value, kf2.ry.baseVal.value])
    ..push(Tween.to(rectangle, RectAccessor.wh, 0.5)
      ..targetValues = [kf2.width.baseVal.value, kf2.height.baseVal.value])
    ..end()
    ..repeatYoyo(Tween.infinity, 0)
    ..start(_tweenManager);

  html.window.animationFrame.then(update);
}

void update(num delta) {
  num deltaTime = (delta - lastUpdate) / 1000;
  lastUpdate = delta;
  if (!_paused) _tweenManager.update(deltaTime);
  html.window.animationFrame.then(update);
}

class RectAccessor implements TweenAccessor<RectElement> {
  static const int xy = 1;
  static const int rxry = 2;
  static const int w = 3;
  static const int h = 4;
  static const int wh = 5;

  int getValues(
      RectElement target, Tween tween, int tweenType, List<num> returnValues) {
    switch (tweenType) {
      case xy:
        returnValues
            .setRange(0, 2, [target.x.baseVal.value, target.y.baseVal.value]);
        return 2;
      case rxry:
        returnValues
            .setRange(0, 2, [target.rx.baseVal.value, target.ry.baseVal.value]);
        return 2;
      case w:
        returnValues[0] = target.width.baseVal.value;
        return 1;
      case h:
        returnValues[0] = target.height.baseVal.value;
        return 1;
      case wh:
        returnValues.setRange(
            0, 2, [target.width.baseVal.value, target.height.baseVal.value]);
        return 2;
    }
  }

  void setValues(
      RectElement target, Tween tween, int tweenType, List<num> newValues) {
    switch (tweenType) {
      case xy:
        target.x.baseVal.value = newValues[0];
        target.y.baseVal.value = newValues[1];
        break;
      case rxry:
        target.rx.baseVal.value = newValues[0];
        target.ry.baseVal.value = newValues[1];
        break;
      case w:
        target.width.baseVal.value = newValues[0];
        break;
      case h:
        target.height.baseVal.value = newValues[0];
        break;
      case wh:
        target.width.baseVal.value = newValues[0];
        target.height.baseVal.value = newValues[1];
        break;
    }
  }
}
