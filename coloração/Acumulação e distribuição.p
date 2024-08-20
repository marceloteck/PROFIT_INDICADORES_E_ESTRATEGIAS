// Parâmetros de entrada
input
  PeriodoMediaAccuDistr(102); // Período da média móvel

// Variáveis
var
  nAcc: float; // Valor do indicador de Acumulação/Distribuição
  MediaAcc: float; // Média móvel do indicador de Acumulação/Distribuição

begin
  // Obter o valor do indicador de Acumulação/Distribuição
  nAcc := AccuDistr;

  // Calcular a média móvel de 34 períodos do indicador de Acumulação/Distribuição
  MediaAcc := Media(PeriodoMediaAccuDistr, nAcc);

  // Condições de coloração das barras
  if (nAcc > MediaAcc) then
    PaintBar(clGreen) // Tendência de alta
  else
    PaintBar(clRed); // Tendência de baixa
end;
