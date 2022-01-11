class Projectile
{
  // fields
  PVector pos, vel;
  color projectileColor;
  float moveDist;
  float moveDist2;
  float moveDist3;
  float moveRate = 3;
  float moveRate2 = 3;
  float moveRate3 = 3;
  float angle;
  boolean isActive;
  float projectileWidth = 30;
  float projectileHeight = 30;
  boolean isThunder;

  float trackingRange = 100;
  float changeVel;
  float changeVelAngle;

  // constructor
  Projectile(PVector pos, PVector vel, float angle, color projectileColor, boolean isThunder){
    this.pos = pos;
    this.vel = vel;
    moveDist = 0;
    moveDist2 = 1.5;
    moveDist3 = 3;
    this.angle = angle;
    isActive = true;
    this.projectileColor = projectileColor;
    this.isThunder = isThunder;
    
    changeVel = sqrt((vel.x*vel.x) + (vel.y*vel.y));
  }
  
  // methods
  void move(){
    pos.add(vel);
  }
  
  void checkWalls(){
    if(abs(pos.x-projectileWidth/2)>width||abs(pos.y-projectileHeight/2)>height){
      isActive = false;
    } 
  }
  
  void homeThunder(Character e){
    // check range
    if(abs(pos.x-e.pos.x)<(e.characterWidth/2)+75 && abs(pos.y-e.pos.y)<(e.characterHeight/2)+75){
      findHomingAngle(changeVelAngle);
    }
  }

  void findHomingAngle(float angle) {
    vel.x = changeVel * cos(angle);
    vel.y = changeVel * sin(angle);
  }
  
  void update(){
    move();
    drawProjectile();
    checkWalls();
    
    // Check if thunder to add homing effect
    if(isThunder){
      for(int i = 0; i < enemies.size(); i++){
        BasicEnemy e = enemies.get(i);
        PVector tempVec = new PVector(e.pos.x - pos.x, e.pos.y - pos.y);
        changeVelAngle = tempVec.heading();
        if(!e.isDying()){
          homeThunder(e);
        }
      }
    }
  }
  
  void drawProjectile(){
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(angle + radians(90));
    noStroke();
    
    // outer circle flames
    fill(projectileColor);
    ellipse(0, 0, 30, 30);
    
    // animate the flames
    if(moveDist >= 7 || moveDist <= -7) moveRate *= -1;
    moveDist += moveRate;
    if(moveDist2 >= 7 || moveDist2 <= -7) moveRate2 *= -1;
    moveDist2 += moveRate2;
    if(moveDist3 >= 7 || moveDist3 <= -7) moveRate3 *= -1;
    moveDist3 += moveRate3;
    
    // draw the flames
    if(!isThunder){
      pushMatrix();
      translate(0, moveDist);
      triangle(-15, 0, -2, 0, -10, 28);
      popMatrix();
      
      pushMatrix();
      translate(0, moveDist2);
      triangle(-10, 0, 10, 0, 0, 37);
      popMatrix();
      
      pushMatrix();
      translate(0, moveDist3);
      triangle(2, 0, 15, 0, 10, 28);
      popMatrix();
    }
    
     
     // inner circle
    fill(255, 100);
    ellipse(0, 0, 15, 15);
    
    popMatrix();
  }
  
  boolean hit(Character c){
    if(abs(pos.x-c.pos.x)<c.characterWidth/2 && abs(pos.y-c.pos.y)<c.characterHeight/2){
      isActive = false;
      return true;
    }
    return false;
  }
};
