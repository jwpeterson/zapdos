[GlobalParams]
[]

[Mesh]
  type = FileMesh
  file = 'just_plasma.msh'
[]

[MeshModifiers]
  [./left]
    type = SideSetsFromNormals
    normals = '-1 0 0'
    new_boundary = 'left'
  [../]
  [./right]
    type = SideSetsFromNormals
    normals = '1 0 0'
    new_boundary = 'right'
  [../]
[]

[Problem]
  type = FEProblem
[]

[Preconditioning]
  [./smp]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient
  end_time = 1e-1
  petsc_options = '-snes_converged_reason -snes_linesearch_monitor'
  solve_type = NEWTON
  petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_shift_amount -ksp_type -snes_linesearch_minlambda'
  petsc_options_value = 'lu NONZERO 1.e-10 preonly 1e-3'
 nl_rel_tol = 1e-4
 nl_abs_tol = 8e-6
  dtmin = 1e-12
  [./TimeStepper]
    type = IterationAdaptiveDT
    cutback_factor = 0.4
    dt = 1e-9
    growth_factor = 1.2
   optimal_iterations = 15
  [../]
[]

[Outputs]
  print_perf_log = true
  print_linear_residuals = false
  [./out]
    type = Exodus
  [../]
[]

[Debug]
  show_var_residual_norms = true
[]

[UserObjects]
  [./data_provider]
    type = ProvideMobility
    electrode_area = 5.02e-7 # Formerly 3.14e-6
    # ballast_resist = 8.1e3
    ballast_resist = 1e6
    e = 1.6e-19
  [../]
[]

[Kernels]
  [./em_time_deriv]
    type = ElectronTimeDerivative
    variable = em
  [../]
  [./em_advection]
    type = EFieldAdvection
    variable = em
    potential = potential
  [../]
  [./em_diffusion]
    type = CoeffDiffusion
    variable = em
  [../]
  [./em_ionization]
    type = ElectronsFromIonization
    variable = em
    potential = potential
    mean_en = mean_en
  [../]
  [./em_log_stabilization]
    type = LogStabilizationMoles
    variable = em
    offset = 50
  [../]
  # [./em_advection_stabilization]
  #   type = EFieldArtDiff
  #   variable = em
  #   potential = potential
  # [../]

  [./potential_diffusion]
    type = CoeffDiffusionLin
    variable = potential
  [../]
  [./Arp_charge_source]
    type = ChargeSourceMoles_KV
    variable = potential
    charged = Arp
  [../]
  [./em_charge_source]
    type = ChargeSourceMoles_KV
    variable = potential
    charged = em
  [../]

  [./Arp_time_deriv]
    type = ElectronTimeDerivative
    variable = Arp
  [../]
  [./Arp_advection]
    type = EFieldAdvection
    variable = Arp
    potential = potential
  [../]
  [./Arp_diffusion]
    type = CoeffDiffusion
    variable = Arp
  [../]
  [./Arp_ionization]
    type = IonsFromIonization
    variable = Arp
    potential = potential
    em = em
    mean_en = mean_en
  [../]
  [./Arp_log_stabilization]
    type = LogStabilizationMoles
    offset = 17
    variable = Arp
  [../]
  # [./Arp_advection_stabilization]
  #   type = EFieldArtDiff
  #   variable = Arp
  #   potential = potential
  # [../]


  [./mean_en_time_deriv]
    type = ElectronTimeDerivative
    variable = mean_en
  [../]
  [./mean_en_advection]
    type = EFieldAdvection
    variable = mean_en
    potential = potential
  [../]
  [./mean_en_diffusion]
    type = CoeffDiffusion
    variable = mean_en
  [../]
  [./mean_en_joule_heating]
    type = JouleHeating
    variable = mean_en
    potential = potential
    em = em
    potential_units = kV
  [../]
  [./mean_en_ionization]
    type = ElectronEnergyLossFromIonization
    variable = mean_en
    potential = potential
    em = em
  [../]
  [./mean_en_elastic]
    type = ElectronEnergyLossFromElastic
    variable = mean_en
    potential = potential
    em = em
  [../]
  [./mean_en_excitation]
    type = ElectronEnergyLossFromExcitation
    variable = mean_en
    potential = potential
    em = em
  [../]
  [./mean_en_log_stabilization]
    type = LogStabilizationMoles
    variable = mean_en
    offset = 14
  [../]
  # [./mean_en_advection_stabilization]
  #   type = EFieldArtDiff
  #   variable = mean_en
  #   potential = potential
  # [../]
[]

[Variables]
  [./potential]
  [../]
  [./em]
  [../]

  [./Arp]
  [../]

  [./mean_en]
  [../]
