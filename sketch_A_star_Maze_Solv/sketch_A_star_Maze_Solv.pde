
int cols, rows;

final int w = 30;

ArrayList<Cell> grid = new ArrayList<Cell>();

ArrayList<Wall> walList = new ArrayList<Wall>();

Cell current;
Cell start;
Cell goal;

//The set of currently discovered nodes that are not evaluated yet.
//Initially, only the start node is known.
ArrayList<Cell> openSet = new ArrayList<Cell>();

// The set of nodes already evaluated
ArrayList<Cell> closedSet = new ArrayList<Cell>();


void setup() {
  size(900, 900, P3D);
  smooth();

  println("A*");

  //frameRate(10);

  cols = rows = width / w;

  for (int j = 0; j < rows; j++) {
    for (int i = 0; i < cols; i++) {
      Cell cell = new Cell(i, j);
      grid.add(cell);
    }
  }

  current = grid.get(0);
  start = grid.get((int) rows/4);
  goal = grid.get((int) rows/4*3 + rows * (rows -1));

  for (Wall e : current.walls) 
    if (e != null && ! walList.contains(e))
      walList.add(e); //aggiungiamo il right e il bottom se non nulli e se non già contenuti

  createMaze();      //crezione maze

  //println(walList.size());
}

void draw() {
  //background(50);

  //algoritmo A* per la risoluzione ottimale!...

  //println("openSet: " + openSet.size());

  if (openSet.size() > 0) { //still searching

    //cerco il nodo nell'openSet con f minore
    int winner = 0;
    for (int i = 0; i < openSet.size(); i++) {
      if (openSet.get(i).f < openSet.get(winner).f) {
        winner = i;
      }
    }
    current = openSet.get(winner); //è il nostro nuovo current

    // Did I finish?
    if (current == goal) {
      noLoop();
      println("SOLVED!");
    }

    // Best option moves from openSet to closedSet
    openSet.remove(current);
    closedSet.add(current);

    ArrayList<Cell> neigh = current.neighbors;

    //println("current.neighbors " + current.neighbors);
    //println("neigh: " + neigh.size() + " " + neigh);

    for (int i = 0; i < neigh.size(); i++) {
      Cell neighbor = neigh.get(i);

      if (!closedSet.contains(neighbor)) {

        //qua heuristic la sfrutto solo per sapere la distanza ma non 
        //è la vera stima eurisitca che ci servirà dopo e che caratterizza A*
        float tempG = current.g + heuristic(neighbor, current);

        // Is this a better path than before?
        boolean newPath = false;

        if (openSet.contains(neighbor)) {
          if (tempG < neighbor.g) {
            neighbor.g = tempG;
            newPath = true;
          }
        } else {
          neighbor.g = tempG;
          newPath = true;
          openSet.add(neighbor);
        }

        // Yes, it's a better path
        if (newPath) {
          neighbor.h = heuristic(neighbor, goal);
          neighbor.f = neighbor.g + neighbor.h;
          neighbor.previous = current;
        }
      }
    }
  } else {
    // Uh oh, no solution
    println("no solution");
    //println(current.walls);
    noLoop();
    return;
  }

  // Draw current state of everything



  // Find the path by working backwards
  ArrayList<Cell> path = new ArrayList<Cell>();

  Cell temp = current;
  path.add(temp);

  while (temp.previous != null) {
    path.add(temp.previous);
    temp = temp.previous;
  }

  // Drawing path as continuous line
  noFill();
  stroke(255, 0, 200);
  strokeWeight(w / 3);
  beginShape();
  for (int i = 0; i < path.size(); i++) {
    colorMode(HSB);
    stroke(map(heuristic(path.get(i), goal), 0, heuristic(start, goal), 255, 190), 255, 255);
    colorMode(RGB);
    vertex(path.get(i).i * w + w / 2, path.get(i).j * w + w / 2);
  }
  endShape();

  for (Cell c : grid)
    c.show();
}


float heuristic(Cell a, Cell b) {
  float d = abs(a.i - b.i) + abs(a.j - b.j);
  return d;
}






void createMaze() {

  while (walList.size() > 0) {
    //background(255);

    current.visited = true;
    //current.highlight();

    //scelgo un wall casuale dalla lista
    int ran = (int) random(walList.size()); 
    //println(ran);
    Wall wall = walList.get(ran); 

    if (wall.doubleWall()) {

      //println("doubleWall");
      walList.remove(wall); //rimuovo dalla lista e quindi sarà un muro del maze
    } else {

      //println("singleWall");
      walList.remove(wall);

      for (Cell c : grid) {
        if (c.walls[0] != null && c.walls[0].equals(wall) && c.visited) {
          //0 -> TOP

          c.walls[0] = null;

          int k = grid.indexOf(c);
          Cell next = grid.get(k - cols);

          next.walls[2] = null;

          next.visited = true;

          current = next;
          //println("TOP");
        } else if (c.walls[1] != null && c.walls[1].equals(wall) && c.visited) {
          //1 -> RIGHT

          c.walls[1] = null;

          int k = grid.indexOf(c);
          Cell next = grid.get(k + 1);

          next.walls[3] = null;

          next.visited = true;

          current = next;
          //println("RIGHT");
        } else if (c.walls[2] != null && c.walls[2].equals(wall) && c.visited) {
          //2 -> BOTTOM

          c.walls[2] = null;

          int k = grid.indexOf(c);
          Cell next = grid.get(k + cols);

          next.walls[0] = null;

          next.visited = true;

          current = next;
          //println("BOTTOM");
        } else if (c.walls[3] != null && c.walls[3].equals(wall) && c.visited) {
          //3 -> LEFT

          c.walls[3] = null;

          int k = grid.indexOf(c);
          Cell next = grid.get(k - 1);

          next.walls[1] = null;

          next.visited = true;

          current = next;

          //println("LEFT");
        }
      }

      for (Wall e : current.walls) 
        if (e != null && ! walList.contains(e))
          walList.add(e); //aggiungiamo i muri se non nulli e se non già contenuti
    }
  } 

  for (Cell c : grid) {
    c.addNeighbors(); //ad ogni cella i propri vicini
  }

  openSet.add(start);  

  println("MAZE GENERATED SUCCESFULLY!");

  //println("size " + walList.size());
}
