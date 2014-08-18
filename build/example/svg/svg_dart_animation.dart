
import 'dart:html';
import 'dart:svg';
import 'package:tweenengine/tweenengine.dart' as tween;
 
 
tween.TweenManager _tweenManager;
num lastUpdate = 0;
bool _paused = false;
 
void main() {
  tween.Tween.combinedAttributesLimit = 2;
  tween.Tween.registerAccessor(RectElement, new RectAccessor());
  
  ButtonElement btn = querySelector('#btnToggle');
  btn.onClick.listen((event) => _paused = !_paused);
  
  SvgSvgElement svg_box = querySelector('#svg');
  RectElement rectangle = svg_box.children.first as RectElement;  
  
  //these are the keyframes...they could be loaded from some other svg 
  RectElement kf1= new RectElement()
      ..attributes = {
         'x': '50', 
         'y': '100',
         'rx': '20',
         'ry': '20',
         'width': '250',
         'height': '150',
      };
  
  RectElement kf2= new RectElement()
        ..attributes = {
           'x': '0', 
           'y': '50',
           'rx': '20',
           'ry': '20',
           'width': '350',
           'height': '250',
        };
   
  _tweenManager = new tween.TweenManager();
  tween.Timeline.createSequence()
    ..beginParallel()
      ..push( tween.Tween.to(rectangle, RectAccessor.XY, 0)..targetValues = [kf1.x.baseVal.value, kf1.y.baseVal.value]  )
      ..push( tween.Tween.to(rectangle, RectAccessor.RXRY, 0)..targetValues = [kf1.rx.baseVal.value, kf1.ry.baseVal.value] )
      ..push( tween.Tween.to(rectangle, RectAccessor.WH, 0)..targetValues = [kf1.width.baseVal.value, kf1.height.baseVal.value] )
    ..end()
    ..beginParallel()
      ..push( tween.Tween.to(rectangle, RectAccessor.XY, 0.5)..targetValues = [kf2.x.baseVal.value, kf2.y.baseVal.value]  )
      ..push( tween.Tween.to(rectangle, RectAccessor.RXRY, 0.5)..targetValues = [kf2.rx.baseVal.value, kf2.ry.baseVal.value] )
      ..push( tween.Tween.to(rectangle, RectAccessor.WH, 0.5)..targetValues = [kf2.width.baseVal.value, kf2.height.baseVal.value] )
    ..end()
    ..repeat(tween.Tween.INFINITY, 0, true)
    ..start(_tweenManager);
    
    window.animationFrame.then(update);
}
 
void update(num delta){
  num deltaTime = (delta - lastUpdate) / 1000;
  lastUpdate = delta;
  if (!_paused)
    _tweenManager.update(deltaTime);
  window.animationFrame.then(update);
}
 
class RectAccessor implements tween.TweenAccessor<RectElement>{
  static const int XY = 1;
  static const int RXRY = 2;
  static const int W = 3;
  static const int H = 4;
  static const int WH = 5;
  
  int getValues(RectElement target, int tweenType, List<num> returnValues){
    switch (tweenType){
      case XY:
        returnValues.setRange(0, 2, [target.x.baseVal.value, target.y.baseVal.value]);
        return 2;
      case RXRY:
        returnValues.setRange(0, 2, [target.rx.baseVal.value, target.ry.baseVal.value]);
        return 2;
      case W:
        returnValues[0] = target.width.baseVal.value;
        return 1;
      case H:
        returnValues[0] = target.height.baseVal.value;
        return 1;
      case WH:
        returnValues.setRange(0, 2, [target.width.baseVal.value, target.height.baseVal.value]);
        return 2;
    }
  }
  
  void setValues(RectElement target, int tweenType, List<num> newValues){
    switch (tweenType){
      case XY:
        target.x.baseVal.value = newValues[0];
        target.y.baseVal.value = newValues[1];
        break;
      case RXRY:
        target.rx.baseVal.value = newValues[0];
        target.ry.baseVal.value = newValues[1];
        break;
      case W:
        target.width.baseVal.value = newValues[0];
        break;
      case H:
        target.height.baseVal.value = newValues[0];
        break;
      case WH:
        target.width.baseVal.value = newValues[0];
        target.height.baseVal.value = newValues[1];
        break;
    }
  }
}