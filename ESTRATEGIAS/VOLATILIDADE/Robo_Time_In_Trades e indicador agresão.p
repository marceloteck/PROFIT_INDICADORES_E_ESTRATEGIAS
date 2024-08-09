INPUT
  TempoGrafico(5);

VAR
  Dif, PMB, PMS, PrC, PrV : Float;
  SinalC, SinalV, StopC, Stopv : Boolean;

BEGIN
  PMB := PowerMeter(Osbuy, TempoGrafico);
  PMS := PowerMeter(OsSell, TempoGrafico);

  PrC := Round(PMB/(PMB+PMS)*100);
  PrV := Round(PMS/(PMB+PMS)*100);

  Dif := PrC-PrV;
  plot(Dif);

  SinalC := PrC > PrV;
  SinalV := PrV > PrC;

  StopC := SinalV;
  StopV :=  SinalC;

  se not HasPosition então
  inicio
     Se SinalC então 
     inicio
         BuyAtMarket;
         paintbar(clGreen);
         SetPlotColor(1, clGreen);
     fim;
     Se Sinalv então 
     Inicio
         SellShortAtMarket;
         PaintBar(255);
         SetPlotColor(1, 255);
     fim;
  fim;

 se HasPosition e StopC ou  HasPosition e  StopV então ClosePosition;

 se (IsBought) e (SinalV) então ReversePosition;
 se (IsSold) e (SinalC) então ReversePosition;

  
  
  

END;