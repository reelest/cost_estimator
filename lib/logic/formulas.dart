//A way to estimate how much walls are shared between rooms and other enclosed spaces
const double estimatedHousePlanDensity = 0.5;

// The wall area of a block
const double blockWallArea = 0.225 * 0.45;

const double tripOfSandInTonnes =
    5 /* Trailer Capacity ie 5 tonne trailer */ * 1.24 /* Overload factor */;

//Cross-sectiional area of a column
double columnSize = inch2m(9) * inch2m(9);

//Cross-sectional area of a beam
double beamSize = inch2m(9) * inch2m(12);

double concreteSlabThickness = inch2m(4);

// https://structville.com/2017/07/how-to-estimate-the-quantity-of-sand-and-cement-required-for-moulding-blocks.html#:~:text=The%20ideal%20mix%20ratio%20for,1%20bag%20to%2025%20blocks.
const blockFormula = {"tripsOfSand": 11, "bagsOfCement": 86, "blocks": 3000};

// https://structville.com/2020/03/how-to-build-your-rate-and-quote-for-concrete.html
const concreteFormula = {
  "tripsOfSand": 1.089 / tripOfSandInTonnes,
  "bagsOfCement": 7,
  "graniteInTonnes": 1.461,
  "waterInLiters": 150,
  "concreteInM3": 1
};

//Conversions

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
