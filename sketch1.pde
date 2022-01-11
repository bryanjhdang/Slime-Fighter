Player player;
Score score;
StatusBars statusBars;
Cutscenes scenes;
ArrayList<BasicEnemy> enemies = new ArrayList<BasicEnemy>();
ArrayList<SpecialItems> specialItems = new ArrayList<SpecialItems>();

float startResetTimer;
float currentResetTimer;
float timeTillReset = 0.05;
boolean canReset = true;
float enemyWidth = 80;
float enemyHeight = 55;
float randomSpeedX;
boolean bossCanSpawn;
int enemiesCounter;
int enemiesDead;

int WALL_THICKNESS = 25;
int MAX_ENEMIES = 8;
int SPAWN_ITEM = 3;
int SPAWN_WEAPON = 5;
boolean goneThroughIntro = false;

// variables for different waves
float TIME_TILL_NEXT_WAVE = 5;
int ENEMIES_IN_WAVE_ONE = 15;
int ENEMIES_IN_WAVE_TWO = 20;
int ENEMIES_IN_WAVE_THREE = 20;
int ENEMIES_IN_WAVE_FOUR = 25;
int ALL_ENEMIES = ENEMIES_IN_WAVE_ONE + ENEMIES_IN_WAVE_TWO + ENEMIES_IN_WAVE_THREE + ENEMIES_IN_WAVE_FOUR;
int CHECK_ONE_TO_TWO = ENEMIES_IN_WAVE_ONE;
int CHECK_TWO_TO_THREE = ENEMIES_IN_WAVE_ONE + ENEMIES_IN_WAVE_TWO;
int CHECK_THREE_TO_FOUR = ENEMIES_IN_WAVE_ONE + ENEMIES_IN_WAVE_TWO + ENEMIES_IN_WAVE_THREE;
boolean transitionTime;
float startWaveTimer;
float currentWaveTimer;
boolean waveOneActive;
boolean waveTwoActive;
boolean waveThreeActive;
boolean waveFourActive;
boolean finalBossActive;
boolean finalBossHasBeenKilled;
boolean finalBossHasBeenSpawned;

void setup(){
  size(1300, 900);
  
  player = new Player(new PVector(width/2, height/2), new PVector(), 5, 70, 100);
  score =  new Score(new PVector(0, 0));
  statusBars = new StatusBars(new PVector(70, 65));
  scenes = new Cutscenes();
  bossCanSpawn = false;
  enemiesCounter = 0;
  enemiesDead = 0;
  
  waveOneActive = true;
  waveTwoActive = false;
  waveThreeActive = false;
  waveFourActive = false;

  currentWaveTimer = 0;
  transitionTime = false;
  
  finalBossHasBeenKilled = false;
  finalBossHasBeenSpawned = false;
}

void draw(){
  background(190, 156, 99);
  
  // draw walls
  fill(170, 126, 69);
  rect(0, 0, WALL_THICKNESS, height);
  rect(width - WALL_THICKNESS, 0, WALL_THICKNESS, height);
  rect(0, height - WALL_THICKNESS, width, WALL_THICKNESS);
  
  scenes.drawIntroScenes();
  if(!scenes.goneThroughIntro){
     player.setCanFire(false);
  }
  
  if(scenes.goneThroughIntro){
    for(int i = 0; i < enemies.size(); i++){
      BasicEnemy e = enemies.get(i);
      e.update();
      if(enemiesCounter == CHECK_ONE_TO_TWO-1 || enemiesCounter == CHECK_TWO_TO_THREE-1 || enemiesCounter == CHECK_THREE_TO_FOUR-1 || enemiesCounter == CHECK_THREE_TO_FOUR+ENEMIES_IN_WAVE_FOUR-1){ 
        bossCanSpawn = true;
      }
      if(e.isDying() && e.canUpdateScore()){
        e.updateScoreOnDeath();
        score.updateScore(1);
      }
    }
    
    for(int i = 0; i < specialItems.size(); i++){
      SpecialItems s = specialItems.get(i);
      s.update();
    }

    // different waves
    if(!transitionTime){
      if(waveOneActive)    waveOne();
      if(waveTwoActive)    waveTwo();
      if(waveThreeActive)  waveThree();
      if(waveFourActive)   waveFour();
      if(finalBossActive)  finalBoss(); 
    }
    checkWave();
    
    // everything to do with player movement
    player.update();
    if (up) player.accelerate(upAcc);
    if (left) player.accelerate(leftAcc);
    if (right) player.accelerate(rightAcc);
    if (down) player.accelerate(downAcc);
    
    // update player status
    statusBars.updateHealth(player.getHealth());
    statusBars.updateCooldown(player.getCurrentFireTimer());
    statusBars.updateProgress(score.getScore());
    
    // draw ui elements
    score.drawScore();
    statusBars.drawAll();
    if(!finalBossActive){
      statusBars.drawProgressBar();
    }
    
    // draw game over screen if died
    if(player.getHealth() <= 0){
      player.setHealth(-1); 
      scenes.drawGameOverScreen();
    }
    
    // draw win screen
    if(finalBossHasBeenKilled){
      scenes.drawEndScreen();
    }
  
    checkReset();
  } 
}

