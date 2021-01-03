main {
  var source = new IloOplModelSource("./staticLexFull.mod");
  var modelDefinition = new IloOplModelDefinition(source);
  var extData = new IloOplDataSource("./staticLexFull_data.dat");
  
  var cplex = new IloCplex();
  var opl = new IloOplModel(modelDefinition, cplex);
  opl.addDataSource(extData);
	// Create a model for optimisation
	opl.generate();

	var weightStep = 0.1;
		 
	var strengthWeight = opl.weights[1];
	
	while (strengthWeight >= 0) {
	  if (cplex.solve()) {
	    writeln();
		  write("axe: " + opl.numberOfUnits["axe"]);
		  write(", lc: " + opl.numberOfUnits["light cavalry"]);
		  write(", ma: " + opl.numberOfUnits["mounted archer"]);
		  write(", serk: " + opl.numberOfUnits["berserker"]);
		  write(", ram: " + opl.numberOfUnits["ram"]);
		  write(", strength: " + (-opl.totalNegativeAttackStrength));
		  write(", time: " + Math.round(opl.totalBuildTime / 3600 / 24 *100)/100 + " days");
		  write(", food: " + opl.totalFood);
	  }
	  
	  // Prepare for next iteration
	  // Decrease strength weight by `weightStep`
	  // Increase time weight by `weightStep` or (1 - strengthWeight)
	  strengthWeight = opl.weights[1];
	  strengthWeight -= weightStep;
	  
	  // create new external data to load in as weights
	  var newData = opl.dataElements;
	  newData.weights[1] = strengthWeight;
	  newData.weights[2] = 1 - strengthWeight;
	  
	  // Load the new data structure into a newly created model
	  var opl = new IloOplModel(modelDefinition, cplex);
	  opl.addDataSource(newData);
	  opl.generate();
	} 	
 	
  opl.end();
  extData.end();
	modelDefinition.end(); 
	cplex.end(); 
	source.end(); 
}  