
final float gravMul = 1;
final float pRepelMul = 1;

class Planet {
  PVector pos;
  float mass, r;
  
  Planet(PVector _pos, float _mass, float _r) {
    pos = _pos;
    mass = _mass;
    r = _r;
  }
  
  void particleInteract(ArrayList<Particle> particles) {
    for(Particle other: particles) {
      interact(other); 
    }
  }
  
  void interact(Particle other) {
    PVector dif = PVector.sub(other.pos, pos);
    float d = dif.mag();
    float f = 0;
    if(d < other.r * 0.3 + r) {
      f += pRepelMul * ((other.r * 0.3 + r) - d);
    }
    f -= (gravMul * mass * other.m) / (d * d);
        
    other.force.add(PVector.mult(dif, f / d));
  }
  
  void show() {
    fill(0);
    ellipse(pos.x, pos.y, 2 * r, 2 * r); 
  }
}
