
final float dT = 0.005;
final float k = 1;
final float g = 0.6;
final float maxVel = 70;
final float visc = 0.007;
final float visc2 = 0.00004;
final float repelMul = 10;
final float wallRepelMul = 40;

class Particle {
  boolean isSolid, isStatic;
  PVector pos, vel, oldVel, force;
  float pres = 0, presNear = 0, r = 50, m = 1, baseDens = 1.5;
  color c;
  boolean gravitate = true;
  
  Particle(PVector _pos, PVector _vel, float _r, float _m, color _c, boolean _isSolid, boolean _isStatic, boolean _gravitate, float _baseDens) {
    pos = _pos;
    vel = _vel;
    
    r = _r;
    m = _m;
    
    force = new PVector(0, 0);
    
    oldVel = new PVector(0, 0);
    
    c = _c;
    isSolid = _isSolid;
    isStatic = _isStatic;
    
    gravitate = _gravitate;
    baseDens = _baseDens;
  }
  
  void move() {
    vel.add(PVector.div(force, m));
    
    if(pos.y > height)
      vel.y -= wallRepelMul * sq(pos.y - height);
    else if(pos.y < 0)
      vel.y += wallRepelMul * sq(pos.y);
    if(pos.x > width)
      vel.x -= wallRepelMul * sq(pos.x - width);
    else if(pos.x < 0)
      vel.x += wallRepelMul * sq(pos.x);
    
    if(gravitate)
      vel.y += g;
    
    float vmag2 = vel.x * vel.x + vel.y * vel.y;
    if(vmag2 > maxVel * maxVel) {
      vel.mult(maxVel / sqrt(vmag2)); 
    }
    
    oldVel = new PVector(vel.x, vel.y);
    
    if(!isStatic)
      pos.add(PVector.mult(vel, dT));
    
    force = new PVector(0, 0);
  }
  
  void tick(ArrayList<Particle> particles) {
    Particle other;
    float d, d2, q, q2, q3, f;
    PVector dif;
    float dens = 0, densNear = 0;
    
    for(int i = particles.size() - 1; i >= 0; i--) {
      other = particles.get(i);
      if(other == this) continue;
      dif = PVector.sub(other.pos, pos);
      d2 = dif.x * dif.x + dif.y * dif.y;
      if((isSolid || other.isSolid) && d2 < r * r + other.r * other.r) {
        d = sqrt(d2);
        float overlap = (r + other.r - d) / (r + other.r);
        f = repelMul * overlap;
        force.sub(PVector.mult(dif, f / d));
      } else if(d2 < r * r) {
        d = sqrt(d2);
        
        q = 1 - (d / r);
        
        q2 = q * q;
        q3 = q * q * q;
        dens += q2;
        densNear += q3;
        
        if(isSolid || other.isSolid) {
          float overlap = (r + other.r - d) / d;
          f = repelMul * overlap;
        } else {
          f = q * (pres + other.pres) + q2 * (presNear + other.presNear);
          f -= visc2 / d2;
        }
        
        force.sub(PVector.mult(dif, f / d));
        
        if(!isSolid && !other.isSolid) {
          q = d / r;
          q2 = q * q;
          vel.add(PVector.mult(other.oldVel, visc * q2));
          other.vel.sub(PVector.mult(other.oldVel, visc * q2));
        }
        
      }
    }
    pres = k * (dens - baseDens);
    presNear = k * (densNear);
  }
  
  void show2() {
    fill(c);
    float dR = (isSolid) ? 2 * r : 0.3 * r;
    float mul = 16;
    float x = mul * (int)(pos.x / mul);
    float y = mul * (int)(pos.y / mul);
    float d = sqrt(sq(pos.x - x) + sq(pos.y - y));
    float r = mul;//(3 - d / mul) * dR;
    rect(x - r / 2, y - r / 2, r, r); 
    //ellipse(x, y, (2.5 - d / mul) * dR, (2.5 - d / mul) * dR); 
  }
  
  void show() {
    fill(c);
    float dR = (isSolid) ? 2 * r : 0.3 * r;
    ellipse(pos.x, pos.y, dR, dR); 
  }
}
