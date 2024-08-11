INPUT
     BBDesvio(2.00);
     BBPeriodo(20);
     BBTipo(0);

     KDesvio(2.00);
     KPeriodo(20);
     KTipo(0);

VAR
     Atr, BBSup, BBInf, KSup, KInf : Float;
     SinalCons : Boolean;

BEGIN

     Atr := AvgTrueRange(10, 0);

     BBSup := BollingerBands(BBDesvio, BBPeriodo, BBTipo)|0|;
     BBInf := BollingerBands(BBDesvio, BBPeriodo, BBTipo)|1|;

     KSup := KeltnerCh(KDesvio, KPeriodo, KTipo)|0|;
     KInf := KeltnerCh(KDesvio, KPeriodo, KTipo)|1|;

     SinalCons := (BBSup < KSup) e (BBInf > KInf) e (Atr < 100);

     se SinalCons então PaintBar(clFucsia);


END;
