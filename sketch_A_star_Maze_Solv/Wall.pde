
class Wall {

  float x1;
  float y1;
  float x2;
  float y2;

  Wall(float a, float b, float c, float d) {
    x1 = a;
    y1 = b;
    x2 = c;
    y2 = d;
  }

  void show() {
    stroke(0);
    strokeWeight(2);
    line(x1, y1, x2, y2);
  }

  boolean doubleWall() {
    //analizzo tutte le celle e di esse tutti i walls finché non trovo corrispondenza
    
    //salvo quindi la cella di appartenenza del wall e in base all'indice di walls[] 
    //in cui è vi è corrispondenza so di quale cella verificare se è o meno visited
    
    for (Cell c: grid) {
      if (c.walls[0] != null && c.walls[0].equals(this) && c.visited) {
        //0 -> TOP
        
        int k = grid.indexOf(c);
        return grid.get(k - cols).visited;
      
      } else if (c.walls[1] != null && c.walls[1].equals(this) && c.visited) {
        //1 -> RIGHT
        
        int k = grid.indexOf(c);
        return grid.get(k+1).visited;
      
      } else if (c.walls[2] != null && c.walls[2].equals(this) && c.visited) {
        //2 -> BOTTOM
        
        int k = grid.indexOf(c);
        return grid.get(k + cols).visited;
      
      } else if (c.walls[3] != null && c.walls[3].equals(this) && c.visited) {
        //3 -> LEFT
        
        int k = grid.indexOf(c);
        return grid.get(k - 1).visited;
      }
    }
     
    return false;
  }
  
  //verificare se due muri sono uguali (pur appartenendo a celle distinte)
  @Override
  public boolean equals(Object w) {
    if (! (w instanceof Wall))
      return false;
    
    Wall wall = (Wall) w;
    return x1 == wall.x1 && y1 == wall.y1 && y2 == wall.y2 && x2 == wall.x2;
  }
}
