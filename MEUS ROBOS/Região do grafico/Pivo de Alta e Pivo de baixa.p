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

VAR
  PivoAtivo : Float;
  Acum : Float;
  i : Inteiro;

BEGIN
  // ----------------------------------------------------------------------------
  // Armazenagem dos valores retornados do respectivo array
  // ----------------------------------------------------------------------------

  // Pivots
  PivoAtivo := DivergenceDetector(CandlesEsquerda, CandlesDireita);


  // ----------------------------------------------------------------------------
  // Plotagem / Regra de coloração baseadas no Indicador
  // ----------------------------------------------------------------------------

  // Plotagem de cada uma das divergencias de forma separada
  plot(PivoAtivo);


  // Regra de coloração
  Se PivoAtivo > 0 então PaintBar(255) Senão
  Se PivoAtivo < 0 então PaintBar(ClLime);

END;