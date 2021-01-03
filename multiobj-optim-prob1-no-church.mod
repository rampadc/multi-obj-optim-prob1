/*********************************************
 * OPL 20.1.0.0 Model
 * Author: congn
 * Creation Date: 2 Jan 2021 at 9:32:24 pm
 *********************************************/

using CP; 

// Data
int axeStrength = 45;
int lcStrength = 130;
int maStrength = 150;
int serkStrength = 300;

int secRecAxe = 90;
int secRecLC = 360;
int secRecMA = 450;
int secRecSerk = 1200;
int secRecRam = 480;

int foodAxe = 1;
int foodLC = 4;
int foodMA = 5;
int foodSerk = 6;
int foodRam = 5;

// Decision Variables
dvar int+ numAxe;
dvar int+ numLC;
dvar int+ numMA;
dvar int+ numSerk;

// Decision Expressions
dexpr int totalBuildTime = numAxe*secRecAxe + numLC*secRecLC + numMA*secRecMA + numSerk*secRecSerk + 250*secRecRam;
dexpr int totalNegativeAttackStrength = -(numAxe*axeStrength + numLC*lcStrength + numMA*maStrength + numSerk*serkStrength);

// Objective - always need to be placed before the constraints
minimize staticLex(totalNegativeAttackStrength, totalBuildTime);

// Constraints
subject to {
  (numAxe*foodAxe + numLC*foodLC + numMA*foodMA + numSerk*foodSerk + 250*foodRam) <= 20596;
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
    writeln("axe: " + thisOplModel.numAxe +
    		", lc: " + thisOplModel.numLC +
    		", ma: " + thisOplModel.numMA +
    		", ram: " + 250 + 
    		", serk: " + thisOplModel.numSerk + 
    		", strength: " + (-thisOplModel.totalNegativeAttackStrength) +
    		", time: " + Math.round(thisOplModel.totalBuildTime / 3600 / 24 *100)/100 + " days");
  }
  
  cp.endSearch();
}

