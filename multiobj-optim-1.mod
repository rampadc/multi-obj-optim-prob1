/*********************************************
 * OPL 20.1.0.0 Model
 * Author: congn
 * Creation Date: 2 Jan 2021 at 9:32:24 pm
 *********************************************/
 
dvar int+ axe;
dvar int+ lc;
dvar int+ ma;
dvar int+ serk;

tuple Unit {
  key string shortName; // sp, sw, ar, hc, axe, lc, ma, ram, cat, serk, treb
  string fullName; // spear, sword, archer, heavyCavalry, axe, lightCavalry, mountedArcher, ram, catapult, berserker, trebuchet
  int wood;
  int clay;
  int iron;
  int food;
  int attack;
  int defense;
  int defenseCavalry;
  int defenseArcher;
  int lootCapacity;
  float travelTimePerTile;
  float baseRecruitTime;
}

{Unit} units = ...;