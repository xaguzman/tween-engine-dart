part of tweenengine.tests;

abstract class Test {
  final TweenManager _tweenManager = new TweenManager();
  List<bool> _useDots;
  CanvasRenderingContext2D context;
  String font;
  
  Vector2 vector1, vector2;
  String title = "", info = '';
  
  num wpw = 10;
  num wph ;
  
  Test(this.context){
    this.wph = 10;
    this.wph = 10 * (context.canvas.height / context.canvas.width);
    
    int w = context.canvas.width;
    
    if (w > 600) 
      font = "normal 24pt arial";
    else 
      font = "normal 16pt arial";
  }
  
  void onClick(MouseEvent e) {}
      
  initialize();
  
  render(num delta){
    context.font = this.font;
    context.fillStyle = 'White';
    context.fillText("$title", 130, 30);
  }
  
  dispose();
}

