class PriceList {
  final String currency;
  final double bagOfCement;
  final double tripOfSand;
  final double doorD1;
  final double doorD2;
  final double doorD3;
  final double windowW1;
  final double windowW2;
  final double waterInLiters;
  final double tilesPerM2;
  final double graniteInTonnes;
  final double steelPerM3;
  final double costOfRoofHalfPlot;

  // https://www.propertypro.ng/blog/cost-of-building-materials-in-nigeria-2018/
  //
  const PriceList({
    this.currency = "N",
    this.bagOfCement = 4100,
    this.tripOfSand = 28000,
    this.waterInLiters = 5.0,
    this.doorD1 = 15000,
    this.doorD2 = 11000,
    this.doorD3 = 6000,
    this.windowW1 = 35000,
    this.windowW2 = 25000,
    this.tilesPerM2 = 5500,
    this.graniteInTonnes = 9000 /*cost*/ + 7000 /*transportation*/,
    this.steelPerM3 = 1.5 /*convert to tonnes*/ * 170000,
    this.costOfRoofHalfPlot = 800000,
  });
}
