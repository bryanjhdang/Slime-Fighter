class BossEnemy extends BasicEnemy
{
  // fields
  ArrayList<Projectile> projectiles = new ArrayList<Projectile>();
  float projectileX;
  float projectileY;
  float projectileAngle;
  PVector projectileVel;
  float timeTillDeath = 3;
  boolean hasEnteredScreen;
  boolean canBeHit;
  
  boolean isFinalBoss;
  boolean finalBossTransformed;
  
  float trackingRange;
  float changeVel;
  float changeVelAngle;
  
  float yShrinkRate = 0.0055;
  
  float startFireTimer;
  float currentFireTimer;
  boolean canFire;
  float timeTillNextShot;
  
  boolean onHit;
  float startHitTimer;
  float currentHitTimer;
  float timeTillFlashEnds = 0.05;
  
  BossEnemy(PVector pos, PVector vel, float health, int characterWidth, int characterHeight, float trackingRange, float timeTillNextShot, boolean isFinalBoss){
    super(pos, vel, health, characterWidth, characterHeight);
    timeTillDeath = 3;
    
    // fire timer
    startFireTimer = (float)millis()/1000;
    currentDeathTimer = 0;
    canFire = false;
    
    // flash white on hit timer
    startHitTimer = (float)millis()/1000;
    currentHitTimer = 0;
    onHit = false;
    
    // check if enemy can be hit
    hasEnteredScreen = false;
    canBeHit = false;
    
    // track player
    this.trackingRange = trackingRange;
    changeVel = sqrt((vel.x*vel.x) + (vel.y*vel.y));
    
    this.timeTillNextShot = timeTillNextShot;
    this.isFinalBoss = isFinalBoss;
  }
  
  void fire(){
    projectiles.add(new Projectile(new PVector(pos.x, pos.y), new PVector(projectileX, projectileY), projectileAngle, color(60, 215, 60), false));
  }
  
  void updateFireAngle(float angle){
    projectileX = 8 * cos(angle);
    projectileY = 8 * sin(angle);
  }
  
  void checkProjectiles(){
    for(int i = 0; i < projectiles.size(); i++){
      Projectile p = projectiles.get(i);
      p.update();
       
      Player playerChar = player;
      if(p.hit(playerChar))  playerChar.decreaseHealth(1);
      if(!p.isActive) projectiles.remove(i);
    }
  }
  
  void decreaseHealth(int damageTaken){
    if(canBeHit){
      onHit = true;
      if(health > 0)  health -= damageTaken;
      if(health <= 0){
        vel.x = 0;
        vel.y = 0;
        dying = true;
      }
    }
  }
  
  void accelerateIfClose(Character p) {
    if(!isFinalBoss && abs(pos.x-p.pos.x)<(p.characterWidth/2)+trackingRange && abs(pos.y-p.pos.y)<(p.characterHeight/2)+trackingRange){
      findAccelerateAngle(changeVelAngle);
    }
  }

  void findAccelerateAngle(float angle) {
    if(!dying){
      vel.x = changeVel * cos(angle);
      vel.y = changeVel * sin(angle);
    }
  }
  
  void update(){
    super.moveCharacter();
    checkWalls();
    
    // check collision with player
    Player p = player;
    if(!dying && p.getCanBeHit() && abs(pos.x-p.pos.x)<(p.characterWidth/2)+characterWidth/2 && abs(pos.y-p.pos.y)<(p.characterHeight/2)+characterHeight/2){
      PVector enter = new PVector(p.pos.x - pos.x, p.pos.y - pos.y);
      float enterAngle = enter.heading();
      p.vel.x = cos(enterAngle)*15;
      p.vel.y = sin(enterAngle)*15;
      p.decreaseHealth(1);
    }
    
    // draw dying method
    if(!dying)  startDeathTimer = (float)millis()/1000;
    if(dying)   currentDeathTimer = (float)millis()/1000 - startDeathTimer;
    if(currentDeathTimer >= 3){
      enemies.remove(this);
      enemiesDead++;
      if(enemiesDead % SPAWN_ITEM == 0 && enemiesDead % SPAWN_WEAPON != 0) specialItems.add(new SpecialItems(new PVector(pos.x, pos.y), 1));
      if(enemiesDead % SPAWN_WEAPON == 0) specialItems.add(new SpecialItems(new PVector(pos.x, pos.y), 2));
      if(isFinalBoss) finalBossHasBeenKilled = true;
    }
    
    // fire projectile and CHECK PROJECTILES
    projectileVel = new PVector(p.pos.x - pos.x, p.pos.y - pos.y);
    projectileAngle  = projectileVel.heading();
    updateFireAngle(projectileAngle);
    if(!dying && canFire){
      fire();
      canFire = false;
      startFireTimer = (float)millis()/1000;
    }
    if(!canFire)  currentFireTimer = (float)millis()/1000 - startFireTimer;
    if(currentFireTimer > timeTillNextShot){
      canFire = true;
      currentFireTimer = 0;
      startFireTimer = (float)millis()/1000;
    }
    checkProjectiles();
    
    // draw hit flash animation
    if(!onHit)  startHitTimer = (float)millis()/1000;
    if(onHit) currentHitTimer = (float)millis()/1000 - startHitTimer;
    if(currentHitTimer >= timeTillFlashEnds)  onHit = false;
    
    // check if slime has entered the screen
    if(pos.y > characterHeight/2){
      hasEnteredScreen = true;
      canBeHit = true;
    }
    
    // change changeVel angle to track player
    PVector tempVec = new PVector(p.pos.x - pos.x, p.pos.y - pos.y);
    changeVelAngle = tempVec.heading();
    accelerateIfClose(p);
    
    // change boss variables
    updateFinalBoss();
    
    drawCharacter();
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
    ellipse(0, 0, 200, 155);  
    fill(40, 195, 40);
    ellipse(0, 55, 90, 30);
    
    // hurt flash
    fill(100, 255, 100);
    if(onHit) ellipse(0, 0, 200, 155);  
    
    // eyes
    fill(0);
    ellipse(30, -8, 10, 25);
    ellipse(-30, -8, 10, 25);
      
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
    xScale += xShrinkRate;

    // body
    fill(50, 205, 50, 245);
    ellipse(0, 0, 200, 155);  
    fill(40, 195, 40);
    ellipse(0, 55, 90, 30);
    
    // eyes
    fill(0);
    stroke(0);
    strokeWeight(4);
    // right
    line(35, 2, 25, -15);
    line(25, 2, 35, -15);
    // left
    line(-35, 2, -25, -15);
    line(-25, 2, -35, -15);
    noStroke();
      
    popMatrix();
  }
  
  void checkWalls(){
    if (pos.x - characterWidth/2 < WALL_THICKNESS)       vel.x *= -1;
    if (pos.x + characterWidth/2 > width - WALL_THICKNESS)   vel.x *= -1;
    if ((pos.y - characterHeight/2 < 0) && hasEnteredScreen)      vel.y *= -1;
    if (pos.y + characterHeight/2 > height - WALL_THICKNESS - 20) vel.y *= -1;
  }
  
  void updateFinalBoss(){
    if(isFinalBoss && !finalBossTransformed){
      canBeHit = false;
      if(pos.y >= height/2){
        while(vel.x > -8 && vel.x < 8) vel.x = random(-9, 9);
        while(vel.y > -8 && vel.y < 8) vel.y = random(-9, 9);
        timeTillNextShot = 0.3;
        finalBossTransformed = true;
        canBeHit = true;
      } 
    }
  }
};
