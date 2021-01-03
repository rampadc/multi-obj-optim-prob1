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
dexpr int totalFood = sum(u in Units) (numberOfUnits[u] * foodPerUnit[u]);

// Objective - always need to be placed before the constraints
minimize staticLex(totalNegativeAttackStrength, totalBuildTime);

// Constraints
subject to {
  ctFoodNoChurch: 20594 <= totalFood <= 20596;
  ctMustHaveRams: numberOfUnits["ram"] >= 250;
  0 < totalBuildTime <= 4 * 7 * 24 * 3600; // recruit time is in seconds, 4 weeks, 7 days/week, 24 hours/day, 3600 seconds/hour
}

// When a .mod file contains a main block, the IDE (or the oplrun command) 
// starts the execution of the model by running the main block first
main {  
  // the `thisOplModel` corresponds to the model included in this file
  // .generate() generate the optimisation model and feed it to the CPLEX algorithm
  thisOplModel.generate();
  cp.startNewSearch();
  
  while (cp.next()) {
    thisOplModel.postProcess();
	  writeln();
	  write("axe: " + thisOplModel.numberOfUnits["axe"]);
	  write(", lc: " + thisOplModel.numberOfUnits["light cavalry"]);
	  write(", ma: " + thisOplModel.numberOfUnits["mounted archer"]);
	  write(", serk: " + thisOplModel.numberOfUnits["berserker"]);
	  write(", ram: " + thisOplModel.numberOfUnits["ram"]);
	  write(", strength: " + (-thisOplModel.totalNegativeAttackStrength));
	  write(", time: " + Math.round(thisOplModel.totalBuildTime / 3600 / 24 *100)/100 + " days");
	  write(", food: " + thisOplModel.totalFood);
  }
  
  cp.endSearch();
}