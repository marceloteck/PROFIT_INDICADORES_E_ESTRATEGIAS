// Definir variáveis e parâmetros
input 
  PeriodoRSI(9);

var
 RSIValor: float;

 Inicio
// Calcular RSI
RSIValor := RSI(PeriodoRSI, 0);


// Condições de Coloração
Se (RSIValor > 50) então
    PaintBar(clGreen) // RSI acima de 50% - Tendência de alta

senão se (RSIValor < 50) então
    PaintBar(clRed); // RSI abaixo de 50% - Tendência de baixa


fim