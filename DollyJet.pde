import processing.sound.*;
SoundFile sHit, sIntro, sGover, sPwUp, sGame, sAlarm, sBomb, sNewFase;

int blSz = 100, szJet = 25, szBmb = 50, tInit = 5, velInit = 15, stage = 20, blNumInit = 4;
int blMax, velEny, tam, pts, top, y, timeNprts, nBomb, tAlert;
int playSom = 1, tBomb, bombX, bombY, bAlert,vidax,vidaY,nShotBoms;
float cx;
boolean start, gMenu, newBlk, blink = false, newFase;
boolean u, d, l, r, hitTest, shotBomb = false, hBomb;
PImage[] iStage = new PImage[stage];
Jet[] jet;
Jet jetVida = new Jet(-100,30,20,20,0);
Block[] bl;
Block[] bomb;


void setup() {

  size(800, 560);
  height = 500;
  frameRate(100);
  sBomb    = new SoundFile(this, "bomb.wav");
  sHit     = new SoundFile(this, "hit.wav");
  sIntro   = new SoundFile(this, "intro.wav");
  sGover   = new SoundFile(this, "gover.wav");
  sPwUp    = new SoundFile(this, "pwup.wav");
  sGame    = new SoundFile(this, "game.wav");
  sAlarm   = new SoundFile(this, "alarm.wav");
  sNewFase = new SoundFile(this, "newFase.wav");
  for (int i = 0; i < stage; i++) {
    iStage[i] = loadImage("img/"+i+".png");
  }
}

