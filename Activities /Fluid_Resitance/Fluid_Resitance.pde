int MAX_SIZE = 3;
float k = 0.3; 

Liquid liquid; 



Mover[] movers = new Mover[10];


void setup() {
  size(640, 360); 
  background(255);
  liquid = new Liquid(0, height / 2, width, height / 2, 0.1); 
  for (int i = 0; i < movers.length; i++) {
    movers[i] = new Mover(); 
    // movers[i].applyForce(gravity);
  }
}


void draw() {
  background(255);   
  for (int i = 0; i < movers.length; i++) {
    movers[i].update(); 
    float m = movers[i].mass; 
    PVector gravity = new PVector(0, 0.1 * m); 
    movers[i].applyForce(gravity);
    PVector wind = new PVector(0.01, 0); 

    PVector vel = movers[i].vel;
  
    PVector friction = movers[i].vel.get(); 
    friction.normalize(); 
    friction.mult(-0.9);
    if (movers[i].isInside(liquid)) {
      movers[i].drag(liquid);
 
    }
    //movers[i].applyForce(friction); 
    movers[i].checkEdges(); 
    movers[i].display(); 
    // movers[i].applyForce(wind);
  }

  liquid.display();
}

class Mover {
  PVector pos;
  PVector vel;
  PVector acc;
  float mass; 

  Mover() {
    pos = new PVector(random(width), 0); 
    vel = new PVector(0, 0);
    mass = random(MAX_SIZE/2, MAX_SIZE); 
    acc = new PVector(0, 0);
  }

  void applyForce(PVector inputForce) {
    PVector newForce = inputForce.get(); 
    newForce.div(mass); 
    acc.add(newForce);
  }


  void update() {
    vel.add(acc);
    pos.add(vel);
    acc.mult(0);
  }

  void display() {
    stroke(0); 
    fill(0, 204); 
    ellipse(pos.x, pos.y, int(mass) * 16, int(mass) * 16);
  }

  void checkEdges() {
    if (pos.x > width) {
      pos.x = 0;
    } else if (pos.x < 0) {
      pos.x = width;
    }

    if (pos.y > height) {
      vel.y *= -1; // -k;  
      pos.y = height;
    }
  }

  boolean isInside(Liquid l) {
    if (pos.y > l.y) {
      return  true;
    } else {
      return false;
    }
  }

  void drag(Liquid l) {
    float c = 0.2; 
    float speed = vel.mag(); 
    float dragMag = c * speed * speed; 
    PVector drag = vel.get(); 
    drag.mult(-1); 
    drag.normalize(); 
    drag.mult(dragMag);
    applyForce(drag);
  }
}

class Liquid {
  float x, y, w, h; 
  float c; 
  Liquid(float x_, float y_, float w_, float h_, float c_) {
    x = x_; 
    y = y_; 
    w = w_; 
    h = h_; 
    c = c_;
  }

  void display() {
    noStroke();  
    fill(175, 175); 
    rect(x, y, w, h);
  }
}