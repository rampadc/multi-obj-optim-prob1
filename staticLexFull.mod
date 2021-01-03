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

dexpr int goals[i in 1..2] = (i == 1) ? totalNegativeAttackStrength : totalBuildTime;
int priorities[i in 1..2] = 1;

// Externalise weights for edits
float weights[1..2] = ...; // weight[1]: strength, weight[2]: time
// Assigning abstol and reltol to 0 doesn't seem to have an impact on the solution
float abstol[i in 1..2] = 0; 
float reltol[i in 1..2] = 0; 

// Objective - always need to be placed before the constraints
minimize staticLexFull(goals, weights, priorities, abstol, reltol);

// Constraints
subject to {
  ctFoodNoChurch: 20580 <= totalFood <= 20596;
  ctMustHaveRams: numberOfUnits["ram"] >= 250;
  0 < totalBuildTime <= 4 * 7 * 24 * 3600; // recruit time is in seconds, 4 weeks, 7 days/week, 24 hours/day, 3600 seconds/hour
}
