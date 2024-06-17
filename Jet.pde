class Jet {
  int x, y, w, h, c;
color cor[]= {#009933,#00CC33,#00CC33,#CC3333,#99FF00};
  Jet(int _x, int _y, int _w, int _h, int _c) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;    
    c = _c;
  }
  void show() {
    stroke(cor[c+2]);
    strokeWeight(2);
    if(c < 2){
      fill(0);
      rect(x-w/2, y+h/4, w/2, h/2,10 );
      fill(cor[c]);
      rect(x, y, w, h, 50);
      fill(0);
      rect(x-w/7, y, w/2, h );        
    }else{
      fill(cor[c]);
      rect(x, y, w, h, 2);
    }
}
}
