input
  LookbackRight(8);
  LookbackLeft(5);


var
  PivoBaixo: boolean;
  PivoAlto: boolean;
  RSivl : float;
  DivergntRSI, DivergntBOP : Inteiro;

  BOP_vl : float;
  ValidatAlta, ValidateBaixa, DivgMov : Boolean;

inicio
  RSivl := RSI(14, 0);
  BOP_vl := BalanceOfPower(14, 0);

 // Determinar pivôs de alta e baixa
  PivoBaixo := (Low < Low[LookbackLeft]) and (Low < Low[LookbackRight]);
  PivoAlto := (High > High[LookbackLeft]) and (High > High[LookbackRight]);

  se PivoAlto e (RSivl > RSivl[LookbackRight]) então DivergntRSI := 0 senão
  se PivoBaixo e (RSivl < RSivl[LookbackRight])  então DivergntRSI := 1
  senão DivergntRSI := 2;


  se PivoAlto e (BOP_vl > BOP_vl[LookbackRight]) então DivergntBOP := 0 senão
  se PivoBaixo e (BOP_vl < BOP_vl[LookbackRight])  então DivergntBOP := 1
  senão DivergntBOP := 2;

  ValidatAlta   := (DivergntBOP = 0) e (DivergntRSI = 0);
  ValidateBaixa := (DivergntBOP = 1) e (DivergntRSI = 1);
  DivgMov       := (DivergntBOP = 2) e (DivergntRSI = 2);

  Se ValidatAlta    então PaintBar(clLime);
  Se ValidateBaixa  então PaintBar(255);
  Se DivgMov        então PaintBar(clyellow);



fim;