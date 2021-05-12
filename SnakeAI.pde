import java.math.RoundingMode;
import java.text.DecimalFormat;
private static DecimalFormat df = new DecimalFormat("0.00");

final int SIZE = 20;
final int hidden_nodes = 16;
final int hidden_layers = 2;
final int fps = 100; 

int highscore = 0;

float mutationRate = 0.05;
float defaultmutation = mutationRate;

boolean humanPlaying = false;  
boolean replayBest = true;  
boolean seeVision = true;  
boolean modelLoaded = false;

PFont font;

ArrayList<Integer> evolution;

Button graphButton;
Button loadButton;
Button saveButton;
Button increaseMut;
Button decreaseMut;

EvolutionGraph graph;

Snake snake;
Snake model;

Population pop;

public void settings() {
  size(1200,800);
}

void setup() {
  font = createFont("agencyfb-bold.ttf",32);
  evolution = new ArrayList<Integer>();
  graphButton = new Button(349,15,100,30,"Graph");
  loadButton = new Button(249,15,100,30,"Load");
  saveButton = new Button(149,15,100,30,"Save");
  increaseMut = new Button(350,100,20,20,"+");
  decreaseMut = new Button(375,100,20,20,"-");
  frameRate(fps);
  if(humanPlaying) {
    snake = new Snake();

  } else {
    pop = new Population(2000); 
  }
}

void draw() {
  background(0);
  noFill();
  stroke(255);
  line(400,0,400,height);
  rectMode(CORNER);
  rect(400 + SIZE,SIZE,width-400-40,height-40);
  textFont(font);
  if(humanPlaying) {
    snake.move();
    snake.show();
    fill(150);
    textSize(20);
    text("SCORE : "+snake.score,500,50);
    if(snake.dead) {
       snake = new Snake(); 
    }
  } else {
    if(!modelLoaded) {
      if(pop.done()) {
          highscore = pop.bestSnake.score;
          pop.calculateFitness();
          pop.naturalSelection();
      } else {
          pop.update();
          pop.show(); 
      }
      fill(150);
      textSize(25);
      textAlign(LEFT);
      text("GEN : "+pop.gen,120,70);
      text("BEST FITNESS : "+pop.bestFitness,120,50);
      text("MOVES LEFT : "+pop.bestSnake.lifeLeft,120,90);
      text("MUTATION RATE : "+ df.format(mutationRate*100)+"%",120,110);
      text("SCORE : "+pop.bestSnake.score,120,height-45);
      text("HIGHSCORE : "+highscore,120,height-15);
      increaseMut.show();
      decreaseMut.show();
    } else {
      model.look();
      model.think();
      model.move();
      model.show();
      model.brain.show(0,0,360,790,model.vision, model.decision);
      if(model.dead) {
        Snake newmodel = new Snake();
        newmodel.brain = model.brain.clone();
        model = newmodel;
        
     }
     textSize(25);
     fill(150);
     textAlign(LEFT);
     text("SCORE : "+model.score,120,height-45);
    }
    textAlign(LEFT);
    textSize(18);
    //fill(255,0,0);
    //text("RED < 0",120,height-75);
    //fill(0,0,255);
    //text("BLUE > 0",200,height-75);
    graphButton.show();
    loadButton.show();
    saveButton.show();
  }

}



void mousePressed() {
   if(graphButton.collide(mouseX,mouseY)) {
       graph = new EvolutionGraph();
   }
   if(loadButton.collide(mouseX,mouseY)) {
       selectInput("Load Snake Model", "fileSelectedIn");
   }
   if(saveButton.collide(mouseX,mouseY)) {
       selectOutput("Save Snake Model", "fileSelectedOut");
   }
   if(increaseMut.collide(mouseX,mouseY)) {
      mutationRate += 0.025;
      defaultmutation = mutationRate;
   }
   if(decreaseMut.collide(mouseX,mouseY)) {
      mutationRate -= 0.025;
      defaultmutation = mutationRate;
   }
}


void keyPressed() {
  if(humanPlaying) {
    if(key == CODED) {
       switch(keyCode) {
          case UP:
            snake.moveUp();
            break;
          case DOWN:
            snake.moveDown();
            break;
          case LEFT:
            snake.moveLeft();
            break;
          case RIGHT:
            snake.moveRight();
            break;
       }
    }
  }
}
