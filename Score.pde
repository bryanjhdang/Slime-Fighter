class Score
{
  PVector pos;
  int score;
  
  Score(PVector pos){
    this.pos = pos;
  }
  
  void drawScore(){
    textSize(50);
    textAlign(CENTER);
    fill(0);
    text(score, width-150, 120);
  }
  
  void updateScore(int inc){
    score += inc;
  }
  
  int getScore(){ return score; }
};
