
final float gravMul = 1; // Planet gravity multiplier
final float pRepelMul = 1; // Planet repel multiplier

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
      interact(other); // Compute gravity and repulsion for each particle 
    }
  }
  
  void interact(Particle other) {
    PVector dif = PVector.sub(other.pos, pos);
    float d = dif.mag();
    float f = 0;
    if(d <= 0.01) return; // Trying to prevent NaNpocalypse
    if(d < other.r * 0.3 + r) { // Particle is inside planet: need to push it away
      f += pRepelMul * ((other.r * 0.3 + r) - d);
    }
    f -= (gravMul * mass * other.m) / (d * d); // Compute gravity
        
    other.force.add(PVector.mult(dif, f / d)); // Dividing by the distance to normalise difference
  }
  
  void show() {
    fill(0);
    ellipse(pos.x, pos.y, 2 * r, 2 * r); 
  }
}
