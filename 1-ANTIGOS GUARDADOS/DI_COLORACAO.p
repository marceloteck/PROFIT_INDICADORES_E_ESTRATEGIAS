// Definir variáveis e parâmetros
input 
  PeriodoDI(14);

var
  RSIValor: float;
  DIPlus: float;
  DIMinus: float;

Inicio

  // Calcular DI
  DIPlus := DiPDiM(PeriodoDI)|0|;
  DIMinus := DiPDiM(PeriodoDI)|1|;

  // Condições de Coloração com DI
  Se (DIPlus > DIMinus) então
      PaintBar(clLime) // DI+ acima de DI- - Tendência de alta
  senão se (DIPlus < DIMinus) então
      PaintBar(clRed); // DI- acima de DI+ - Tendência de baixa

 fim


              
          