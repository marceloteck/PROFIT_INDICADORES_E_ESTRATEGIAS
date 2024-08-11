INPUT
   Desvio(1.60);
   mediaB(20);
   Alvo(1.0);
VAR
   BolCh_C : Float;
   BolCh_V : Float;
   StopC : Float;
   StopV : Float;

INICIO
   BolCh_C  :=  BollingerBands(Desvio, mediaB, 1)|1|; // Banda Inferior
   BolCh_V  :=  BollingerBands(Desvio, mediaB, 1)|0|; // Banda Superior


   Se (IsSold) então
       Inicio
           // ALVO
           BuyToCoverLimit(SellPrice-(Abs(SellPrice-StopV)*Alvo), 1);
           {
             preço de entrada - (tamanho do candle atual * alvo de ganho)
           }

           // STOP
           BuyToCoverStop(StopV, StopV);

       Fim;
   Se (IsBought) então
       Inicio
           // ALVO
           BuyToCoverLimit(SellPrice+(Abs(SellPrice+StopV)*Alvo), 1);

           // STOP
           SellToCoverStop(StopC, StopC);

       fim;

   Se not HasPosition então
       Inicio
           // Condição de compra
           Se (FECHAMENTO[1] > BolCh_V) e (FECHAMENTO < BolCh_V) então
              Inicio
                 SellShortStop(Minima-MinPriceIncrement, Minima-MinPriceIncrement, 1);
                 StopV := Maxima+MinPriceIncrement;
              Fim;

           // Condição de venda
           Se (FECHAMENTO[1] < BolCh_C) e (FECHAMENTO > BolCh_C) então
              Inicio
                  BuyStop(Maxima+MinPriceIncrement, Maxima+MinPriceIncrement, 1);
                 StopC := Minima-MinPriceIncrement;
              fim;      
       fim;
FIM;

{
MinPriceIncrement -> codigo que define um tick do ativo correspoendente.
como no indice é 5 pontos,
e no dolar é 0.5 pontos
}