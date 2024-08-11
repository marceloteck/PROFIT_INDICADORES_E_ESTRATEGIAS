INPUT
   Periodo(10);
   Deslocamento(0);

VAR
   A, B, mMin, mMax : Float;
   Topo, Fundo, MediaL : Float;
   Return, validade : Inteiro;

BEGIN
/////////////////////// INDICADOR /////////////////////////
   A := Highest(HIGH, periodo)[Deslocamento];
   B := Lowest(low, periodo)[Deslocamento];

   Se (Minima > Minima[1]) e (Minima[1] <= Minima[2]) então // (Maxima > Maxima[1]) então
       mMin := Minima[1];

       Se (B >= mMin) então
           Fundo := mMIn;

   Se (Maxima < Maxima[1]) e (Maxima[1] >= Maxima[2]) então
       mMax := Maxima[1];

       Se (A <= mMax) então
           Topo := mMax;

    plot(Topo);                  
    SetPlotColor(1, clgreen);

    plot2(Fundo);
    SetPlotColor(2, clMaroon);

END;