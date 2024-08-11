input
  Periodo(1);
var
 Candle_2m: float; 

inicio
 Candle_2m := (close - open) + (close[1] - open[1]) * Periodo;
                   

  plot(Candle_2m);

  se (Candle_2m > 0) entao SetPlotColor(1, clGreen) senão
  se (Candle_2m < 0) entao SetPlotColor(1, 255);

fim;