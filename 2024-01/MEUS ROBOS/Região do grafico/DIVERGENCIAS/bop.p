input
  LookbackRight(8);
  LookbackLeft(5);


var
  PivoBaixo: boolean;
  PivoAlto: boolean;
  DivergntBOP : Inteiro;

  BOP_vl : float;

inicio
  BOP_vl := BalanceOfPower(14, 0);

 // Determinar pivôs de alta e baixa
  PivoBaixo := (Low < Low[LookbackLeft]) and (Low < Low[LookbackRight]);
  PivoAlto := (High > High[LookbackLeft]) and (High > High[LookbackRight]);


  se PivoAlto e (BOP_vl > BOP_vl[LookbackRight]) então DivergntBOP := 0 senão
  se PivoBaixo e (BOP_vl < BOP_vl[LookbackRight])  então DivergntBOP := 1
  senão DivergntBOP := 2;

  se DivergntBOP = 0 então PaintBar(clLime);
  se DivergntBOP = 1 então PaintBar(255);
  se DivergntBOP = 2 então PaintBar(clyellow);

fim;