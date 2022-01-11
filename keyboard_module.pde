PVector upAcc = new PVector(0, -1);
PVector downAcc = new PVector(0, 1);
PVector leftAcc = new PVector(-1, 0);
PVector rightAcc = new PVector(1, 0);

boolean up, down, left, right;

boolean reset;

void keyPressed(){
  if(keyCode=='A' || keyCode=='a') left = true;
  if(keyCode=='W' || keyCode=='w') up = true;
  if(keyCode=='S' || keyCode=='s') down = true;
  if(keyCode=='D' || keyCode=='d') right = true;
}

void keyReleased(){
  if(keyCode=='A' || keyCode=='a') left = false;
  if(keyCode=='W' || keyCode=='w') up = false;
  if(keyCode=='S' || keyCode=='s') down = false;
  if(keyCode=='D' || keyCode=='d') right = false;
  
  if(keyCode=='M' || keyCode=='m') enemies.add(new BasicEnemy(new PVector(200, 200), new PVector(0, 0), (int)random(2,4), 80, 55));
  
  if((keyCode==' ') && canReset){
    if(scenes.getScene() == 4) canReset = false;
    if(!scenes.goneThroughIntro())   scenes.nextScene();
  }
  
  // use this for reset
  if((keyCode==' ') && scenes.isOnGameOverScreen()){
    reset = true;
    canReset = true;
  }
}

void mouseReleased(){
  player.fire(); 
}
