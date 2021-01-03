using CP; 

// Data
{string} Units = {"axe", "light cavalry", "mounted archer", "berserker", "ram"};
int strengths[Units] = [45, 130, 150, 300, 2];
int recruitTimeInSeconds[Units] = [90, 360, 450, 1200, 480];
int foodPerUnit[Units] = [1, 4, 5, 6, 5];

// Decision Variables
dvar int+ numberOfUnits[Units];

// Decision Expressions
dexpr int totalBuildTime = sum(u in Units) (numberOfUnits[u] * recruitTimeInSeconds[u]);
dexpr int totalNegativeAttackStrength = -(sum(u in Units) (numberOfUnits[u] * strengths[u]));

// Objective - always need to be placed before the constraints
minimize staticLex(totalNegativeAttackStrength, totalBuildTime);

// Constraints
subject to {
  ctFoodNoChurch: sum(u in Units) (numberOfUnits[u] * foodPerUnit[u]) <= 20596;
  ctMustHaveRams: numberOfUnits["ram"] > 0;
  totalBuildTime >= 250;
}

// When a .mod file contains a main block, the IDE (or the oplrun command) 
// starts the execution of the model by running the main block first
main {
  var objectiveValues;
  
  // the `thisOplModel` corresponds to the model included in this file
  // .generate() generate the optimisation model and feed it to the CPLEX algorithm
  thisOplModel.generate();
  cp.startNewSearch();
  
  while (cp.next()) {
    thisOplModel.postProcess();
    if (thisOplModel.numberOfUnits["ram"] >= 250) {
      writeln();
      write("axe: " + thisOplModel.numberOfUnits["axe"]);
      write(", lc: " + thisOplModel.numberOfUnits["light cavalry"]);
      write(", ma: " + thisOplModel.numberOfUnits["mounted archer"]);
      write(", serk: " + thisOplModel.numberOfUnits["berserker"]);
      write(", ram: " + thisOplModel.numberOfUnits["ram"]);
      write(", strength: " + (-thisOplModel.totalNegativeAttackStrength));
      write(", time: " + Math.round(thisOplModel.totalBuildTime / 3600 / 24 *100)/100 + " days");
    }
  }
  
  cp.endSearch();
}