[]

[AuxVariables]
  [./e_temp]
  [../]
  [./x]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./rho]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./em_lin]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./Arp_lin]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./Efield]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./Current_em]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./Current_Arp]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./tot_gas_current]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./EFieldAdvAux_em]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./DiffusiveFlux_em]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./e_temp]
    type = ElectronTemperature
    variable = e_temp
    electron_density = em
    mean_en = mean_en
  [../]
  [./x]
    type = Position
    variable = x
  [../]
  [./rho]
    type = ParsedAux
    variable = rho
    args = 'em_lin Arp_lin'
    function = 'Arp_lin - em_lin'
    execute_on = 'timestep_end'
  [../]
  [./tot_gas_current]
    type = ParsedAux
    variable = tot_gas_current
    args = 'Current_em Current_Arp'
    function = 'Current_em + Current_Arp'
    execute_on = 'timestep_end'
  [../]
  [./em_lin]
    type = Density
    variable = em_lin
    density_log = em
  [../]
  [./Arp_lin]
    type = Density
    variable = Arp_lin
    density_log = Arp
  [../]
  [./Efield]
    type = Efield
    potential = potential
    variable = Efield
  [../]
  [./Current_em]
    type = Current
    potential = potential
    density_log = em
    variable = Current_em
    art_diff = false
  [../]
  [./Current_Arp]
    type = Current
    potential = potential
    density_log = Arp
    variable = Current_Arp
    art_diff = false
  [../]
  [./EFieldAdvAux_em]
    type = EFieldAdvAux
    potential = potential
    density_log = em
    variable = EFieldAdvAux_em
  [../]
  [./DiffusiveFlux_em]
    type = DiffusiveFlux
    density_log = em
    variable = DiffusiveFlux_em
  [../]
[]

[BCs]
  [./potential_left]
    type = NeumannCircuitVoltageMoles_KV
    variable = potential
    boundary = left
    function = potential_bc_func
    ip = Arp
    data_provider = data_provider
  [../]
  [./potential_dirichlet_right]
    type = DirichletBC
    variable = potential
    boundary = right
    value = 0
  [../]
  [./em_left]
    type = DCElectronBC
    variable = em
    boundary = left
    potential = potential
    ip = Arp
  [../]
  [./em_right]
    type = HagelaarAnodicBC
    variable = em
    boundary = right
    potential = potential
    mean_en = mean_en
    r = 0.9999
  [../]
  # [./em_right]
  #   type = DCIonBC
  #   variable = em
  #   boundary = right
  #   potential = potential
  # [../]
  [./Arp_physical]
    type = DCIonBC
    variable = Arp
    boundary = 'left right'
    potential = potential
  [../]
  [./mean_en_bc_left]
    type = DCIonBC
    variable = mean_en
    boundary = 'left'
    potential = potential
  [../]
  [./mean_en_bc_right]
    type = GradMeanEnZeroBC
    variable = mean_en
    boundary = 'right'
    potential = potential
    em = em
  [../]
[]

[ICs]
  # [./em_ic]
  #   type = RandomIC
  #   variable = em
  #   min = -18
  #   max = -17
  # [../]
  # [./Arp_ic]
  #   type = RandomIC
  #   variable = Arp
  #   min = -18
  #   max = -17
  # [../]
  # [./mean_en_ic]
  #   type = RandomIC
  #   variable = mean_en
  #   min = -16
  #   max = -15
  # [../]
  # [./potential_ic]
  #   type = RandomIC
  #   variable = potential
  #   min = -0.1
  #   max = 0
  # [../]
  [./em_ic]
    type = ConstantIC
    variable = em
    value = -22
  [../]
  [./Arp_ic]
    type = ConstantIC
    variable = Arp
    value = -22
  [../]
  [./mean_en_ic]
    type = ConstantIC
    variable = mean_en
    value = -21
  [../]
  # [./potential_ic]
  #   type = ConstantIC
  #   variable = potential
  #   value = 0
  # [../]
  [./potential_ic]
    type = FunctionIC
    variable = potential
    function = potential_ic_func
  [../]
[]

[Functions]
  [./potential_bc_func]
    type = ParsedFunction
    # value = '1.25*tanh(1e6*t)'
    value = 1.25
  [../]
  [./potential_ic_func]
    type = ParsedFunction
    value = '-1.25 * (.001-x)'
  [../]
[]

[Materials]
  [./gas]
    type = ArgonConstTD
    interp_trans_coeffs = false
    interp_elastic_coeff = true
    em = em
    potential = potential
    ip = Arp
    mean_en = mean_en
    block = 0
 [../]
[]