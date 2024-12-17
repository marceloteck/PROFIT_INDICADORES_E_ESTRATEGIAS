INPUT
     Media1(9);
     Media2(20);
     Media3(50);

     DistanciaMedia(20.00);

VAR
     Dist, Atr, m1, m2, m3 : Float;

     COMPRAR, VENDER, STOPC, STOPV : Boolean;

     CONS : Boolean;

BEGIN
     Atr := AvgTrueRange(10, 0);

     m1 := Media(media1, Close);
     m2 := Media(media2, Close);
     m3 := Media(media3, Close);

     Dist := Abs(m1-m2);

     CONS :=  (Dist < DistanciaMedia);

     COMPRAR := (m1 > m2) e (m2 > m3) e not CONS  e (Atr < 100); 
     VENDER  := ( m1 < m2) e (m2 < m3) e not CONS  e (Atr < 100);

     STOPC := VENDER ou not COMPRAR;
     STOPV := COMPRAR ou not VENDER;

     se COMPRAR e not HasPosition então BuyAtMarket;
     se VENDER e not HasPosition então SellShortAtMarket;

     se STOPC e IsBought então SellToCoverAtMarket;
     se STOPV e IsSold então BuyAtMarket;

     se COMPRAR então PaintBar(clgreen) senão
     se VENDER então PaintBar(clred) senão
     PaintBar(clFucsia);
END;










{
     v1
}
{
INPUT
     Media1(9);
     Media2(20);
     Media3(50);

VAR
     Atr, m1, m2, m3 : Float;

     COMPRAR, VENDER, STOPC, STOPV : Boolean;

BEGIN
     Atr := AvgTrueRange(10, 0);

     m1 := Media(media1, Close);
     m2 := Media(media2, Close);
     m3 := Media(media3, Close);

     COMPRAR := (m1 > m2) e (m2 > m3); 
     VENDER  := ( m1 < m2) e (m2 < m3);

     STOPC := VENDER ou not COMPRAR;
     STOPV := COMPRAR ou not VENDER;

     se COMPRAR e not HasPosition e (Atr < 100) então BuyAtMarket;
     se VENDER e not HasPosition e (Atr < 100) então SellShortAtMarket;

     se STOPC e IsBought então SellToCoverAtMarket;
     se STOPV e IsSold então BuyAtMarket;

     se COMPRAR então PaintBar(clgreen) senão
     se VENDER então PaintBar(clred) senão
     PaintBar(clFucsia);
END;
}