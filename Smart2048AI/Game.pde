import java.util.Collections;

// class that represents one 2048 game
public class Game extends DNA {
  private Direction direction;
  private Tile[][] tiles;
  private int lastScore;
  private int numberOfNoChangeMove;
  private int largestSoFar; // largest number of current board so far
  
  Game(int index) {
    super(index, 16, 16, 4);
    tiles = new Tile[4][4];
    for (int i = 0; i < 4; ++i) {
      for (int j = 0; j < 4; ++j)
        tiles[i][j] = new Tile(this, i, j);
    }
    for (int i = 0; i < 2; ++i)
      generateNewNum();
    lastScore = 0;
    numberOfNoChangeMove = 0;
    largestSoFar = 0;
  }
  
  public int getLargestSoFar() {
    return largestSoFar;
  }
  
  // creata a new snake who has the brain from the given snake
  public DNA clone() {
    DNA s = new Game(index);
    s.brain = brain.clone();
    return s;
  }
  
  public void update() {
    if (!isAlive())
      return;
    decideNextMove();
    
    boolean moved = false;
    
    switch(this.direction) {
      case up:
        for (int i = 0; i < 4; ++i) {
          for (int j = 1; j < 4; ++j) {
            if (tiles[i][j].filled()) {
              Tile current = tiles[i][j];
              for (int m = j - 1; m >= 0; --m) {
                if (!tiles[i][m].filled()) {
                  tiles[i][m].setNum(current.getNum());
                  current.setNum(-1);
                  current = tiles[i][m];
                  moved = true;
                } else {
                  if (tiles[i][m].getNum() == current.getNum() &&
                      !tiles[i][m].isAdded() && !current.isAdded())
                  {
                    this.updateScore(tiles[i][m].getNum() * 2);
                    tiles[i][m].setNum(tiles[i][m].getNum() * 2);
                    if (tiles[i][m].getNum() > largestSoFar)
                      largestSoFar = tiles[i][m].getNum();
                    tiles[i][m].setAdded();
                    current.setNum(-1);
                    current = tiles[i][m];
                    moved = true;
                  }
                  else
                    break;
                }
              }
            }
          }
        }
        break;
      case left:
        for (int i = 1; i < 4; ++i) {
          for (int j = 0; j < 4; ++j) {
            if (tiles[i][j].filled()) {
              Tile current = tiles[i][j];
              for (int m = i - 1; m >= 0; --m) {
                if (!tiles[m][j].filled()) {
                  tiles[m][j].setNum(current.getNum());
                  current.setNum(-1);
                  current = tiles[m][j];
                  moved = true;
                } else {
                  if (tiles[m][j].getNum() == current.getNum() &&
                      !tiles[m][j].isAdded() && !current.isAdded())
                  {
                    this.updateScore(tiles[m][j].getNum() * 2);
                    tiles[m][j].setNum(tiles[m][j].getNum() * 2);
                    if (tiles[m][j].getNum() > largestSoFar)
                      largestSoFar = tiles[m][j].getNum();
                    tiles[m][j].setAdded();
                    current.setNum(-1);
                    current = tiles[m][j];
                    moved = true;
                  }
                  else
                    break;
                }
              }
            }
          }
        }
        break;
      case right:
        for (int i = 2; i >= 0; --i) {
          for (int j = 0; j < 4; ++j) {
            if (tiles[i][j].filled()) {
              Tile current = tiles[i][j];
              for (int m = i + 1; m < 4; ++m) {
                if (!tiles[m][j].filled()) {
                  tiles[m][j].setNum(current.getNum());
                  current.setNum(-1);
                  current = tiles[m][j];
                  moved = true;
                } else {
                  if (tiles[m][j].getNum() == current.getNum() &&
                      !tiles[m][j].isAdded() && !current.isAdded())
                  {
                    this.updateScore(tiles[m][j].getNum() * 2);
                    tiles[m][j].setNum(tiles[m][j].getNum() * 2);
                    if (tiles[m][j].getNum() > largestSoFar)
                      largestSoFar = tiles[m][j].getNum();
                    tiles[m][j].setAdded();
                    current.setNum(-1);
                    current = tiles[m][j];
                    moved = true;
                  }
                  else
                    break;
                }
              }
            }
          }
        }
        break;
      case down:
        for (int i = 0; i < 4; ++i) {
          for (int j = 2; j >= 0; --j) {
            if (tiles[i][j].filled()) {
              Tile current = tiles[i][j];
              for (int m = j + 1; m < 4; ++m) {
                if (!tiles[i][m].filled()) {
                  tiles[i][m].setNum(current.getNum());
                  current.setNum(-1);
                  current = tiles[i][m];
                  moved = true;
                } else {
                  if (tiles[i][m].getNum() == current.getNum() &&
                      !tiles[i][m].isAdded() && !current.isAdded())
                  {
                    this.updateScore(tiles[i][m].getNum() * 2);
                    tiles[i][m].setNum(tiles[i][m].getNum() * 2);
                    if (tiles[i][m].getNum() > largestSoFar)
                      largestSoFar = tiles[i][m].getNum();
                    tiles[i][m].setAdded();
                    current.setNum(-1);
                    current = tiles[i][m];
                    moved = true;
                  }
                  else
                    break;
                }
              }
            }
          }
        }
        break;
    }
    
    reset();
    if (moved)
      generateNewNum();
    if (lastScore != this.score()) { // update score
      lastScore = this.score();
      numberOfNoChangeMove = 0;
    } else
      ++numberOfNoChangeMove;
    if (numberOfNoChangeMove >= 10 || lose())
      this.die();
  }
  
