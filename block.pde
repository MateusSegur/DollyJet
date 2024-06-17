class Block {
  int x, y, w, h, n;
  boolean s, b;
  //          vd         az     marrom     roxo      vdcl    uva      bege      verFer   lima    rosa
  color[] c = {#0000FF, #00ff00, #663300, #666666, #66FF66, #6633FF, #FFFFCC, #CC0000, #99FF00, #FF33FF,#000055,
               #330033, #33FFFF, #666633, #9933FF, #996600, #FFFF00, #99FF33, #FFFFFF, #3399FF, #333300, #CC6600,
               #FF9900, #339933, #333333, #6600FF, #33FFFF, #330033, #0033FF, #003300, #FFCC99, #FFFFCC, #FF6633,
               #99FF66, #FF66CC, #33FF66, #CC6600, #CCCCCC, #669933, #FF66FF, #669900, #66CC00, #FF0099,0xFF00CC}; 
  Block(int _x, int _y, int _w, int _h, int _n, boolean _s, boolean _b) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;    
    n = _n;
    s = _s;
    b = _b;
  }
  void show(int vx, int vy) {
    x += vx;
    y += vy;
    if (s) {
      
      
      if(b){
        
        fill(c[n]);
      stroke(0);
      rect(x, y, w, h, 5);
      textSize(40);
      }else{ fill(c[6]);
      stroke(c[9]);
      rect(x, y, w, h, 1);
      textSize(30);
    }
    strokeWeight(2);
    fill(0);
      
      textAlign(CENTER, LEFT);
      text(n, x+w/2, y+h/1.4);
    }
  }
}
