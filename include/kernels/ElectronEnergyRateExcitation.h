#ifndef ELECTRONENERGYRATEEXCITATION_H
#define ELECTRONENERGYRATEEXCITATION_H

#include "Kernel.h"

class ElectronEnergyRateExcitation;

template<>
InputParameters validParams<ElectronEnergyRateExcitation>();

class ElectronEnergyRateExcitation : public Kernel
{
public:
  ElectronEnergyRateExcitation(const InputParameters & parameters);
  virtual ~ElectronEnergyRateExcitation();

protected:

  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

  const MaterialProperty<Real> & _kex;
  const MaterialProperty<Real> & _d_kex_d_actual_mean_en;
  const MaterialProperty<Real> & _Eex;

  const VariableValue & em;
  unsigned int _em_id;
};


#endif /* ELECTRONENERGYRATEEXCITATION_H */
