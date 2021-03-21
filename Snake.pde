class Snake {
   
  int score = 1;
  int xVel, yVel;
  int foodItterate = 0;  //itterator to run through the foodlist (used for replay)
  boolean dead = false;
  boolean replay = false;  //if this snake is a replay of best snake
  PVector head;
  ArrayList<PVector> body;  //snakes body
  
  Food food;
  
  Snake() {
    this(hidden_layers);
  }
  
  Snake(int layers) {
    head = new PVector(800,height/2);
    food = new Food();
    body = new ArrayList<PVector>();
  }
  
  boolean bodyCollide(float x, float y) {  //check if a position collides with the snakes body
     for(int i = 0; i < body.size(); i++) {
        if(x == body.get(i).x && y == body.get(i).y)  {
           return true;
        }
     }
     return false;
  }
  
  boolean foodCollide(float x, float y) {  //check if a position collides with the food
     if(x == food.pos.x && y == food.pos.y) {
         return true;
     }
     return false;
  }
  
  boolean wallCollide(float x, float y) {  //check if a position collides with the wall
     if(x >= width-(SIZE) || x < 400 + SIZE || y >= height-(SIZE) || y < SIZE) {
       return true;
     }
     return false;
  }
  
  void show() {  //show the snake
     food.show();
     fill(255);
     stroke(0);
     for(int i = 0; i < body.size(); i++) {
       rect(body.get(i).x,body.get(i).y,SIZE,SIZE);
     }
     if(dead) {
       fill(150);
     } else {
       fill(255);
     }
     rect(head.x,head.y,SIZE,SIZE);
  }
  
  void move() {  //move the snake
     if(!dead){
       if(foodCollide(head.x,head.y)) {
          eat();
       }
       shiftBody();
       if(wallCollide(head.x,head.y)) {
         dead = true;
       } else if(bodyCollide(head.x,head.y)) {
         dead = true;
       }
     }
  }
  
  void eat() {  //eat food
    int len = body.size()-1;
    score++;
    if(len >= 0) {
      body.add(new PVector(body.get(len).x,body.get(len).y));
    } else {
      body.add(new PVector(head.x,head.y)); 
    }
    if(!replay) {
      food = new Food();
      while(bodyCollide(food.pos.x,food.pos.y)) {
         food = new Food();
      }
    } else {  //if the snake is a replay, then we dont want to create new random foods, we want to see the positions the best snake had to collect
      foodItterate++;
    }
  }
  
  void shiftBody() {  //shift the body to follow the head
    float tempx = head.x;
    float tempy = head.y;
    head.x += xVel;
    head.y += yVel;
    float temp2x;
    float temp2y;
    for(int i = 0; i < body.size(); i++) {
       temp2x = body.get(i).x;
       temp2y = body.get(i).y;
       body.get(i).x = tempx;
       body.get(i).y = tempy;
       tempx = temp2x;
       tempy = temp2y;
    } 
  }
  

  
  
  void moveUp() { 
    if(yVel!=SIZE) {
      xVel = 0; yVel = -SIZE;
    }
  }
  void moveDown() { 
    if(yVel!=-SIZE) {
      xVel = 0; yVel = SIZE; 
    }
  }
  void moveLeft() { 
    if(xVel!=SIZE) {
      xVel = -SIZE; yVel = 0; 
    }
  }
  void moveRight() { 
    if(xVel!=-SIZE) {
      xVel = SIZE; yVel = 0;
    }
  }
}
