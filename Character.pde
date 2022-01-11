class Character
{
  // fields
  PVector pos;
  PVector vel;
  float health;
  int characterWidth;
  int characterHeight;
  
  // constructor
  Character(PVector pos, PVector vel, float health, int characterWidth, int characterHeight){
    this.pos = pos;
    this.vel = vel;
    this.health = health;
    this.characterWidth = characterWidth;
    this.characterHeight = characterHeight;
  }
  
  // methods
  void moveCharacter(){
    pos.add(vel);
  }
  
  void accelerate(PVector acc){
     vel.add(acc);
  }
  
  void drawCharacter(){
    pushMatrix();
    translate(pos.x, pos.y);
    rect(-20, -20, 40, 40);
    popMatrix();
  }
  
  boolean hitCharacter(Character c){
    boolean hasCollided = false;
    if(abs(pos.x-c.pos.x)<pos.x/2+c.characterWidth/2 && abs(pos.y-c.pos.y)<pos.y/2+c.characterHeight/2){
      hasCollided = true;
    } 
    return hasCollided;   
  }
  
  void decreaseHealth(int damageTaken){
    if(health > 0){
      health -= damageTaken;
    }
  }
  
  void checkWalls(){
    if (pos.x - characterWidth/2 < WALL_THICKNESS)           pos.x = characterWidth/2 + WALL_THICKNESS;
    if (pos.x + characterWidth/2 > width - WALL_THICKNESS)   pos.x = width - characterWidth/2 - WALL_THICKNESS;
    if (pos.y - characterHeight/2 < 0)                       pos.y = characterHeight/2;
    if (pos.y + characterHeight/2 > height - WALL_THICKNESS) pos.y = height - characterHeight/2 - WALL_THICKNESS;
  }
  
  void update(){
    moveCharacter();
    checkWalls();
    drawCharacter();
  }
};