void draw() {
  if (start && gMenu)
    game();
  else
    menu();

  //Painel e Pontos
  fill(#00CC66);
  if (bAlert == 1 && start) fill(255);
  rect(0, 500, width, 60);
  fill(255);
  textSize(30);
  textAlign(LEFT);
  text("PONTOS "    + pts, 10, 540);
  text("RECORDE " + top, 240, 540);
  if(stage < 20)
  text("FASE " + stage, 540, 540);
  //Sons
  if (playSom > 0) {
    sIntro.stop();
    sGover.stop();
    sHit.stop();
    sPwUp.stop();
  }
  if (playSom == 1) {
    sIntro.play();
  } else if (playSom == 2) {
    sGame.loop();
    delay(2500);
  } else if (playSom == 3) {
    sGover.play();
    sGame.stop();
    sAlarm.stop();
  } else if (playSom == 4) sHit.play();
    else if (playSom == 5) sPwUp.play();
             playSom =  0;
}

void menu() {
  gMenu = false;
  background(46, 163, 97);
  textSize(80);
  textAlign(CENTER, CENTER);
  fill(255);
  text("DollyJet", width/2, height/3);
  textSize(20);
  text("Aperte 'A' para iniciar", width/2, height/1.5);
  text("Setas controlam o jato", width/2, height/1.4);
  text("Colete pontos e NÃO MORRA", width/2, height/1.3);
  textSize(12);
  text("Criado por Mateus Segur R.A 001202004973", width/2, height/1.1);

  if (start) {
    y = 240;
    tam = tInit;
    blMax = blNumInit;
    pts = 0;
    piece(0);
    nBomb = 5;
    bAlert = 0;
    newBomb();
    geraBlock(0);
    gMenu = true;
    velEny = velInit;
    stage = 1;
    cx = 0;
  }
}

void game() {
  
  if (tam < tInit) {
    bAlert = int(blinkAlert());
    jet[0].c = bAlert;
  }else bAlert = 0;
  if (hitTest) velEny = 3;
  else velEny = velInit;
  hitTest = false;
  control();

  int hit = -1;
  background(#A09090);
  copy(iStage[stage], 0, 0, iStage[stage].width, iStage[stage].height, int(cx), 0, width*2, height);
  cx-= 0.5;
  if (cx < -(width)) {
    cx = 0;
    stage++;
    newFase = true;
  }
   //Numero de bombas
  for(int i = 0; i < tam/(20+tInit); i++){
    jetVida.x = 80+ i * 30;
    jetVida.show();
  }
  for (int i = 0; i < blMax; i++) {
    //move os blocos
    bl[i].show(-velEny, 0);
    
    //Colisão com blocos----------------------------------- 
    if (colidir(bl[i], jet[0]) && bl[i].s) {
      timeNprts = 20;
      hitTest = true;
      playSom = 4;
      if (hit == -1) hit = 0;
      if (hit == 0) removBomb(i);
    }
    //Gerando nova bateris de blocos
    if (bl[blMax-1].x < -(width*2)) geraBlock(0);
  }
  for (int i = tam-1; i >= 0; i--) {
    if (i > 0) {
      jet[i].y = jet[i-1].y;
    }
    jet[i].show();
  }
  jet[0].y = y;

  for (int i = 0; i < nBomb; i++) {
    if (bomb[i].x < -bomb[i].w) {
      bomb[i].x = int(random(0, width/szBmb))+ width*2;
      bomb[i].y = int(random(0, height/szBmb)*szBmb);
    }
    bomb[i].show(0, 0);
    bomb[i].x-=4;
  }

  //Texto das partes
  if (timeNprts > 0) {
    if ((timeNprts%2)==0) {
      textSize(60);
      textAlign(CENTER, CENTER);
      fill(255, 255, 0);
      text("Vida" + tam, width/1.6, height/2);
    }
    timeNprts--;
  }
  textSize(20);
  textAlign(CENTER, CENTER);
  fill(255, 255, bAlert*200);
  text("Tam "+tam, 30, 20);
  text("Bombas", 30, 40);

  //Pegando bombas
  for (int i = 0; i < nBomb; i++) {
    if (colidir(bomb[i], jet[0])) {
      bomb[i].y = -height;
      playSom = 5;
      pts += 15; 
      if (pts > top) top = pts;
      piece(bomb[i].n);
    }
  }
  shotingBomb();
}

void shotingBomb() {
  if (shotBomb && tam > tInit+20 && tBomb == 0 || newFase) {
    hBomb = true;
    if (!newFase){
      piece(-20);
      sBomb.play();
    }else sNewFase.play();
    geraBlock(4);
    newFase = false;
  }
  if (tBomb < 20 && hBomb) tBomb++;
  if (tBomb == 20) hBomb = false;
  if (tBomb > 0 && !hBomb) tBomb--;
  fill(255);
  if (hBomb && tBomb == 1) {
    bombX = jet[0].x + jet[0].w;
    bombY = jet[0].y + jet[0].h/2;
  }
  if(!hBomb && tBomb == 1){
   sNewFase.stop();
    sBomb.stop(); 
  }
  circle(bombX, bombY, tBomb*100);
}
void removBomb(int idx) {

  if (bl[idx].n <= 0) bl[idx].s = false; 
  if (bl[idx].n > 0) {
    bl[idx].n--;
    if (tam > 1) piece(-1);
    else {
      playSom = 3;
      start = false;//Game over
    }
  }
  delay(100);
}
void newBomb() {

  int[] bx = new int[width/szBmb];
  int[] by = new int[height/szBmb];

  seqMix(bx, 0, width/szBmb);
  seqMix(by, 0, height/szBmb);

  bomb = new Block[nBomb];

  for (int i = 0; i < nBomb; i++) {
    bomb[i] = new Block(bx[i]*(width), by[i]*szBmb, szBmb, szBmb, int(random(1, 10)), true, false);
  }
}

void piece(int nPiece) {
  if (nPiece != 0) tam += nPiece;
  int[][] xy = new int[2][tam];

  for (int i = 0; i < tam; i++) {
    if (nPiece == 0) {
      xy[0][i] = 340-i*(szBmb-(tam));
      xy[1][i] = 400;
    } else {
      xy[0][i] = 340-i*(szBmb-(tam));
      if (i < tam-nPiece) xy[1][i] = jet[i].y;
    }
  }
  jet = new Jet[tam];

  for (int i = 0; i < tam; i++) {
    jet[i] = new Jet(xy[0][i], xy[1][i], szJet, szJet, 2);
  }
  jet[0].c = 0;
}

void geraBlock(int bk) {
  if (blMax < 23) blMax++;
  int[][] pos = new int[2][blMax];

  bl = new Block[blMax];

  for (int i = 0; i < blMax; i++) {
    bl[i] = new Block(int(random((width*2)/blSz)) * blSz+width + (bk*width), int(random(height/blSz)) * blSz, blSz, blSz, (int(random(1, blMax+16))), true, true);
  }
  for (int i = 0; i < blMax; i++) {
    for (int j = 0; j < blMax; j++) {
      if (i != j && bl[i].x == bl[j].x && bl[i].y == bl[j].y) {
        boolean loop = true;
        while (loop) {
          loop = false;
          bl[j].x = int(random(width/ blSz)) * blSz + width + (bk*width) ;
          bl[j].y = int(random(height/blSz)) * blSz;
          for (int k = 0; k < j; k++) {
            if (pos[0][k] == bl[j].x && pos[1][k] == bl[j].y)
              loop = true;
          }
        }
      }
    }
  }
}
void control() {
  if (u && y > 9)y -= 10;
  if (d && y < height-30)y += 10;
}
void keyPressed() {
  if (keyPressed) {
    if (keyCode == LEFT)    l = true; 
    else if (keyCode == UP) u = true; 
    else if (keyCode == RIGHT) r = true;
    else if (keyCode == DOWN ) d = true;
    else if (key == 'a' && !start) {
      playSom = 2;
      start = true;
    } else if (key == 'z' && !shotBomb) shotBomb = true;
  }
}
void keyReleased() {
  if (keyCode == LEFT)   l = false; 
  else if (keyCode == UP) u = false; 
  else if (keyCode == RIGHT) r = false;
  else if (keyCode == DOWN ) d = false;
  else if (key == 'a' && !start) start = false;
  else if (key == 'z') shotBomb = false;
}
void seqMix(int[] numeros, int min, int max) {
  int [] vetAux = new int[max];

  for (int i = min; i < max; i++) numeros[i] = int(random(min, max));

  for (int i = min; i < max; i++) {
    for (int j = min; j < max; j++) {  
      if (i != j && numeros[i] == numeros[j]) {
        //gera novo numero
        boolean loop = true;
        while (loop) {
          loop = false;
          numeros[j] = int(random(min, max));
          for (int k = 0; k < j; k++) {
            if (vetAux[k] == numeros[j]) loop = true;
          }
        }
      }
      vetAux[j] = numeros[j];
    }
  }
}
boolean blinkAlert() {
  int timeAlert = 37;

  if (tAlert++ > timeAlert) {
    tAlert = 0;
    sAlarm.stop();
  }
  if (tAlert == timeAlert/2) sAlarm.play();

  return (tAlert > timeAlert/2);
}

//Função de colisão////////////////////////////////////////////////////////
boolean colidir(Block A, Jet B) {    
  return (A.x + A.w > B.x && A.x < B.x + B.w && A.y + A.h > B.y && A.y < B.y + B.h) ;
}
