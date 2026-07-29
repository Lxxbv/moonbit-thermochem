///|
/// Constructs a NASA7 model from one documented coefficient set per segment.
fn nasa7_model(
  lower : Double,
  middle : Double,
  upper : Double,
  low : Array[Double],
  high : Array[Double],
) -> @moonbit-thermochem.ThermoModel raise @moonbit-thermochem.ThermoError {
  let low_segment = @moonbit-thermochem.Nasa7Segment::new(
    range=@moonbit-thermochem.TemperatureRange::new(lower~, upper=middle),
    a1=low[0],
    a2=low[1],
    a3=low[2],
    a4=low[3],
    a5=low[4],
    a6=low[5],
    a7=low[6],
  )
  let high_segment = @moonbit-thermochem.Nasa7Segment::new(
    range=@moonbit-thermochem.TemperatureRange::new(lower=middle, upper~),
    a1=high[0],
    a2=high[1],
    a3=high[2],
    a4=high[3],
    a5=high[4],
    a6=high[5],
    a7=high[6],
  )
  @moonbit-thermochem.ThermoModel::Nasa7([low_segment, high_segment])
}

///|
fn builtin_species(
  name : String,
  molar_mass : Double,
  formation_enthalpy : Double,
  lower : Double,
  middle : Double,
  upper : Double,
  low : Array[Double],
  high : Array[Double],
) -> @moonbit-thermochem.Species raise @moonbit-thermochem.ThermoError {
  @moonbit-thermochem.Species::new(
    name~,
    formula=@moonbit-thermochem.parse_formula(name),
    phase=@moonbit-thermochem.Phase::Gas,
    molar_mass~,
    formation_enthalpy~,
    model=nasa7_model(lower, middle, upper, low, high),
  )
}

///|
/// Returns one of the bundled NASA7 gas species.
///
/// Coefficients are transcribed from the public GRI-Mech 3.0 data distributed
/// by Cantera; the scoped provenance and limitations are in `docs/data-sources.md`.
pub fn get_species(
  name : String,
) -> @moonbit-thermochem.Species raise @moonbit-thermochem.ThermoError {
  match name {
    "CH4" =>
      builtin_species(
        "CH4",
        16.043,
        -74599.5744749737,
        200.0,
        1000.0,
        3500.0,
        [
          5.14987613, -0.0136709788, 4.91800599e-05, -4.84743026e-08, 1.66693956e-11,
          -1.02466476e+04, -4.64130376,
        ],
        [
          0.074851495, 0.0133909467, -5.73285809e-06, 1.22292535e-09, -1.0181523e-13,
          -9468.34459, 18.437318,
        ],
      )
    "O2" =>
      builtin_species(
        "O2",
        31.998,
        1.63433319630255e-05,
        200.0,
        1000.0,
        3500.0,
        [
          3.78245636, -2.99673416e-03, 9.84730201e-06, -9.68129509e-09, 3.24372837e-12,
          -1063.94356, 3.65767573,
        ],
        [
          3.28253784, 1.48308754e-03, -7.57966669e-07, 2.09470555e-10, -2.16717794e-14,
          -1088.45772, 5.45323129,
        ],
      )
    "N2" =>
      builtin_species(
        "N2",
        28.014,
        1.42990204814049,
        300.0,
        1000.0,
        5000.0,
        [
          3.298677, 1.4082404e-03, -3.963222e-06, 5.641515e-09, -2.444854e-12, -1020.8999,
          3.950372,
        ],
        [
          2.92664, 1.4879768e-03, -5.68476e-07, 1.0097038e-10, -6.753351e-15, -922.7977,
          5.980528,
        ],
      )
    "CO2" =>
      builtin_species(
        "CO2",
        44.009,
        -393507.757670411,
        200.0,
        1000.0,
        3500.0,
        [
          2.35677352, 8.98459677e-03, -7.12356269e-06, 2.45919022e-09, -1.43699548e-13,
          -4.83719697e+04, 9.90105222,
        ],
        [
          3.85746029, 4.41437026e-03, -2.21481404e-06, 5.23490188e-10, -4.72084164e-14,
          -4.8759166e+04, 2.27163806,
        ],
      )
    "H2O" =>
      builtin_species(
        "H2O",
        18.015,
        -241824.621625365,
        200.0,
        1000.0,
        3500.0,
        [
          4.19864056, -2.0364341e-03, 6.52040211e-06, -5.48797062e-09, 1.77197817e-12,
          -3.02937267e+04, -0.849032208,
        ],
        [
          3.03399249, 2.17691804e-03, -1.64072518e-07, -9.7041987e-11, 1.68200992e-14,
          -3.00042971e+04, 4.9667701,
        ],
      )
    "CO" =>
      builtin_species(
        "CO",
        28.010,
        -110529.369762715,
        200.0,
        1000.0,
        3500.0,
        [
          3.57953347, -6.1035368e-04, 1.01681433e-06, 9.07005884e-10, -9.04424499e-13,
          -1.4344086e+04, 3.50840928,
        ],
        [
          2.71518561, 2.06252743e-03, -9.98825771e-07, 2.30053008e-10, -2.03647716e-14,
          -1.41518724e+04, 7.81868772,
        ],
      )
    "H2" =>
      builtin_species(
        "H2",
        2.016,
        1.32817691377647e-05,
        200.0,
        1000.0,
        3500.0,
        [
          2.34433112, 7.98052075e-03, -1.9478151e-05, 2.01572094e-08, -7.37611761e-12,
          -917.935173, 0.683010238,
        ],
        [
          3.3372792, -4.94024731e-05, 4.99456778e-07, -1.79566394e-10, 2.00255376e-14,
          -950.158922, -3.20502331,
        ],
      )
    "NH3" =>
      builtin_species(
        "NH3",
        17.031,
        -45898.2191237179,
        200.0,
        1000.0,
        6000.0,
        [
          4.2860274, -4.660523e-03, 2.1718513e-05, -2.2808887e-08, 8.2638046e-12,
          -6741.7285, -0.62537277,
        ],
        [
          2.6344521, 5.666256e-03, -1.7278676e-06, 2.3867161e-10, -1.2578786e-14,
          -6544.6958, 6.5662928,
        ],
      )
    _ => raise @moonbit-thermochem.ThermoError::MissingSpecies(name~)
  }
}

