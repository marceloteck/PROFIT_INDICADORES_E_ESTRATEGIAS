INPUT
   Periodo(34);
   Deslocamento(0);

VAR
   A, B, mMin, mMax : Float;
   Topo, Fundo, MediaL : Float;
   Return, validade : Inteiro;

   PivoAlta, PivoBAixa : Boolean;

   MediaMovel : float;

BEGIN
/////////////////////// INDICADOR /////////////////////////

   MediaMovel := Media(34, close);
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

    


  PivoAlta := (Topo > Topo[1]) e not (fundo < Topo[1]);
  PivoBAixa := (Fundo < Fundo[1]) e not (Topo > Fundo[1]);


  se (not HasPosition) então
  Inicio
    se PivoAlta então BuyAtMarket;
    se PivoBAixa então SellShortAtMarket;
  fim;

  se (IsBought) e (minima <= fundo) ou IsSold e (maxima >= Topo) então ClosePosition;


   Se PivoAlta  então paintbar(ClLime);
   Se PivoBAixa  então paintbar(Clred) ;


END;

{
 PIVO VALIDOS
 EM TESTE *************

}

{
   INPUT
   Periodo(34);
   Deslocamento(0);

VAR
   A, B, mMin, mMax : Float;
   Topo, Fundo, MediaL : Float;
   Return, validade : Inteiro;

   PivoAlta, PivoBAixa : Boolean;

   MediaMovel, Mdia12, dif : float;

BEGIN
/////////////////////// INDICADOR /////////////////////////

   MediaMovel := Media(34, close);
   Mdia12 := media(12, close);
   dif := Abs(MediaMovel - Mdia12);

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

    


  PivoAlta := (Topo > Topo[1]) e not (fundo < Topo[1]) e not (dif <= 30) e not (close <  Mdia12);
  PivoBAixa := (Fundo < Fundo[1]) e not (Topo > Fundo[1]) e not (dif <= 30)e not (close >  Mdia12);


  se (not HasPosition) então
  Inicio
    se PivoAlta então BuyAtMarket;
    se PivoBAixa então SellShortAtMarket;
  fim;

  se (IsBought) então
  Inicio
      se PivoAlta ou (close < MediaMovel) então ClosePosition;
  fim;


  se IsSold então
  inicio
      se PivoBAixa ou (close > MediaMovel) então ClosePosition;
  fim;


   Se PivoAlta  então paintbar(ClLime);
   Se PivoBAixa  então paintbar(Clred) ;





END;

{
 PIVO VALIDOS
 EM TESTE *************

}
}