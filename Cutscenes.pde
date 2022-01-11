class Cutscenes
{
  int sceneLocation;
  boolean goneThroughIntro;
  boolean isOnGameOverScreen;
  
  int textOffset = 230;
  PVector sceneOffset = new PVector(250,150);
  
  color darkBrown = color(170, 126, 69);
  color lightBrown = color(190, 156, 99);
  
  Cutscenes(){
    sceneLocation = 1;
    goneThroughIntro = false;
    isOnGameOverScreen = false;
  }
  
  void drawIntroScenes(){
    if(sceneLocation == 1) drawStartScreen();
    if(sceneLocation == 2) drawSceneOne();
    if(sceneLocation == 3) drawSceneTwo();
    if(sceneLocation == 4) drawSceneThree();
    if(sceneLocation >= 5) goneThroughIntro = true;
  }
  
  void drawStartScreen(){
    fill(darkBrown); // darker brown
    rect(0, 0, width, height);
    fill(lightBrown); // light brown
    rect(0, height/2 + 75, width, height/2);
    
    // drawing
    // PLAYER
    pushMatrix();
    translate(width/2 - 350, height/2);
    scale(2);
    rotate(radians(7));
    noStroke();
    fill(20);
    ellipse(0, 0, 70, 45);
    // eyes
    fill(255, 255, 0);
    ellipse(-3, 0, 7, 18);
    ellipse(23, 0, 7, 18);
    fill(72, 61, 139);
    ellipse(0, -20, 90, 10);
    triangle(30, -20, -30, -20, 0, -50);
    stroke(20);
    strokeWeight(3);
    line(15, 40, 15, 58);
    line(15, 58, 23, 58);
    line(-15, 40, -15, 58);
    line(-15, 58, -23, 58);
    strokeWeight(1);
    noStroke();
    fill(72, 61, 139);
    triangle(15, 20, 15, 40, 40, 30);
    triangle(-15, 20, -15, 40, -40, 30);
    fill(102, 91, 169);
    quad(15, 20, 35, 50, -35, 50, -15, 20);
    popMatrix();
    
    // ----- FIREBALL 1 ------
    pushMatrix();
    translate(width/2, height/2 - 25);
    scale(2);
    rotate(radians(95));
    noStroke();
    fill(255, 0, 0);
    ellipse(0, 0, 30, 30);
    triangle(-15, 0, -2, 0, -10, 28);
    triangle(-10, 0, 10, 0, 0, 37);
    triangle(2, 0, 15, 0, 10, 28);
    fill(255, 100);
    ellipse(0, 0, 15, 15);
    popMatrix();
    // ----- FIREBALL 2 -----
    pushMatrix();
    translate(width/2 - 50, height/2 + 50);
    scale(1.5);
    rotate(radians(87));
    noStroke();
    fill(255, 0, 0);
    ellipse(0, 0, 30, 30);
    triangle(-15, 0, -2, 0, -10, 28);
    triangle(-10, 0, 10, 0, 0, 37);
    triangle(2, 0, 15, 0, 10, 28);
    fill(255, 100);
    ellipse(0, 0, 15, 15);
    popMatrix();
    
    // ----- SLIME 1 -----
    pushMatrix();
    translate(width/2+325, height/2 + 80);
    scale(1.5);
    rotate(radians(10));
    // body
    fill(50, 205, 50, 245);
    ellipse(0, 0, 80, 55);  
    fill(40, 195, 40);
    ellipse(0, 16, 47, 13);
    // eyes
    fill(0);
    ellipse(5, -6, 6, 13);
    ellipse(-25, -6, 6, 13);
    popMatrix();
    // ----- SLIME 2 -----
    pushMatrix();
    translate(width/2+350, height/2 - 50);
    scale(1.5);
    rotate(radians(-10));
    // body
    fill(50, 205, 50, 245);
    ellipse(0, 0, 80, 55);  
    fill(40, 195, 40);
    ellipse(0, 16, 47, 13);
    // eyes
    fill(0);
    ellipse(5, -6, 6, 13);
    ellipse(-25, -6, 6, 13);
    popMatrix();
    // ----- SLIME 3 -----
    pushMatrix();
    translate(width/2+450, height/2 + 25);
    scale(1.5);
    rotate(radians(3));
    // body
    fill(50, 205, 50, 245);
    ellipse(0, 0, 80, 55);  
    fill(40, 195, 40);
    ellipse(0, 16, 47, 13);
    // eyes
    fill(0);
    ellipse(5, -6, 6, 13);
    ellipse(-25, -6, 6, 13);
    popMatrix();
    
    textSize(70);
    textAlign(CENTER);
    fill(0);
    text("SLIME FIGHTER", width/2, height/2 - 250);
    textSize(35);
    text("PRESS SPACE BAR TO START", width/2, height/2 + 230);
    textSize(20);
    text("Use WASD to move", width/2, height/2 + 290);
    text("Use mouse buttons to aim and shoot", width/2, height/2 + 330);
  }
  
  void drawSceneOne(){    
    // sky
    fill(135, 206, 250);
    rect(sceneOffset.x, sceneOffset.y, width - sceneOffset.x*2, 400);
    
    // clouds
    fill(240);
    pushMatrix();
    translate(width/2 + 150, height/2 - 200);
    ellipse(0, 0, 60, 60);
    ellipse(45, 0, 60, 60);
    ellipse(-45, 0, 60, 60);
    ellipse(23, -30, 50, 50);
    ellipse(-23, -30, 50, 50);
    popMatrix();
    
    // clouds
    fill(240);
    pushMatrix();
    translate(width/2 - 200, height/2 - 160);
    ellipse(0, 0, 60, 60);
    ellipse(45, 0, 60, 60);
    ellipse(-45, 0, 60, 60);
    ellipse(23, -30, 50, 50);
    ellipse(-23, -30, 50, 50);
    popMatrix();

    // background mountains
    // mountain 1
    pushMatrix();
    fill(150, 106, 49);
    translate(width/2 - 225, height/2 + 150);
    triangle(200, 0, -200, 0, 0, -300);
    popMatrix();
    // mountain 2
    pushMatrix();
    fill(170, 126, 69);
    translate(width/2 + 20, height/2 + 100);
    scale(1.1);
    triangle(200, 0, -200, 0, 0, -300);
    popMatrix();
    // mountain 3
    pushMatrix();
    fill(130, 86, 29);
    translate(width/2 + 325, height/2 + 170);
    triangle(200, 0, -200, 0, 0, -300);
    popMatrix();
    
    // mountain
    fill(lightBrown);
    pushMatrix();
    translate(width/2, height/2 + 160);
    rotate(radians(-8));
    ellipse(0, 0, width + 500, 300);
    popMatrix();

    // PLAYER
    pushMatrix();
    translate(width/2, height/2);
    scale(1);
    rotate(radians(-3));
    noStroke();
    fill(20);
    //stroke(255);
    ellipse(0, 0, 70, 45);
    //noStroke();
    // eyes
    fill(255, 255, 0);
    ellipse(-3, 0, 7, 18);
    ellipse(23, 0, 7, 18);
    fill(72, 61, 139);
    ellipse(0, -20, 90, 10);
    triangle(30, -20, -30, -20, 0, -50);
    stroke(20);
    strokeWeight(3);
    line(15, 40, 15, 58);
    line(15, 58, 23, 58);
    line(-15, 40, -15, 58);
    line(-15, 58, -23, 58);
    strokeWeight(1);
    noStroke();
    fill(72, 61, 139);
    triangle(15, 20, 15, 40, 40, 30);
    triangle(-15, 20, -15, 40, -40, 30);
    fill(102, 91, 169);
    quad(15, 20, 35, 50, -35, 50, -15, 20);
    popMatrix();
    
    // black bg
    fill(30);
    rect(0, 0, width, sceneOffset.y);
    rect(0, 0, sceneOffset.x, height);
    rect(width - sceneOffset.x, 0, sceneOffset.x, height);
    rect(0, sceneOffset.y + 400, width, height);
    
    textSize(30);
    textAlign(CENTER);
    fill(255);
    text("A young magician roams a mountain in search of materials...", width/2, height/2 + textOffset);
    textSize(25);
    text("CONTINUE", width/2, height/2 + textOffset + 75);
  }
  
  void drawSceneTwo(){
    // drawing
    fill(lightBrown); // light brown
    rect(sceneOffset.x, sceneOffset.y, width - sceneOffset.x*2, 400);
    // hole
    fill(140, 96, 39);
    ellipse(width/2, height/2 - 100, 300, 225);
    fill(110, 66, 9);
    ellipse(width/2, height/2 - 23, 190, 70);

    // fall lines
    stroke(0);
    strokeWeight(3);
    pushMatrix();
    translate(width/2, height/2 - 180);
    line(-10, -3, -10, 20);
    line(0, 2, 0, 23);
    line(10, 0, 10, 21);
    popMatrix();
    noStroke();
    
    // PLAYER
    pushMatrix();
    translate(width/2, height/2 - 125);
    scale(0.6);
    rotate(radians(30));
    noStroke();
    fill(20);
    //stroke(255);
    ellipse(0, 0, 70, 45);
    //noStroke();
    // eyes
    fill(255, 255, 0);
    ellipse(-3, 0, 7, 18);
    ellipse(23, 0, 7, 18);
    fill(72, 61, 139);
    ellipse(0, -20, 90, 10);
    triangle(30, -20, -30, -20, 0, -50);
    stroke(20);
    strokeWeight(3);
    line(15, 40, 15, 58);
    line(15, 58, 23, 58);
    line(-15, 40, -15, 58);
    line(-15, 58, -23, 58);
    strokeWeight(1);
    noStroke();
    fill(72, 61, 139);
    triangle(15, 20, 15, 40, 40, 30);
    triangle(-15, 20, -15, 40, -40, 30);
    fill(102, 91, 169);
    quad(15, 20, 35, 50, -35, 50, -15, 20);
    popMatrix();
    
    // black bg
    fill(30);
    rect(0, 0, width, sceneOffset.y);
    rect(0, 0, sceneOffset.x, height);
    rect(width - sceneOffset.x, 0, sceneOffset.x, height);
    rect(0, sceneOffset.y + 400, width, height);
    
    textSize(30);
    textAlign(CENTER);
    fill(255);
    text("When suddenly, he falls down a pit!", width/2, height/2 + textOffset);
    textSize(25);
    text("CONTINUE", width/2, height/2 + textOffset + 75);
  }
 
  void drawSceneThree(){    
    // drawing
    fill(255);
    rect(sceneOffset.x, sceneOffset.y, width - sceneOffset.x*2, 400);
    
    // walls/ground
    fill(darkBrown);
    rect(sceneOffset.x, sceneOffset.y, width - sceneOffset.x*2, 400);
    fill(lightBrown);
    rect(sceneOffset.x, sceneOffset.y + 225, width - sceneOffset.x*2, 400);
    
    // slimes
    // ----- SLIME 1 -----
    pushMatrix();
    translate(sceneOffset.x + 350, sceneOffset.y + 225);
    scale(1);
    // body
    fill(50, 205, 50, 245);
    ellipse(0, 0, 80, 55);  
    fill(40, 195, 40);
    ellipse(0, 16, 47, 13);
    // eyes
    fill(0);
    ellipse(18, -6, 6, 13);
    ellipse(-12, -6, 6, 13);
    popMatrix();
    
    // ----- SLIME 2 -----
    pushMatrix();
    translate(sceneOffset.x + 200, sceneOffset.y + 250);
    scale(1);
    // body
    fill(50, 205, 50, 245);
    ellipse(0, 0, 80, 55);  
    fill(40, 195, 40);
    ellipse(0, 16, 47, 13);
    // eyes
    fill(0);
    ellipse(22, -6, 6, 13);
    ellipse(-8, -6, 6, 13);
    popMatrix();
    
    // player head
    pushMatrix();
    translate(width - sceneOffset.x*2 + 50, sceneOffset.y + 400);
    scale(4);
    fill(20);
    ellipse(0, 0, 70, 45);
    ellipse(0, -20, 90, 10);
    triangle(30, -20, -30, -20, 0, -50);
    popMatrix();
    
    // black bg
    fill(30);
    rect(0, 0, width, sceneOffset.y);
    rect(0, 0, sceneOffset.x, height);
    rect(width - sceneOffset.x, 0, sceneOffset.x, height);
    rect(0, sceneOffset.y + 400, width, height);
    
    textSize(30);
    textAlign(CENTER);
    fill(255);
    text("Upon waking up, he notices several slimes aggressively approaching...", width/2, height/2 + textOffset);
    textSize(25);
    text("START GAME", width/2, height/2 + textOffset + 75);
    
    for(int i = 0; i < enemies.size(); i++) enemies.remove(i);
    for(int i = 0; i < specialItems.size(); i++) { specialItems.remove(i); }
  }
  
  void drawEndScreen(){
    // sky
    fill(135, 206, 250);
    rect(sceneOffset.x, sceneOffset.y, width - sceneOffset.x*2, 400);
    
    // cave outer
    fill(darkBrown);
    pushMatrix();
    rotate(radians(-3));
    rect(sceneOffset.x - 50, sceneOffset.y, 450, 450);
    popMatrix();
    fill(140, 96, 34);
    ellipse(sceneOffset.x + 200, sceneOffset.y + 300, 200, 400);
    
    // ground
    fill(lightBrown);
    rect(sceneOffset.x, sceneOffset.y + 300, width - sceneOffset.x*2, 400);
    
    // PLAYER
    pushMatrix();
    translate(width/2, height/2);
    scale(1);
    noStroke();
    fill(20);
    ellipse(0, 0, 70, 45);
    // eyes
    fill(255, 255, 0);
    ellipse(-3, 0, 7, 18);
    ellipse(23, 0, 7, 18);
    fill(72, 61, 139);
    ellipse(0, -20, 90, 10);
    triangle(30, -20, -30, -20, 0, -50);
    stroke(20);
    strokeWeight(3);
    line(15, 40, 15, 58);
    line(15, 58, 23, 58);
    line(-15, 40, -15, 58);
    line(-15, 58, -23, 58);
    strokeWeight(1);
    noStroke();
    fill(72, 61, 139);
    triangle(15, 20, 15, 40, 40, 30);
    triangle(-15, 20, -15, 40, -40, 30);
    fill(102, 91, 169);
    quad(15, 20, 35, 50, -35, 50, -15, 20);
    popMatrix();
    
    // black bg
    fill(30);
    rect(0, 0, width, sceneOffset.y);
    rect(0, 0, sceneOffset.x, height);
    rect(width - sceneOffset.x, 0, sceneOffset.x, height);
    rect(0, sceneOffset.y + 400, width, height);
    
    textSize(30);
    textAlign(CENTER);
    fill(255);
    text("After slaying all the slimes, the young magician finally escapes the cave!", width/2, height/2 + textOffset);
    textSize(40);
    text("THE END", width/2, height/2 + textOffset + 100);
  }
  
  void drawGameOverScreen(){
    isOnGameOverScreen = true;
    // black screen
    fill(20);
    rect(0, 0, width, height);
    // reset
    textSize(70);
    textAlign(CENTER);
    fill(255, 0, 0);
    text("YOU HAVE DIED", width/2, height/2);
    textSize(30);
    text("PRESS SPACE TO PLAY AGAIN", width/2, height/2 + 75);
  }
  
  void nextScene() { ++sceneLocation; }
  int getScene() { return sceneLocation; }
  boolean goneThroughIntro() { return goneThroughIntro; }
  boolean isOnGameOverScreen() { return isOnGameOverScreen; }
};
