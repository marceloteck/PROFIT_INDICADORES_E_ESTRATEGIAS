input
  Periodo(1);
var
 Candle: float; 

inicio
 Candle := (close - open) + (close[1] - open[1]) * Periodo;
                   

  plot(Candle);

  se (Candle > 0) entao SetPlotColor(1, clGreen) senão
  se (Candle < 0) entao SetPlotColor(1, 255);

fim;