void checkReset(){
  // reset game
  if(!reset) startResetTimer = (float)millis()/1000;
  if(reset){
    for(int i = 0; i < specialItems.size(); i++) { specialItems.remove(i); }
    for(int i = 0; i < enemies.size(); i++) { enemies.remove(i); }
    currentResetTimer = (float)millis()/1000 - startResetTimer;
    
    if(currentResetTimer >= timeTillReset){
      reset = false;
      currentResetTimer = 0;
      startResetTimer = (float)millis()/1000;
      setup();
    }
  }
}

// --------- WAVE LOGIC STARTS HERE ----------

void checkWave(){
  if(score.getScore() == CHECK_ONE_TO_TWO && !waveTwoActive){
    transitionTime = true;
    waveOneActive = false;
    waveTwoActive = true;
  }
  
  if(score.getScore() == CHECK_TWO_TO_THREE && !waveThreeActive){
    transitionTime = true;
    waveTwoActive = false;
    waveThreeActive = true;
  }
  
  if(score.getScore() == CHECK_THREE_TO_FOUR && !waveFourActive){
    transitionTime = true;
    waveThreeActive = false;
    waveFourActive = true;
  }
  
  if(score.getScore() == ALL_ENEMIES && !finalBossActive){
    transitionTime = true;
    waveFourActive = false;
    finalBossActive = true;
  }
  
  if(!transitionTime)  startWaveTimer = (float)millis()/1000;
  if(transitionTime)   currentWaveTimer = (float)millis()/1000 - startWaveTimer;
  if(currentWaveTimer >= TIME_TILL_NEXT_WAVE){
    // heal player if approaching final boss
    if(score.getScore() == ALL_ENEMIES){
      player.setHealth(5);
    }
    startWaveTimer = (float)millis()/1000;
    currentWaveTimer = 0;
    transitionTime = false;
  }
}

void waveOne(){
  if(enemiesCounter < CHECK_ONE_TO_TWO){
    if(enemies.size() < MAX_ENEMIES){ 
      randomSpeedX = 0;
      while(randomSpeedX == 0) randomSpeedX = random(-4,4);
        if(bossCanSpawn){
          enemies.add(new BossEnemy(new PVector(width/2, -200), new PVector(2.5, 2.5), 16, 180, 100, 0, 1, false));
          ++enemiesCounter;
          bossCanSpawn = false;
        } else {
          enemies.add(new BasicEnemy(new PVector(random(enemyWidth/2 + WALL_THICKNESS, width-enemyWidth/2-WALL_THICKNESS), -100), 
                               new PVector(randomSpeedX, random(2,4)), (int)random(4,6), 80, 55));
          ++enemiesCounter;
        }
     }
  }
}

void waveTwo(){
  if(enemiesCounter < CHECK_TWO_TO_THREE){
      if(enemies.size() < MAX_ENEMIES){ 
        randomSpeedX = 0;
        while(randomSpeedX > -3 && randomSpeedX < 3) randomSpeedX = random(-4,4);
          if(bossCanSpawn){
            enemies.add(new BossEnemy(new PVector(width/2, -200), new PVector(2.5, 2.5), 16, 180, 100, 200, 0.8, false));
            ++enemiesCounter;
            bossCanSpawn = false;
          } else {
            enemies.add(new BasicEnemy(new PVector(random(enemyWidth/2 + WALL_THICKNESS, width-enemyWidth/2-WALL_THICKNESS), -100), 
                                 new PVector(randomSpeedX, random(3,5)), (int)random(4,6), 80, 55));
            ++enemiesCounter;
          }
       }
    }
}

void waveThree(){
  if(enemiesCounter < CHECK_THREE_TO_FOUR){
      if(enemies.size() < MAX_ENEMIES){ 
        randomSpeedX = 0;
        while(randomSpeedX > -3 && randomSpeedX < 3) randomSpeedX = random(-5,5);
          if(bossCanSpawn){
            enemies.add(new BossEnemy(new PVector(width/2, -200), new PVector(3, 3), 16, 180, 100, 300, 0.7, false));
            ++enemiesCounter;
            bossCanSpawn = false;
          } else {
            enemies.add(new BasicEnemy(new PVector(random(enemyWidth/2 + WALL_THICKNESS, width-enemyWidth/2-WALL_THICKNESS), -100), 
                                 new PVector(randomSpeedX, random(4,6)), (int)random(4,6), 80, 55));
            ++enemiesCounter;
          }
       }
    }
}

void waveFour(){
  if(enemiesCounter < CHECK_THREE_TO_FOUR + ENEMIES_IN_WAVE_FOUR){
      if(enemies.size() < MAX_ENEMIES){ 
        randomSpeedX = 0;
        while(randomSpeedX > -4 && randomSpeedX < 4) randomSpeedX = random(-5,5);
          if(bossCanSpawn){
            enemies.add(new BossEnemy(new PVector(width/2, -200), new PVector(3, 3), 16, 180, 100, 350, 0.65, false));
            ++enemiesCounter;
            bossCanSpawn = false;
          } else {
            enemies.add(new BasicEnemy(new PVector(random(enemyWidth/2 + WALL_THICKNESS, width-enemyWidth/2-WALL_THICKNESS), -100), 
                                 new PVector(randomSpeedX, random(5,7)), (int)random(4,6), 80, 55));
            ++enemiesCounter;
          }
       }
    }
}

void finalBoss(){
  if(!finalBossHasBeenSpawned){
    enemies.add(new BossEnemy(new PVector(width/2, -200), new PVector(0, 1), 50, 180, 100, 0, 500, true));
    finalBossHasBeenSpawned = true;
  }
}
