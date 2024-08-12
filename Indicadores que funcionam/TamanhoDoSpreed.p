input
  Periodo(1);
var
 Candle_1m, Candle_2m, Candle_5m: float;
 Contador_5m : inteiro;

inicio
  
  FOR Contador_5m := 1 TO  5 DO
    INICIO
       Candle_5m := (close[Contador_5m]-open[Contador_5m]); 
    FIM;  


    Candle_1m := (close - open) * Periodo; 
    Candle_2m := (close - open) + (close[1] - open[1]) * Periodo; 
    Candle_5m := (close-open)+Candle_5m;               

  plot(Candle_1m);

  se (Candle_1m > 0) entao SetPlotColor(1, clGreen) senão
  se (Candle_1m < 0) entao SetPlotColor(1, 255);


  se Candle_5m < Candle_1m então SetPlotColor(1, clBlue);


fim;