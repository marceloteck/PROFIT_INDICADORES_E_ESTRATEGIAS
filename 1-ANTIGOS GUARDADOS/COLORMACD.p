// Definir variáveis e parâmetros
input 
  MediaLonga(34);
  MediaCurta(19);
  Sinal(34);

var
  MACD_Linha: float;
  MACD_Histograma: float;
  MACD_MediaM: float;

Inicio
  // Calcular MACD
  MACD_Linha := MACD(MediaLonga, MediaCurta, Sinal)|0|;
  MACD_Histograma := MACD(MediaLonga, MediaCurta, Sinal)|1|;

  // Calcular Média Móvel do Sinal do MACD
  MACD_MediaM := MediaExp(Sinal, MACD_Linha);

  // Condições de Coloração e Execução de Ordens
  Se (MACD_Histograma > 0) e (MACD_Linha > MACD_MediaM) então
    PaintBar(clGreen) // Tendência de alta - Histograma acima de 0 e linha MACD acima de 0
  senão se (MACD_Histograma < 0) e (MACD_Linha < MACD_MediaM) então
    PaintBar(clRed); // Tendência de baixa - Histograma abaixo de 0 e linha MACD abaixo de 0
fim
