class StatusBars
{
  PVector pos;
  float health;
  float increaseHealthSize = 40;
  
  float cooldown;
  float increaseCDSize = 300;
  boolean onCooldown;
  int yOffsetCD = 30;
  
  int progress;
  float PROGRESS_SIZE = 90;
  float MAX_SIZE = 450;
  
  // change increaseHealthSize and increaseCDSize to be dependent on max instead of manually changing it
  
  StatusBars(PVector pos){
    // pass in the health, mana and cooldown at max on creation 
    this.pos = pos;
  }
  
  void updateHealth(float playerHealth){
    health = playerHealth;
  }
  
  void updateCooldown(float fireTimer){
    cooldown = fireTimer;
    if(cooldown == 0)    onCooldown = false;
    if(cooldown >= 0.01) onCooldown = true;
  }
  
  void updateProgress(int score){
    progress = score;
  }
  
  void drawAll(){
    drawHealthBar();
    drawCooldownBar();
  }
  
  void drawHealthBar(){
    fill(0);
    rect(pos.x, pos.y, 200, 30);
    fill(233, 60, 60);
    rect(pos.x, pos.y, health * increaseHealthSize, 30);
  }
  
  void drawCooldownBar(){    
    fill(0);
    rect(pos.x, pos.y + yOffsetCD + 6, 150, 10);
    if(!onCooldown){
      fill(30, 144, 255);
      rect(pos.x, pos.y + yOffsetCD + 6, 150, 10);
    }
    fill(30, 144, 255);
    rect(pos.x, pos.y + yOffsetCD + 6, cooldown * (150/0.4), 10);
  }
  
  void drawProgressBar(){
    pushMatrix();
    translate(width/2 - MAX_SIZE/2, pos.y);

    // bar
    fill(70);
    rect(0, 0, PROGRESS_SIZE*5, 30);
    fill(80, 235, 80);
    rect(0, 0, progress * (MAX_SIZE/ALL_ENEMIES), 30);
    stroke(0);
    
    // line
    stroke(40);
    strokeWeight(2);
    line((MAX_SIZE/ALL_ENEMIES) * CHECK_ONE_TO_TWO, -5, (MAX_SIZE/ALL_ENEMIES) * CHECK_ONE_TO_TWO, 35);
    line((MAX_SIZE/ALL_ENEMIES) * CHECK_TWO_TO_THREE, -5, (MAX_SIZE/ALL_ENEMIES) * CHECK_TWO_TO_THREE, 35);
    line((MAX_SIZE/ALL_ENEMIES) * CHECK_THREE_TO_FOUR, -5, (MAX_SIZE/ALL_ENEMIES) * CHECK_THREE_TO_FOUR, 35);
    noStroke();
    
    popMatrix();
  }
};
