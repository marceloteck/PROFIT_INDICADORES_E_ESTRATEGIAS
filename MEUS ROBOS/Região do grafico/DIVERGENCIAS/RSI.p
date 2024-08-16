input
  LookbackRight(8);
  LookbackLeft(5);


var
  PivoBaixo: boolean;
  PivoAlto: boolean;
  RSivl : float;
  Divergnt : Inteiro;

inicio
  RSivl := RSI(14, 0);

 // Determinar pivôs de alta e baixa
  PivoBaixo := (Low < Low[LookbackLeft]) and (Low < Low[LookbackRight]);
  PivoAlto := (High > High[LookbackLeft]) and (High > High[LookbackRight]);

  se PivoAlto e (RSivl > RSivl[LookbackRight]) então Divergnt := 0 senão
  se PivoBaixo e (RSivl < RSivl[LookbackRight])  então Divergnt := 1
  senão Divergnt := 2;

  se Divergnt = 0 então PaintBar(clLime);
  se Divergnt = 1 então PaintBar(255);
  se Divergnt = 2 então PaintBar(clyellow);

fim;