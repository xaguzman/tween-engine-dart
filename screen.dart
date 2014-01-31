part of tweenengine.example;

abstract class Screen {
  final TweenManager _tweenManager = new TweenManager();
  List<bool> _useDots;
  CanvasRenderingContext2D context;
  String font;
  ExampleApp app;
  
  Vector2 vector1, vector2;
  String title = "", info = '';
    
  Screen(this.context, this.title){   
    font = "normal 16pt arial";
  }
  
  void onClick(MouseEvent e) {}
  
  void onKeyDown(KeyboardEvent e) {}
      
  initialize();
  
  render(num delta){
    num textX = context.canvas.width * 0.5 - (title.length * 5);
    context.font = this.font;
    context.fillStyle = 'White';
    context.fillText(title, textX, 30);
  }
  
  dispose();
}

