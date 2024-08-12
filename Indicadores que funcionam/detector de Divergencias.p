{
   Configurações do indicador nativo para bater com o personalizado:
   Não - Exibir divergencias escondidas
   sim - Verificar Rompimento dos indicadores

   O valor dos pivots é retornado pela "Linha 0" do indicador;
   já o valor das divergencias dos demais indicadores é retornado pela "linha 1" ( |1| );

     OBS:
         - Quando se seinaliza todas as divergencias o indicador nativo não sinaliza todas elas ...
         Isso se percebe atraves da sinalização de cada uma das divergencias de forma separada e de quando flega todas elas de uma vez.
}
INPUT
   CandlesEsquerda(5);
   CandlesDireita(5);
   Todos(False);
   ExibirPivots(False);
   Macd(True);
   MacdHistograma(True);
   RSI(True);
   Estocastico(True);
   CCI(True);
   Momentum(True);
   OBV(True);
   Diosc(True);
   VwMacd(True);
   ChaikinMoneyFlow(True);
   MoneyFlowIndex(True);
VAR
  DivDetArray : Array [1..13] of Float;
  Acum : Float;
  i : Inteiro;

BEGIN
  // ----------------------------------------------------------------------------
  // Armazenagem dos valores retornados do respectivo array
  // ----------------------------------------------------------------------------

  // Pivots
  Se ExibirPivots então DivDetArray[1] := DivergenceDetector(CandlesEsquerda, CandlesDireita);
  // Macd
  Se MACD então DivDetArray[2] := DivergenceDetector(CandlesEsquerda, CandlesDireita, True)|1|;
  // Macd Histograma
  Se MacdHistograma então DivDetArray[3] := DivergenceDetector(CandlesEsquerda, CandlesDireita, False, True)|1|;
  // RSI
  Se RSI então DivDetArray[4] := DivergenceDetector(CandlesEsquerda, CandlesDireita, False, False, True)|1|;  
  // Estocastico
  Se Estocastico então DivDetArray[5] := DivergenceDetector(CandlesEsquerda, CandlesDireita, False, False, False, True)|1|;
  // CCI
  Se CCI então DivDetArray[6] := DivergenceDetector(CandlesEsquerda, CandlesDireita, False, False, False, False, True)|1|;
  // Momentum
  Se Momentum então DivDetArray[7] := DivergenceDetector(CandlesEsquerda, CandlesDireita, False, False, False, False, False, True)|1|;
  // obv
  Se OBV então DivDetArray[8] := DivergenceDetector(CandlesEsquerda, CandlesDireita, False, False, False, False, False, False, True)|1|;
  // Diosc
  Se Diosc então DivDetArray[9] := DivergenceDetector(CandlesEsquerda, CandlesDireita, False, False, False, False, False, False, False, True)|1|;
  // VwMacd
  Se VwMacd então DivDetArray[10] := DivergenceDetector(CandlesEsquerda, CandlesDireita, False, False, False, False, False, False, False, False, True)|1|;
  // Chaikin Money Flow
  Se ChaikinMoneyFlow então DivDetArray[11] := DivergenceDetector(CandlesEsquerda, CandlesDireita, False, False, False, False, False, False, False, False, False, True)|1|;
  // MoneyFlowIndex
  Se MoneyFlowIndex então DivDetArray[12] := DivergenceDetector(CandlesEsquerda, CandlesDireita, False, False, False, False, False, False, False, False, False, False, True)|1|;
  // TODOS
  Se Todos então DivDetArray[13] := DivergenceDetector(CandlesEsquerda, CandlesDireita, True, True, True, True, True, True, True, True, True, True, True)|1|;

  // ----------------------------------------------------------------------------
  // Plotagem / Regra de coloração baseadas no Indicador
  // ----------------------------------------------------------------------------

  // Calculo do total de divergencias de cada candle
  Acum := 0; // Zeragem da variavel de acumulo p/ que la seja recontada em todos os Candles
  For i := 1 to 12 do Acum := Acum + DivDetArray[i];
  Plot15(Acum);

  // Plotagem de cada uma das divergencias de forma separada
  For i := 1 to 13 do PlotN(i, DivDetArray[1]);


  // Regra de coloração
  Se Acum > 0 então PaintBar(255) Senão
  Se Acum < 0 então PaintBar(ClLime);

END;