  // show the snake on the board
  void show() {
    strokeWeight(1);
    int xStart = (index() % 10) * 80 + 400;
    int yStart = (index() / 10) * 80;
    for (int i = 1; i < 4; ++i) {
      line(xStart + i * 20, yStart, xStart + i * 20, yStart + 80);
      line(xStart, yStart + i * 20, xStart + 80, yStart + i * 20);
    }
    
    for (int i = 0; i < 4; ++i) {
      for (int j = 0; j < 4; ++j)
        tiles[i][j].show();
    }
  }
  
  private void reset() {
    for (int i = 0; i < 4; ++i) {
      for (int j = 0; j < 4; ++j)
        tiles[i][j].resetAdded();
    }
  }
  
  void generateNewNum() {
    ArrayList<PVector> list = new ArrayList<PVector>();
    for (int i = 0; i < 4; ++i) {
      for (int j = 0; j < 4; ++j) {
        if (!tiles[i][j].filled()) {
          list.add(new PVector(i, j));
        }
      }
    }
    if (list.size() == 0) {
      print(index() + "\n");
      return;
    }
    
    Collections.shuffle(list);
    PVector rand = list.get(int(random(list.size())));
    tiles[int(rand.x)][int(rand.y)].setNum(random(1) < 0.3 ? 4 : 2);
  }
  
  boolean lose()
  {
    for (int m = 0; m < 3; ++m)
    {
      for (int n = 0; n < 4; ++n)
      {
        if (tiles[m][n].getNum() == tiles[m+1][n].getNum())
            return false;
        if (tiles[n][m].getNum() == tiles[n][m+1].getNum())
            return false;
      }
    }
    return true;
  }
  
  // create input to neural network
  private float[] look() {
    float[] input = new float[16];
    int index = 0;
    
    for (int i = 0; i < 4; ++i) {
      for (int j = 0; j < 4; ++j) {
        if (tiles[i][j].filled())
          input[index++] = 1.0 / logBase2(tiles[i][j].getNum());
        else
          input[index++] = -1;
      }
    }
    return input;
  }

  private float logBase2(int num) {
    return log(num) / log(2);
  }

  // decide next move using neural network
  private void decideNextMove() {
    float[] input = look(); // create input to the neural network
    float[] output = brain.output(input); // create output using neural network
    
    float max = max(output); // find the maximum of the output array
    if (max == output[0])
      direction = Direction.up;
    else if (max == output[1])
      direction = Direction.right;
    else if (max == output[2])
      direction = Direction.down;
    else
      direction = Direction.left;
  }
}