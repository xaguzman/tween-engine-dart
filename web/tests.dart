library tweenengine.tests;

import 'dart:html';
import 'package:tweenengine/tweenengine.dart';

part 'test.dart';
part 'accesors.dart';
part 'tests/functions.dart';
part 'tests/simple_tween.dart';
part 'tests/simple_timeline.dart';
part 'tests/repetitions.dart';
part 'tests/waypoints.dart';

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
    context.canvas.onClick.listen( (MouseEvent e){
      currentTest.onClick(e);
    });
  }
  
  start(){
    Tween.registerAccessor(Vector2, new VectorAccessor() );
    Tween.registerAccessor(Color, new ColorAccessor() );
    Tween.setCombinedAttributesLimit(4);
    Tween.setWaypointsLimit(4);
    //currentTest = new Functions(context);
    //currentTest = new SimpleTween(context);
    //currentTest = new SimpleTimeline(context);
    //currentTest = new Repetitions(context);
    currentTest = new Waypoints(context);
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

