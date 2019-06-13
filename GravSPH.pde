
ArrayList<Particle> particles;
ArrayList<Planet> planets;

void specialDraw() {
  float rc, gc, bc;
  loadPixels();
  for(int x = 0; x < width; x++) {
    for(int y = 0; y < height; y++) {
      float tmp = 0;
      for(int i = 0; i < particles.size(); i++) {
        tmp += 3 / (sq((float)x - particles.get(i).pos.x) + sq((float)y - particles.get(i).pos.y));
      }
      rc = 255 - 255 * tmp;
      if(rc < 0)
        rc = 0;
      else if(rc > 255)
        rc = 255;
      gc = 255 - 155 * tmp;
      if(gc < 100)
        gc = 100;
      else if(gc > 100 + 155)
        gc = 255;
      bc = 255 - 55 * tmp;
      if(bc < 200)
        bc = 200;
      
      pixels[y * width + x] = color(rc, gc, bc); 
    }
  }
  updatePixels();
}

void setup() {
  size(1200, 600);  
  particles = new ArrayList<Particle>();
  for(int i = 0; i < 350; i++) {
    particles.add(new Particle(new PVector(random(0, 0.3 * width), random(0, height)),
                                new PVector(0, 0), 12, 3, color(80, 80, 200), false, false, false, 1.5));
  }
  //for(int i = 0; i < 210; i++) {
  //  particles.add(new Particle(new PVector(random(0, 0.3 * width), random(0, height)),
  //                              new PVector(0, 0), 9, 0.1, color(190, 190, 210), false, false, false, 1.5));
  //}
  planets = new ArrayList<Planet>();
  planets.add(new Planet(new PVector(400, 300), 800, 50));
  planets.add(new Planet(new PVector(1000, 300), 8000, 5));
  fill(80, 80, 220);
  noStroke();
}

float mouseStrength = 99999999;

void mouseDragged() {
  PVector dif;
  float d, d2;
  for(int i = 0; i < particles.size(); i++) {
    dif = PVector.sub(new PVector(mouseX, mouseY), particles.get(i).pos);
    d2 = dif.x * dif.x + dif.y * dif.y;
    if(d2 == 0) continue;
    if(d2 < 50) {
      d = sqrt(d2);
      particles.get(i).vel.add(PVector.mult(dif, mouseStrength / (d * d2)));
    }
  }
}

void mousePressed() {
  for(int i = 0; i < 100; i++) {
    float angle = random(0, TWO_PI);
    float d = random(0, 20);
    int idx = (int)random(0, particles.size());
    if(particles.get(idx).isStatic) continue;
    particles.get(idx).pos = new PVector(cos(angle) * d + mouseX, sin(angle) * d + mouseY);
    particles.get(idx).vel = new PVector(-cos(angle) * d * d, -sin(angle) * d * d);
  }
}

boolean breakStuff;

void keyPressed() {
  if(key == 's') {
    //for(int i = 0; i < 20; i++) {
    //  float angle = random(0, TWO_PI);
    //  float d = random(0, 20);
    //  //particles.add(new Particle(new PVector(mouseX + cos(angle) * d, mouseY + sin(angle) * d), new PVector(0, 0), 20, color(150, 150, 40)));
    //}
    particles.add(new Particle(new PVector(mouseX, mouseY), new PVector(0, 0), 20, 1, color(0), true, true, true, 1));
  } else if (key == '`') {
    paused = !paused; 
  }
}

boolean paused = true;

int tickCount = 20;

void draw() {
  if(!paused) {
    for(int _ = 0; _ < tickCount; _++) {
      for(Particle particle: particles) {
        particle.tick(particles);
      }
      for(Planet planet: planets) {
        planet.particleInteract(particles);
      }
      for(Particle particle: particles) {
        particle.move();
      }
    }
  }
  background(255);
  for(Particle particle: particles) {
    particle.show();
    println(particle.pos);
  }
  for(Planet planet: planets) {
    planet.show();
  }
  println(frameRate);
}
