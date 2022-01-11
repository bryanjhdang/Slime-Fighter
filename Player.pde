class Player extends Character
{
  // fields
  ArrayList<Projectile> projectiles = new ArrayList<Projectile>();
  float projectileX;
  float projectileY;
  PVector projectileVel;
  float projectileAngle;
  float damp = 0.9;
  
  // player animation 
  float hatMoveDist;
  float hatMoveRate = 0.8;
  float legs1Angle;
  float legs1MoveRate = 0.01;
  float legs2Angle;
  float legs2MoveRate = 0.01;
  
  // invincible timer 
  float startInvincibleTimer;
  float currentInvincibleTimer;
  boolean canBeHit;
  
  // spell timer
  float startFireTimer;
  float currentFireTimer;
  boolean canFire;
  float timeTillNextFire = 0.4;
  
  // gets hit timer
  boolean onHit;
  float startHitTimer;
  float currentHitTimer;
  float timeTillFlashEnds = 0.05;
  
  // determine projectile
  boolean usingFire;
  boolean usingIce;
  boolean usingThunder;
  
  // buff
  // speed
  float startShieldTimer;
  float currentShieldTimer;
  float shieldDuration = 8;
  boolean shieldActive;
  boolean shieldHasBeenHit;
  
  // shield
  float startSpeedTimer;
  float currentSpeedTimer;
  float speedDuration = 5;
  boolean speedActive;
  float speedAngle = 0;
  float speedAngleInc = 0.2;

  // constructor
  Player(PVector pos, PVector vel, int health, int characterWidth, int characterHeight){
    super(pos, vel, health, characterWidth, characterHeight);
    startInvincibleTimer = (float)millis()/1000;
    currentInvincibleTimer = 0;  
    canBeHit = true;
    startFireTimer = (float)millis()/1000;
    currentFireTimer = 0;
    canFire = true;
    startHitTimer = (float)millis()/1000;
    currentHitTimer = 0;
    hatMoveDist = 0;
    legs1Angle = 0;
    legs2Angle = 0;
    
    usingFire = true;
    usingIce = false;
    usingThunder = false;
  }
  
  void fire(){
    if(canFire){
      if(usingFire){
        projectiles.add(new Projectile(new PVector(pos.x, pos.y), new PVector(projectileX, projectileY), projectileAngle, color(255, 0, 0), false));
      }
      if(usingIce){
        projectiles.add(new Projectile(new PVector(pos.x, pos.y), new PVector(projectileX * 0.5, projectileY * 0.5), projectileAngle, color(135,206,235), false));
      }
      if(usingThunder){
        projectiles.add(new Projectile(new PVector(pos.x, pos.y), new PVector(projectileX * 1.5, projectileY * 1.5), projectileAngle, color(224, 224, 0), true));
      }
      canFire = false;
    }
  }
  
  void updateFireAngle(float angle){
    projectileX = 15 * cos(angle);
    projectileY = 15 * sin(angle);
  }
  
  void checkProjectiles(){
    for(int i = 0; i < projectiles.size(); i++){
      Projectile p = projectiles.get(i);
      p.update();
       
      for(int j = 0; j < enemies.size(); j++){
        BasicEnemy e = enemies.get(j);
        if(!(e.isDying()) && p.hit(e)){
          if(usingFire) e.decreaseHealth(2);
          if(usingIce){
            e.decreaseHealth(3);
            e.startSlow();
          }
          if(usingThunder){
            e.decreaseHealth(1);
            e.startStun();
          }
        }
      }     
      if(!p.isActive) projectiles.remove(i);
    }
  }
  
  void moveCharacter(){
    pos.add(vel);
    vel.mult(damp);
  }
  
  void decreaseHealth(int damageTaken){
    if(canBeHit && !shieldActive){
      onHit = true;
      super.decreaseHealth(damageTaken);
      startInvincibleTimer = (float)millis()/1000;
      canBeHit = false;
    }
    if(shieldActive){
      shieldHasBeenHit = true;
    }
  }
  
  void update(){
    super.update();

    // fire projectile
    projectileVel = new PVector(mouseX - pos.x, mouseY - pos.y);
    projectileAngle  = projectileVel.heading();
    updateFireAngle(projectileAngle);
    checkProjectiles();
    
    // update health
    if(!canBeHit)                    currentInvincibleTimer = (float)millis()/1000 - startInvincibleTimer;
    if(currentInvincibleTimer >= 1)  canBeHit = true;
    
    // update fire timer
    if(canFire)   startFireTimer = (float)millis()/1000;
    if(!canFire)  currentFireTimer = (float)millis()/1000 - startFireTimer;
    if(currentFireTimer >= timeTillNextFire){
      currentFireTimer = 0;
      startFireTimer = (float)millis()/1000;
      canFire = true;
    }
    
    // draw hit flash animation
    if(!onHit)  startHitTimer = (float)millis()/1000;
    if(onHit) currentHitTimer = (float)millis()/1000 - startHitTimer;
    if(currentHitTimer >= timeTillFlashEnds)  onHit = false;
    
    // check for special item effects
    checkSpeed();
    checkShield();
  }
  
  void drawCharacter(){
    pushMatrix();
    translate(pos.x, pos.y);
    noStroke();
    
    // head
    fill(20);
    if(onHit) fill(255, 0, 0);
    ellipse(0, 0, 70, 45);
    // eyes
    fill(255, 255, 0);
    if(onHit) fill(255, 0, 0);
    if((up && left) || up || (up && right)){
      // don't draw
    } else if(left){
      ellipse(-23, 0, 7, 18);
      ellipse(3, 0, 7, 18);
    } else if (right) {
      ellipse(-3, 0, 7, 18);
      ellipse(23, 0, 7, 18);
    } else {
      ellipse(-15, 0, 7, 18);
      ellipse(15, 0, 7, 18);
    }
    
    // hat
    if(vel.x > 0.1 || vel.x < -0.1 || vel.y > 0.1 || vel.y < -0.1){
      if(hatMoveDist >= 4 || hatMoveDist <= -4) hatMoveRate *= -1;
      hatMoveDist += hatMoveRate;
    }
    if(vel.x < 0.8 && vel.x > -0.8 && vel.y < 0.8 && vel.y > -0.8){
      hatMoveDist = 0;
    }
    pushMatrix();
    translate(0, hatMoveDist);
    fill(72, 61, 139);
    if(onHit) fill(255, 0, 0);
    ellipse(0, -20, 90, 10);
    triangle(30, -20, -30, -20, 0, -50);
    popMatrix();
    
    // legs
    stroke(20);
    if(onHit) stroke(255, 0, 0);
    strokeWeight(3);
    // first leg (right side)
    pushMatrix();
    if(vel.x > 0.1 || vel.x < -0.1 || vel.y > 0.1 || vel.y < -0.1){
      if(legs1Angle >= radians(3) || legs1Angle <= radians(-3)) legs1MoveRate *= -1;
      legs1Angle -= legs1MoveRate;
    }
    if(vel.x < 0.8 && vel.x > -0.8 && vel.y < 0.8 && vel.y > -0.8){
      legs1Angle = 0;
    }
    rotate(legs2Angle);
    line(15, 40, 15, 58);
    line(15, 58, 23, 58);
    popMatrix();
    
    // second leg (left side)
    pushMatrix();
    if(vel.x > 0.1 || vel.x < -0.1 || vel.y > 0.1 || vel.y < -0.1){
      if(legs2Angle >= radians(3) || legs2Angle <= radians(-3)) legs2MoveRate *= -1;
      legs2Angle += legs2MoveRate;
    }
    if(vel.x < 0.8 && vel.x > -0.8 && vel.y < 0.8 && vel.y > -0.8){
      legs2Angle = 0;
    }
    rotate(legs2Angle);
    line(-15, 40, -15, 58);
    line(-15, 58, -23, 58);
    popMatrix();
    strokeWeight(1);
    noStroke();
    
    // robe
    // sides
    fill(72, 61, 139);
    if(onHit) fill(255, 0, 0);
    triangle(15, 20, 15, 40, 40, 30);
    triangle(-15, 20, -15, 40, -40, 30);
    // front
    fill(102, 91, 169);
    if(onHit) fill(255, 0, 0);
    quad(15, 20, 35, 50, -35, 50, -15, 20);
    
    popMatrix();
  }
  
  // ---------- special items -----------
  void checkSpeed(){    
    if(!speedActive) startSpeedTimer = (float)millis()/1000;   if(speedActive){
      currentSpeedTimer = (float)millis()/1000 - startSpeedTimer;
      // move faster
      upAcc = new PVector(0, -1.3);
      downAcc = new PVector(0, 1.3);
      leftAcc = new PVector(-1.3, 0);
      rightAcc = new PVector(1.3, 0);
      // make triangle appear and rotate
      pushMatrix();
      translate(pos.x, pos.y - characterHeight/2 - 20);
      scale(0.3);
      speedAngle += speedAngleInc;
      rotate(speedAngle);
      // triangle form
      fill(176, 224, 230);
      triangle(-50, 50, 50, 50, 0, -50);
      fill(146, 194, 200);
      triangle(0, 50, 50, 50, 25, 0);
      popMatrix();
    }
    if(currentSpeedTimer >= speedDuration){
      startSpeedTimer = (float)millis()/1000;
      currentSpeedTimer = 0;
      speedActive = false;
      upAcc = new PVector(0, -1);
      downAcc = new PVector(0, 1);
      leftAcc = new PVector(-1, 0);
      rightAcc = new PVector(1, 0);
      speedAngle = 0;
    }
  }
  
  void checkShield(){
    if(!shieldActive){
      startShieldTimer = (float)millis()/1000;
      shieldHasBeenHit = false;
    }
    if(shieldActive){
      currentShieldTimer = (float)millis()/1000 - startShieldTimer;
      // draw circle
      pushMatrix();
      translate(pos.x, pos.y+10);
      // orb
      fill(125, 158, 223, 125);
      ellipse(0, 0, characterWidth + 45, characterHeight + 40);
      popMatrix();
    }
    if(currentShieldTimer >= shieldDuration || shieldHasBeenHit){
      startShieldTimer = (float)millis()/1000;
      currentShieldTimer = 0;
      shieldActive = false;
    }
  }
  
  void setShield(){
    startShieldTimer = (float)millis()/1000;
    currentShieldTimer = 0;
    shieldActive = true; 
  }
  void setSpeed(){
    startSpeedTimer = (float)millis()/1000;
    currentSpeedTimer = 0;
    speedActive = true; 
  }
  
  // ----------- change projectiles ----------
  void changeToFire(){
    usingFire = true;
    usingIce = false;
    usingThunder = false;
  }
  
  void changeToIce(){
    usingFire = false;
    usingIce = true;
    usingThunder = false;
  }
  
  void changeToThunder(){
    usingFire = false;
    usingIce = false;
    usingThunder = true;
  }
  
  boolean getFire()    { return usingFire; }
  boolean getIce()     { return usingIce; }
  boolean getThunder() { return usingThunder; }
  void increaseHealth(int inc)   { health += inc; }
  void setHealth(int inc)        { health = inc; }
  void setCanFire(boolean start) { canFire = start; }
  float getHealth()              { return health; }
  float getCurrentFireTimer()    { return currentFireTimer; }
  boolean getCanBeHit()          { return canBeHit; }
};
