INPUT
     AmplitudeMax(150.00);  // INDICE: 150.00
     VolMax(80.00); //INDICE: 80.00
     PeridoAmp(10);

VAR
     Amp, Atr : Float;


BEGIN

     Atr := AvgTrueRange(10, 0);

     Amp := Highest(high, PeridoAmp) - Lowest(low, PeridoAmp);

     se (Amp < AmplitudeMax) e (Atr < VolMax) então PaintBar(clFucsia)
     senão PaintBar(clwhite);

END;