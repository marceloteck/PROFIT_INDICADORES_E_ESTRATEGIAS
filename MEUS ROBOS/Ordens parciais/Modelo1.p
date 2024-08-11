BEGIN

  Se HasPosition então
     Inicio
         Se IsBought então
            Inicio
               //Se StopC então ClosePosition;
               SellToCoverLimit((BuyPrice)+(50*1),Round(BuyPosition*0.25));
               SellToCoverLimit((BuyPrice)+(50*2),Round(BuyPosition*0.50));
               SellToCoverLimit((BuyPrice)+(50*3),Round(BuyPosition*0.75));
            fim;

            Se IsSold então
            Inicio
               //Se StopV então ClosePosition;
                BuyToCoverLimit((SellPrice)-(50*1),Round(SellPosition*0.25));
                BuyToCoverLimit((SellPrice)-(50*2),Round(SellPosition*0.50));
                BuyToCoverLimit((SellPrice)-(50*3),Round(SellPosition*0.75));
            fim;

     fim;


END;