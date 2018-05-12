class Population {
  private DNA[] population;
  private int generations; // generations count
  private int bestIndex; // index of the best DNA
  private int bestScore; // current best score
  private int globalBest; // global best score
  
  private int largestNumber; /** Specific to 2048 game */
  
  Population() {
    population = new Game[100]; // create a population with 100 DNAs
    for (int i = 0; i < 100; ++i)
      population[i] = new Game(i);
    generations = 1;
    bestIndex = 0; // initially set the best DNA to be the first DNA
    bestScore = 0; // set initial best score to -1
    globalBest = 0;
    largestNumber = 0; /** Specific to 2048 game */
  }
  
  public void show() {
    // draw lines to split the DNAs
    strokeWeight(2);
    for (int i = 1; i < 10; ++i) {
      line(400, i * 80, 1200, i * 80);
      line(400 + i * 80, 0, 400 + i * 80, 800);
    }
    for (DNA s : population)
      s.show();
  }
  
  // getter for generations
  public int generations() {
    return generations;
  }
  
  // getter for globalBest
  public int globalBest() {
    return globalBest;
  }
  
  public int largestNumber() {
    return largestNumber;
  }
  
  // return whether all DNAs in current population has all died
  boolean finished() {
    for (DNA s : population) {
      if (s.isAlive())
        return false;
    }
    return true;
  }
  
  // update current population, either move all the alive DNAs,
  // or evolve if all DNAs have died
  public void update() {
    if (!finished()) { // if at least one DNA is alive
      for (DNA s : population)
        s.update();
      updateCurrentBest();
    } else { // all DNAs have died, should create a new population
      resetCurrentBest();
      evolve();
    }
    updateLargestNumber(); /** Specific to 2048 game */
  }
  
  /** Specific to 2048 game */
  private void updateLargestNumber() {
    for (DNA s : population) {
      if (((Game)s).getLargestSoFar() > largestNumber)
        largestNumber = ((Game)s).getLargestSoFar();
    }
  }
  
  // update current best DNAs
  private void updateCurrentBest() {
    int maxScore = population[0].score();
    int maxIndex = 0;
    for (int i = 1; i < population.length; ++i) {
      if (population[i].isAlive() && population[i].score() >= maxScore) {
        maxScore = population[i].score();
        maxIndex = i;
      }
    }
    // if previous best DNA dies, then we change the best DNA that is showing
    if (!population[bestIndex].isAlive())
      bestIndex = maxIndex;
    
    if (maxScore > bestScore + 5) {
      bestScore = maxScore;
      bestIndex = maxIndex;
    }
    
    if (maxScore > globalBest)
      globalBest = bestScore;
  }
  
  // reset current best DNA as the population has evolved
  private void resetCurrentBest() {
    bestScore = -1;
    bestIndex = 0;
  }
  
  // save all the scores
  private void saveScore() {
    t.addColumn("Generation #" + generations);
    int totalScore = 0;
    for (int i = 0; i < 100; ++i) {
      TableRow tr = t.getRow(i);
      totalScore += population[i].score();
      tr.setInt(generations, population[i].score());
    }
    TableRow tr = t.getRow(100);
    tr.setFloat(generations, totalScore / 100.0);
  }
  
  private void evolve() {
    saveScore();
    int[] index = new int[100];
    for (int i = 0; i < 100; ++i)
      index[i] = i;
    int score = findkthbestIndex(10, index); // find 10 best DNA to create next population
    
    int totalScore = 0;
    ArrayList<DNA> matingpool = new ArrayList<DNA>();
    for (DNA s : population) {
      totalScore += s.score();
      if (s.score() >= score) {
        matingpool.add(s.clone());
      }
    }
    print("Generation #" + generations + ": average score is " + totalScore / 100.0 + "\n");
    
    DNA[] newDNAs = new DNA[100];
    for (int i = 0; i < 100; ++i) {
      DNA p1 = matingpool.get(floor(random(matingpool.size())));
      DNA p2 = matingpool.get(floor(random(matingpool.size())));
      
      newDNAs[i] = p1.crossover(p2, i);
      newDNAs[i].mutate();
    }
    population = newDNAs;
    generations += 1; // increase generation count
  }
  
  private int findkthbestIndex(int k, int[] DNAIndexes) {
    int pivot = floor(random(DNAIndexes.length));
    int score = population[DNAIndexes[pivot]].score();
    
    IntList smallIndexes = new IntList();
    IntList largerIndexes = new IntList();
    IntList equalIndexes = new IntList();
    for (int index : DNAIndexes) {
      int currentScore = population[index].score();
      if (currentScore > score)
        smallIndexes.append(index);
      else if (currentScore < score)
        largerIndexes.append(index);
      else
        equalIndexes.append(index);
    }
    if (k <= smallIndexes.size()) {
      return findkthbestIndex(k, smallIndexes.array());
    } else if (k <= smallIndexes.size() + equalIndexes.size())
      return score;
    else
      return findkthbestIndex(k - smallIndexes.size() - equalIndexes.size(), largerIndexes.array());
  }
}