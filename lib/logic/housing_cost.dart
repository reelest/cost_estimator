enum CostVariable {
  mainFloorLength,
  mainFloorBreadth,
  ceilingHeight,
  numberOfFloors,
  numberOfKitchens,
  numberOfStandaloneToilets,
  numberOfFullBathrooms,
  numberOfRooms,
  done
}

double m2ft(m) {
  return m * 3.28;
}

double ft2m(ft) {
  return ft / 3.28;
}

double ft2inch(ft) {
  return ft * 12;
}

double inch2m(inch) {
  return inch * 0.0254;
}

double getHousingCost(Map<CostVariable, double> data) {
  double cost = 0.0;
  
  return cost;
}
