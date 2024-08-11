INPUT
     VolumeDirecional(3); 

VAR
     VD, VP, VN : Float;
     SinalC, SinalV : Boolean;

BEGIN

     VD := VolumeDirecional * 1000000000;
     
     Se (close > open) então 
     inicio 
           VP := VP[1] + volume;
           VN := 0;
     fim;

     Se (close < open) então 
     inicio 
           VN := VN[1] + volume;
           VP := 0;
     fim;

     SinalC := (VN[1] > VD) e (close > open);
     SinalV := (VP[1] > VD) e (close < open);

     se SinalC então PaintBar(clgreen);
     se SinalV então PaintBar(255);

     se not HasPosition então
     inicio
           se SinalC então BuyAtMarket;
           se SinalV então  SellShortAtMarket;
     fim;

     plot(VP);
     plot2(VN);
     plot3(VD);

     SetPlotColor(1, clgreen);
     SetPlotColor(2, clred);
     SetPlotColor(3, claqua);

     //se IsBought então SellShortLimit(BuyPrice + 2);
     //se IsSold então BuyLimit(SellPrice -2);
     

END;