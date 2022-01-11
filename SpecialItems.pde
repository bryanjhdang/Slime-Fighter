class SpecialItems
{
  // fields
  PVector pos;
  
  float startAppearTimer;
  float currentAppearTimer;
  float appearDuration = 5;
  
  boolean isHealthPack = false;
  boolean isShield = false;
  boolean isSpeed = false;
  boolean isThunder = false;
  boolean isIce = false;
  boolean isFire = false;
  
  SpecialItems(PVector pos, int checkItemOrWeapon){
    this.pos = pos;
    //int temp = (int)random(1, 7);
    
    // timer
    startAppearTimer = (float)millis()/1000;
    currentAppearTimer = 0;
     
    // randomize spawn
    Player p = player;
    if(checkItemOrWeapon == 1){
      // spawn special item
      int temp = (int) random(2,5);
      while((temp == 2) && p.getHealth() == 5) temp = (int)random(2,5);
      if(p.getHealth() < 4) temp = (int)random(1,5);
  
      if(temp == 1 || temp == 2) isHealthPack = true;
      if(temp == 3) isShield = true;
      if(temp == 4) isSpeed = true; 
    }
    
    if(checkItemOrWeapon == 2){
      // spawn weapon
      int temp = (int)random(1,4);
      while(temp == 1 && p.getFire())     temp = (int)random(1,4);
      while(temp == 2 && p.getIce())      temp = (int)random(1,4);
      while(temp == 3 && p.getThunder())  temp = (int)random(1,4);
      
      if(temp == 1) isFire = true;
      if(temp == 2) isIce = true;
      if(temp == 3) isThunder = true;
    }
  }

  void update(){
    checkCollision();
    
    // countdown timer until disappear
    currentAppearTimer = (float)millis()/1000 - startAppearTimer;
    if(currentAppearTimer >= appearDuration)  specialItems.remove(this);
    
    // check which one to draw
    if(isHealthPack)  drawHealthPack();
    if(isShield)      drawShield();
    if(isSpeed)       drawSpeedBoost();
    if(isFire)        drawFire();
    if(isIce)         drawIce();
    if(isThunder)     drawThunder();
  }
  
  void checkCollision(){
    Player p = player;
    if(abs(pos.x-p.pos.x)<(p.characterWidth/2)+25 && abs(pos.y-p.pos.y)<(p.characterHeight/2)+25){
      
      // check which effect to give
      if(isHealthPack)  healthPackEffect();
      if(isShield)      p.setShield();     
      if(isSpeed)       p.setSpeed(); 
      if(isFire)        p.changeToFire();
      if(isIce)         p.changeToIce();    
      if(isThunder)     p.changeToThunder();               
    
      specialItems.remove(this);
    } 
  }
  
  void drawHealthPack(){
    pushMatrix();
    translate(pos.x, pos.y);
    scale(0.5);
    
    // health pack
    fill(255);
    rect(-50,-50, 100, 100);
    fill(255, 0, 0);
    rect(-10, -25, 20, 50);
    rect(-25, -10, 50, 20);
    
    popMatrix();
  }
  
  void drawShield(){
    pushMatrix();
    translate(pos.x, pos.y);
    scale(0.5);
    
    // orb
    fill(125, 158, 223, 200);
    ellipse(0, 0, 100, 100);
    
    // line
    fill(197, 214, 248, 200);
    pushMatrix();
    rotate(radians(30));
    translate(-15, -30);
    rect(0, 0, 40, 8);
    popMatrix();
    
    popMatrix();
  }
    
  void drawSpeedBoost(){
    pushMatrix();
    translate(pos.x, pos.y);
    scale(0.5);
    
    // lines
    fill(126, 174, 180);
    rect(0, 15, 60, 6);
    rect(0, 30, 70, 6);
    
    // triangle form
    fill(176, 224, 230);
    triangle(-50, 50, 50, 50, 0, -50);
    fill(146, 194, 200);
    triangle(0, 50, 50, 50, 25, 0);
    
    popMatrix();
  }
  
  void drawFire(){
    pushMatrix();
    translate(pos.x, pos.y);
    scale(0.5);
    
    // outer circle
    fill(255, 0, 0);
    ellipse(0, 0, 100, 100);
    
    // inner circle
    fill(255, 100);
    ellipse(0, 0, 50, 50);
    
    popMatrix();
  }
  
  void drawIce(){
    pushMatrix();
    translate(pos.x, pos.y);
    scale(0.5);
    
    // outer circle
    fill(135,206,235);
    ellipse(0, 0, 100, 100);
    
    // inner circle
    fill(255, 100);
    ellipse(0, 0, 50, 50);
    
    popMatrix();
  }
  
  void drawThunder(){
    pushMatrix();
    translate(pos.x, pos.y);
    scale(0.5);
    
    // outer circle
    fill(224, 224, 0);
    ellipse(0, 0, 100, 100);
    
    // inner circle
    fill(255, 100);
    ellipse(0, 0, 50, 50);
    
    popMatrix();
  }
  
  void healthPackEffect(){
    Player p = player;
    if(p.getHealth() < 5){
      p.increaseHealth(1);
    }
  }
};
