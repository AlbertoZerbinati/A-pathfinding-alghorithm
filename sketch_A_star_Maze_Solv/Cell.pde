
class Cell {

  // f = g + h
  float f = 0;
  float g = 0;
  float h = 0;
  
  Cell previous;
  
  ArrayList<Cell> neighbors = new ArrayList<Cell>();
  
  int i, j; // i = col, j = row
  //boolean[] walls = {true, true, true, true};
  boolean visited = false;
  
  Wall[] walls = new Wall[4]; //TOP, RIGHT, BOTTOM, LEFT

  Cell(int ii, int jj) {
    i = ii;
    j = jj;
    
    //TOP
    if (j > 0) {
      walls[0] = new Wall(i * w, j * w, (i+1) * w, j * w);
      //println("top ok");
    } else
      walls[0] = null;
      
    //RIGHT
    if (i < cols -1) {
      walls[1] = new Wall((i+1) * w, j * w, (i+1) * w, (j+1) * w);
    } else
      walls[1] = null;

    //BOTTOM
    if (j < rows -1) {
      walls[2] = new Wall(i * w, (j+1) * w, (i+1) * w, (j+1) * w);
    } else
      walls[2] = null;
      
    //LEFT
    if (i > 0) {
      walls[3] = new Wall(i * w, j * w, i * w, (j+1) * w);
      //println("left ok");
    } else
      walls[3] = null;
      
  }

  void highlight() {
    int x = this.i*w;
    int y = this.j*w;
    noStroke();
    fill(0, 255, 40);
    rect(x, y, w, w);
  }

  void show() {
    int x = this.i*w;
    int y = this.j*w;

    for (Wall e : walls) {
      if (e != null)
        e.show();
    }

    if (this.visited) {
      noStroke();
      fill(240);
      rect(x, y, w, w);
    }
    
    if (closedSet.contains(this)) {
      noStroke();
      fill(255, 0, 0, 50);
      rect(x, y, w, w);
    } else if (openSet.contains(this)) {
      noStroke();
      fill(0, 255, 0, 50);
      rect(x, y, w, w);
    }
    
    if (this.equals(start)) {
      noStroke();
      colorMode(HSB);
      fill(190, 255, 255);
      colorMode(RGB);
      circle(x + w/2, y + w/2, w/2);
    } else if (this.equals(goal)) {
      noStroke();
      colorMode(HSB);
      fill(255, 255, 255);
      colorMode(RGB);
      circle(x + w/2, y + w/2, w/2);
    }

    
  }
  
  
  void addNeighbors() {
    if (walls[0] == null) {
      int k = grid.indexOf(this);
      //println("k =" + k);
      
      if (k >= cols)
        neighbors.add(grid.get(k - cols));
    }
    if (this.walls[1] == null) {
      int k = grid.indexOf(this);
      
      if (k % (cols) != cols - 1)
        neighbors.add(grid.get(k +1));
      
    }
    if (this.walls[2] == null) {
      int k = grid.indexOf(this);
      
      if (k < cols * (cols - 1))
        neighbors.add(grid.get(k + cols));
    }
    if (this.walls[3] == null) {
      int k = grid.indexOf(this);
      
      if (k % cols != 0)
        neighbors.add(grid.get(k - 1));
    }
    
    //println("walls" + walls[0] + " " + walls[1] + " " + walls[2] + " " + walls[3]);
    //println("neighbors " + neighbors);

  }
  
}
