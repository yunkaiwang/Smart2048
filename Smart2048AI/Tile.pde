class Tile {
  private Game game; // the board that the tile belongs to
  private PVector pos;
  private int num; // the number that the current tile owns, -1 if current tile owns no number
  private boolean added;
  
  Tile(Game game, int x, int y) {
    this.game = game;
    pos = new PVector(x, y);
    num = -1;
    added = false;
  }
  
  public boolean isAdded() {
    return added;
  }
  
  public void setAdded() {
    added = true;
  }
  
  public void resetAdded() {
    added = false;
  }
  
  public boolean filled() {
    return num != -1;
  }
  
  public int getNum() {
    return num;
  }
  
  public void setNum(int newNum) {
    num = newNum;
  }
  
  void show() {
    // if no number in current tile, display nothing
    if (num == -1)
      return;
    
    fill(255);
    if (showAll) {
      int xStart = (game.index() % 10) * 80 + 405;
      int yStart = (game.index() / 10) * 80 + 15;
      text(num, pos.x * 20 + xStart, pos.y * 20 + yStart);
    } else
      text(num, pos.x * 20 + 400, pos.y * 20);
  }
  
  PVector pos() {
    return pos;
  }
}