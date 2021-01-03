using CP; 

// Data
{string} Units = {"axe", "light cavalry", "mounted archer", "berserker"};
int strengths[Units] = [45, 130, 150, 300];
int recruitTimeInSeconds[Units] = [90, 360, 450, 1200];
int foodPerUnit[Units] = [1, 4, 5, 6];

// Decision Variables
dvar int+ numberOfUnits[Units];

// Decision Expressions
dexpr int totalBuildTime = sum(u in Units) (numberOfUnits[u] * recruitTimeInSeconds[u]) + 250 * 480;
dexpr int totalNegativeAttackStrength = -(sum(u in Units) (numberOfUnits[u] * strengths[u]));

// Objective - always need to be placed before the constraints
minimize staticLex(totalNegativeAttackStrength, totalBuildTime);

// Constraints
subject to {
  ctFoodNoChurch: sum(u in Units) (numberOfUnits[u] * foodPerUnit[u]) + 1250 <= 20596;
  totalBuildTime > 0;
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
    writeln();
	write("axe: " + thisOplModel.numberOfUnits["axe"]);
	write(", lc: " + thisOplModel.numberOfUnits["light cavalry"]);
	write(", ma: " + thisOplModel.numberOfUnits["mounted archer"]);
	write(", serk: " + thisOplModel.numberOfUnits["berserker"]);
	write(", ram: " + 250);
	write(", strength: " + (-thisOplModel.totalNegativeAttackStrength));
	write(", time: " + Math.round(thisOplModel.totalBuildTime / 3600 / 24 *100)/100 + " days");
  }
  
  cp.endSearch();
}
