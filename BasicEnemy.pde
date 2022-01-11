class BasicEnemy extends Character
{
  // characterWidth = 80 and characterHeight = 55
  float yScale;
  float xScale;
  float yScaleRate;
  float xScaleRate;
  float yShrinkRate;
  float xShrinkRate;
  float widthOffset = 20;
  float heightOffset = 15;

  boolean dying;
  float startDeathTimer;
  float currentDeathTimer;
  float timeTillDeath = 1;
  
  boolean onHit;
  float startHitTimer;
  float currentHitTimer;
  float timeTillFlashEnds = 0.05;
  
  boolean canUpdateScore;
  boolean hasEnteredScreen; 
  boolean canBeHit;
  boolean canSpawnItem;
  
  // ice slow effect
  float xVelTempSlow;
  float yVelTempSlow;
  float startSlowTimer;
  float currentSlowTimer;
  float slowDuration = 1.5;
  boolean isSlowed;
  boolean changedSlowVel;
  // thunder stun effect
  float xVelTempStun;
  float yVelTempStun;
  float startStunTimer;
  float currentStunTimer;
  float stunDuration = 0.25;
  boolean isStunned;
  
  BasicEnemy(PVector pos, PVector vel, float health, int characterWidth, int characterHeight){
    super(pos, vel, health, characterWidth, characterHeight);
    
    // animation
    xScale = 1;
    yScale = 1;
    yScaleRate = 0.003;
    xScaleRate = 0.003;
    yShrinkRate = 0.016;
    xShrinkRate = 0.003;
    dying = false;
    
    // timer for death animation
    startDeathTimer = (float)millis()/1000;
    currentDeathTimer = 0;
    
    // flash white on hit timer
    startHitTimer = (float)millis()/1000;
    currentHitTimer = 0;
    canUpdateScore = true;
    
    // check if enemy can be hit
    hasEnteredScreen = false;
    canBeHit = false;
    
    // checks status of the slime and if it can spawn an item
    canSpawnItem = false;
    isSlowed = false;
    isStunned = false;
  }
  
  void decreaseHealth(int damageTaken){
    if(canBeHit){
      onHit = true;
      super.decreaseHealth(damageTaken);
      if(health <= 0){
        vel.x = 0;
        vel.y = 0;
        dying = true;
      }
    }
  }
  
  void update(){
    super.update();
    
    // check collision with player 
    Player p = player;
    if(!dying && p.getCanBeHit() && abs(pos.x-p.pos.x)<(p.characterWidth/2)+(characterWidth/2-widthOffset) && abs(pos.y-p.pos.y)<(p.characterHeight/2)+(characterHeight/2-heightOffset)){
      PVector enter = new PVector(p.pos.x - pos.x, p.pos.y - pos.y);
      float enterAngle = enter.heading();
      p.vel.x = cos(enterAngle)*15;
      p.vel.y = sin(enterAngle)*15;
      p.decreaseHealth(1);
    }
    
    // check stun and slow effects
    checkStun();
    checkSlow();
    
    // draw dying animation
    if(!dying)  startDeathTimer = (float)millis()/1000;
    if(dying){
      vel.x = 0;
      vel.y = 0;
      currentDeathTimer = (float)millis()/1000 - startDeathTimer;
    }
    if(currentDeathTimer >= timeTillDeath){
      enemies.remove(this);
      enemiesDead++;
      if(enemiesDead % SPAWN_ITEM == 0 && enemiesDead % SPAWN_WEAPON != 0) specialItems.add(new SpecialItems(new PVector(pos.x, pos.y), 1));
      if(enemiesDead % SPAWN_WEAPON == 0) specialItems.add(new SpecialItems(new PVector(pos.x, pos.y), 2));
    }
    
    // draw hit flash animation
    if(!onHit)  startHitTimer = (float)millis()/1000;
    if(onHit) currentHitTimer = (float)millis()/1000 - startHitTimer;
    if(currentHitTimer >= timeTillFlashEnds)  onHit = false;
    
    // check if slime has entered the screen
    if(pos.y > characterHeight/2){
      hasEnteredScreen = true; 
      canBeHit = true;
    }
  }
    
  void drawCharacter(){
    if(!dying){
    pushMatrix();
    translate(pos.x, pos.y);
    noStroke();
    
    // animate slime
    scale(xScale, yScale);
    if(yScale >= 1 || yScale <= 0.95)  yScaleRate *= -1;
    yScale += yScaleRate;
    if(xScale > 1.05 || xScale < 1)  xScaleRate *= -1;
    xScale += xScaleRate;

    // body
    fill(50, 205, 50, 245);
    ellipse(0, 0, 80, 55);  
    fill(40, 195, 40);
    ellipse(0, 16, 47, 13);
    
    // hurt flash
    fill(100, 255, 100);
    if(onHit) ellipse(0, 0, 80, 55);  
    
    // eyes
    fill(0);
    ellipse(15, -6, 6, 13);
    ellipse(-15, -6, 6, 13);
      
    popMatrix();
    } else {
      drawDyingCharacter();
    }
  }
  
  void drawDyingCharacter(){
    pushMatrix();
    translate(pos.x, pos.y);
    noStroke();
    
    // animate dying slime
    scale(xScale, yScale);
    if(yScale > 0 && !(yScale < 0))  yScale -= yShrinkRate;
    if(yScale < 0){
      yScale = 0.001;
      xShrinkRate = 0;
    }
    if(xScale < 1.1)  xScale += xShrinkRate;

    // body
    fill(50, 205, 50, 245);
    ellipse(0, 0, 80, 55);  
    fill(40, 195, 40);
    ellipse(0, 16, 47, 13);
    
    // eyes
    fill(0);
    stroke(0);
    strokeWeight(3);
    line(12, 0, 18, -10);
    line(18, 0, 12, -10);
    line(-12, 0, -18, -10);
    line(-18, 0, -12, -10);
    noStroke();
      
    popMatrix();
  }
  
  void checkWalls(){
    if (pos.x - characterWidth/2 < WALL_THICKNESS)             vel.x *= -1;
    if (pos.x + characterWidth/2 > width - WALL_THICKNESS)     vel.x *= -1;
    if ((pos.y - characterHeight/2 < 0) && hasEnteredScreen)   vel.y *= -1;
    if (pos.y + characterHeight/2 > height - WALL_THICKNESS)   vel.y *= -1;
  }
  
  void startSlow(){ isSlowed = true; }
  void checkSlow(){
    if(!isSlowed){
      xVelTempSlow = vel.x;
      yVelTempSlow = vel.y;
      startSlowTimer = (float)millis()/1000;
      changedSlowVel = false;
    }
    if(!dying && isSlowed){
      currentSlowTimer = (float)millis()/1000 - startSlowTimer;
      if(!changedSlowVel){
        vel.x *= 0.5;
        vel.y *= 0.5;
        changedSlowVel = true;
      }
    }
    if(!dying && currentSlowTimer >= slowDuration){
      startSlowTimer = (float)millis()/1000;
      currentSlowTimer = 0;
      vel.x = xVelTempSlow;
      vel.y = yVelTempSlow;
      isSlowed = false;
    }
  }
  
  void startStun(){ isStunned = true; }
  void checkStun(){
    if(!isStunned){
      xVelTempStun = vel.x;
      yVelTempStun = vel.y;
      startStunTimer = (float)millis()/1000;
 
    }
    if(isStunned){
      currentStunTimer = (float)millis()/1000 - startStunTimer;
      vel.x = 0;
      vel.y = 0;
    }
    if(currentStunTimer >= stunDuration){
      startStunTimer = (float)millis()/1000;
      currentStunTimer = 0;
      vel.x = xVelTempStun;
      vel.y = yVelTempStun;
      isStunned = false;
    }
  }
  
  boolean isDying() { return dying; } 
  boolean canUpdateScore() { return canUpdateScore; }
  void updateScoreOnDeath() { canUpdateScore = false; }
};
