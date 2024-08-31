// Parâmetros da estratégia
input 
  Quantidade(1); // Quantidade de ações a ser comprada/vendida
  StopLoss(0.02); // Stop Loss em termos de percentual
  StopGain(0.05); // Stop Gain em termos de percentual

// Variáveis da estratégia
var
  Compra: Boolean;
  Venda: Boolean;
  PrecoStopLoss: Float;
  PrecoStopGain: Float;
  PosicaoAtual: Float;

  PrecoEntrada: float; 

Inicio
  // Condição de Compra: Exemplo de uma condição de compra
  Compra := (Media(9, Close) > Media(21, Close));

  // Condição de Venda: Exemplo de uma condição de venda
  Venda := (Media(9, Close) < Media(21, Close));

  // Verificar se há posição aberta
  PosicaoAtual := Position;

  // Lógica para executar ordens de compra e venda a mercado
  se not HasPosition então
    begin
      // Condição para abrir uma posição de compra
      se Compra então
        begin
          BuyAtMarket(Quantidade);
          PrecoEntrada := Close;
          PrecoStopLoss := PrecoEntrada * (1 - StopLoss);
          PrecoStopGain := PrecoEntrada * (1 + StopGain);
        end;

      // Condição para abrir uma posição de venda
      se Venda então
        begin
          SellShortAtMarket(Quantidade);
          PrecoEntrada := Close;
          PrecoStopLoss := PrecoEntrada * (1 + StopLoss);
          PrecoStopGain := PrecoEntrada * (1 - StopGain);
        end;
    end
  // Lógica para gerenciamento de stops para posição de compra
  else se IsBought então
    begin
      // Verificar Stop Gain
      se Close >= PrecoStopGain então
        begin
          SellToCoverAtMarket(Quantidade);
          Alert(clGreen); // Alerta de Stop Gain
        end;

      // Verificar Stop Loss
      se Close <= PrecoStopLoss então
        begin
          SellToCoverAtMarket(Quantidade);
          Alert(clRed); // Alerta de Stop Loss
        end;
    end
  // Lógica para gerenciamento de stops para posição de venda
  else se IsSold então
    begin
      // Verificar Stop Gain
      se Close <= PrecoStopGain então
        begin
          BuyToCoverAtMarket(Quantidade);
          Alert(clGreen); // Alerta de Stop Gain
        end;

      // Verificar Stop Loss
      se Close >= PrecoStopLoss então
        begin
          BuyToCoverAtMarket(Quantidade);
          Alert(clRed); // Alerta de Stop Loss
        end;
    end;

fim
