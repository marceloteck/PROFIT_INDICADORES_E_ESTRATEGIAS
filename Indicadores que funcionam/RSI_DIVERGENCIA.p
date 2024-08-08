input
  // Parâmetros do RSI
  Preco(close);
  PeriodoRSI(9);
  // Lookback para pivôs
  LookbackRight(5);
  LookbackLeft(5);
  MaxLookbackRange(60);
  MinLookbackRange(5);

var
  // Variáveis do RSI
  RSIValor: float;
  RSIValores: array[0..59] of float; // Array para armazenar valores do RSI para lookback
  i: integer;
  PivoBaixo: boolean;
  PivoAlto: boolean;
  OscHL: boolean;
  OscLH: boolean;
  PriceLL: boolean;
  PriceHL: boolean;
  PriceHH: boolean;
  PriceLH: boolean;
  BullCond: boolean;
  HiddenBullCond: boolean;
  BearCond: boolean;
  HiddenBearCond: boolean;

Inicio
  // Calcular o valor do RSI
  RSIValor := RSI(PeriodoRSI, 0);

  // Armazenar o valor do RSI no array de valores
  for i := 59 downto 1 do
    RSIValores[i] := RSIValores[i-1];
  RSIValores[0] := RSIValor;

  // Determinar pivôs
  PivoBaixo := (RSIValor < RSIValores[LookbackLeft]) and (RSIValor < RSIValores[LookbackRight]);
  PivoAlto := (RSIValor > RSIValores[LookbackLeft]) and (RSIValor > RSIValores[LookbackRight]);

  // Condições de divergências
  OscHL := (RSIValores[LookbackRight] > RSIValores[LookbackRight + 1]) and (LookbackRight >= MinLookbackRange) and (LookbackRight <= MaxLookbackRange);
  OscLH := (RSIValores[LookbackRight] < RSIValores[LookbackRight + 1]) and (LookbackRight >= MinLookbackRange) and (LookbackRight <= MaxLookbackRange);
  PriceLL := (Low < Low[LookbackRight + 1]);
  PriceHL := (Low > Low[LookbackRight + 1]);
  PriceHH := (High > High[LookbackRight + 1]);
  PriceLH := (High < High[LookbackRight + 1]);

  // Condições de compra e venda
  BullCond := PriceLL and OscHL and PivoBaixo;
  HiddenBullCond := PriceHL and OscLH and PivoBaixo;
  BearCond := PriceHH and OscLH and PivoAlto;
  HiddenBearCond := PriceLH and OscHL and PivoAlto;

  // Colorir barras de acordo com as condições
//  if BullCond then
 //   PaintBar(clRed)
 // else if HiddenBullCond then
  //  PaintBar(clGreen)
 // else if BearCond then            
 ///   PaintBar(clLime)
 // else if HiddenBearCond then
 //   PaintBar(clMaroon)
//  else
//    PaintBar(clwhite);      
                                                
  // Plotar o RSI                       
  SetPlotWidth(1,2);
  SetPlotColor(1, clFuchsia);                              
  Plot(RSIValor);

  SetPlotWidth(4,1);
  SetPlotStyle(4, 1);

  SetPlotWidth(2,1);
  SetPlotWidth(3,1);

  // Linhas horizontais de sobrecompra e sobrevenda
  //Plot2(70);
  //Plot3(30);
  Plot4(50);
 // plot5(mediaexp(34, RSIValor));
  //SetPlotColor(5, clwhite);           
                                             
  
   se (RSIValor >= 70) então
    PaintBar(clYellow)
  senão                             
  se (RSIValor <= 30) então
    PaintBar(clLime);


Fim