///|
pub fn methane_combustion() -> @moonbit-thermochem.Reaction raise @moonbit-thermochem.ThermoError {
  @moonbit-thermochem.Reaction::new(
    label="CH4 + 2 O2 -> CO2 + 2 H2O",
    reactants=[
      @moonbit-thermochem.StoichTerm::new(
        species=get_species("CH4"),
        coefficient=1.0,
      ),
      @moonbit-thermochem.StoichTerm::new(
        species=get_species("O2"),
        coefficient=2.0,
      ),
    ],
    products=[
      @moonbit-thermochem.StoichTerm::new(
        species=get_species("CO2"),
        coefficient=1.0,
      ),
      @moonbit-thermochem.StoichTerm::new(
        species=get_species("H2O"),
        coefficient=2.0,
      ),
    ],
  )
}

///|
pub fn hydrogen_combustion() -> @moonbit-thermochem.Reaction raise @moonbit-thermochem.ThermoError {
  @moonbit-thermochem.Reaction::new(
    label="2 H2 + O2 -> 2 H2O",
    reactants=[
      @moonbit-thermochem.StoichTerm::new(
        species=get_species("H2"),
        coefficient=2.0,
      ),
      @moonbit-thermochem.StoichTerm::new(
        species=get_species("O2"),
        coefficient=1.0,
      ),
    ],
    products=[
      @moonbit-thermochem.StoichTerm::new(
        species=get_species("H2O"),
        coefficient=2.0,
      ),
    ],
  )
}

///|
pub fn ammonia_synthesis() -> @moonbit-thermochem.Reaction raise @moonbit-thermochem.ThermoError {
  @moonbit-thermochem.Reaction::new(
    label="N2 + 3 H2 -> 2 NH3",
    reactants=[
      @moonbit-thermochem.StoichTerm::new(
        species=get_species("N2"),
        coefficient=1.0,
      ),
      @moonbit-thermochem.StoichTerm::new(
        species=get_species("H2"),
        coefficient=3.0,
      ),
    ],
    products=[
      @moonbit-thermochem.StoichTerm::new(
        species=get_species("NH3"),
        coefficient=2.0,
      ),
    ],
  )
}
