public abstract class DNA {
  protected final int index; // an index for the snake, 0 <= snake < 100, used for showing the snakes
  private int score; // current score
  protected NeuralNetwork brain; // brain that is controlling the snake
  //private int numInput, numHidden, numOutput;
  private boolean alive;
  
  DNA(int index, int input, int hidden, int output) {
    this.index = index;
    score = 0;
    brain = new NeuralNetwork(input, hidden, output);
    //this.numInput = input;
    //this.numHidden = hidden;
    //this.numOutput = output;
    alive = true;
  }
  
  public abstract void show();
  public abstract void update();
  public abstract DNA clone();
  
  public boolean isAlive() {
    return alive;
  }
  
  protected void die() {
    alive = false; 
  }
  
  // getter for score
  public int score() {
    return score;
  }
  
  protected void updateScore(int newScore) {
    this.score += newScore;
  }
  
  // getter for index
  int index() {
    return index;
  }
  
  
  // create a new snake by crossover two snakes
  DNA crossover(DNA other, int index) {
    DNA s = new Game(index);
    s.brain = brain.crossover(other.brain);
    return s;
  }
  
  void mutate() {
    brain.mutate(globalMutationRate);
  }
}