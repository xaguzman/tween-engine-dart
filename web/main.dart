library tweenengine.tests;

import 'dart:html';
import 'package:tweenengine/tweenengine.dart';

part 'tests.dart';

main(){
  
  var app = new TestApp("#canvas");
  app.start();
  
  window.animationFrame.then(app.render);
}



class TestApp{
  CanvasElement canvas ;
  CanvasRenderingContext2D context;
  Vector2 v;
  TweenManager manager;
  num lastUpdate = 0 ;
  Test currentTest;
  
  TestApp(String canvasId){
    this.canvas = querySelector(canvasId);
    this.context = canvas.getContext("2d");
    this.v = new Vector2()
      ..x = 30
      ..y = 30;
    manager = new TweenManager();
  }
  
  start(){
    Tween.registerAccessor(Vector2, new VectorAccessor() );
    currentTest = new Functions(context);
    currentTest.initialize();
  }
  
  
  render(num delta){
    num deltaTime = (delta - lastUpdate) / 1000;
    lastUpdate = delta;
    
    context.setFillColorRgb(0, 0, 0, 1);
    context.fillRect(0, 0, canvas.width, canvas.height);
    
    currentTest.render(deltaTime);
    //context.stroke();
    window.animationFrame.then(render);
  }
}

class VectorAccessor extends TweenAccessor<Vector2>{
  
  static const int XY = 1;
  
  int getValues(Vector2 target, int tweenType, List<num> returnValues){
    returnValues[0] = target.x;
    returnValues[1] = target.y;
    
    return 2;
  }
  
  void setValues(Vector2 target, int tweenType, List<num> newValues){
    target.x = newValues[0];
    target.y = newValues[1];
  }
}

class Vector2{
  num x = 0, y = 0;
  
  Vector2([this.x, this.y]);
  
  String toString() => "[$x , $y]";
}