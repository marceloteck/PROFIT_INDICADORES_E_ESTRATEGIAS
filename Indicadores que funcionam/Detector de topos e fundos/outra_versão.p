// #######################################################################
// #######################################################################
// #######################################################################
// ######                            O                             #######
// ######                        ____|____                         #######
// ######                      _|         |_                       #######
// ######                     (_|  O   O  |_)                      #######
// ######                       |_________|                        #######
// ######                                                          #######
// ###### ____        __        ____________           ________    #######
// ###### | | \       | |       | |_________|         /  ____  \   #######
// ###### | |\ \      | |       | |                  /  /    \  \  #######
// ###### | | \ \     | |       | |____             |  |      |  | #######
// ###### | |  \ \    | |       | |____|            |  |      |  | #######
// ###### | |   \ \   | |       | |____|            |  |      |  | #######
// ###### | |    \ \  | |       | |                 |  |      |  | #######
// ###### | |     \ \ | |       | |_________         \  \____/  /  #######
// ###### |_|      \_\|_|       |_|_________|         \________/   #######
// ######                                                          #######
// ###### _______  __          __   ____  __   ___    __  _______  #######
// ######    |    |  \   /\   |  \ |     |  \ |   \  /  \    |     #######
// ######    |    |__/  /__\  |   ||__   |__/ |___/ |    |   |     #######
// ######    |    |\   /    \ |   ||     |\   |   \ |    |   |     #######
// ######    |    | \ /      \|__/ |____ | \  |___/  \__/    |     #######
// ######                                                          #######
// ######  Comunidade aberta de automatização de estratégias para  #######
// ######                    negociação de ativos                  #######
// ######                                                          #######
// ######                    www.NeoTraderBot.com                  #######
// #######################################################################
// #######################################################################
// #######################################################################
//
// -----------------------------------------------------------------------
// ---------------------- DADOS DA ESTRATÉGIA ----------------------------
// -----------------------------------------------------------------------
//
// NOME DA ESTRATÉGIA: _NTB_TopBottomDetector_Breakout
//   DESENVOLVIDA POR: Johnathas Carvalho
//    DATA DE CRIAÇÃO: 14/02/2023
//             VERSÃO: 1.0
//      ATUALIZADA EM: 14/02/2023
// TIPO DE ESTRATÉGIA: (X) Indicador  (X) Coloração ( ) Execução
//                     ( ) Screening  (X) Texto     ( ) Alarme
//
// DESCRIÇÃO DA ESTRATÉGIA:
//    Este é um indicador inspirado na lógica do indicador nativo do Profit
// Chart para detecção de topos e fundos que se baseia no rompimento da máxima
// ou mínima de um candle de referência.
// A estratégia possui 3 saídas. Linha 1 apresenta valor diferente de zero 
// quando há uma confirmação de topo/fundo. Linha 2 é o valor de topo atual 
// e linha 3 é o valor de fundo atual.


// -----------------------------------------------------------------------
// -----------------------------------------------------------------------
// -----------------------------------------------------------------------
//
// ######################### FIM DO CABEÇALHO ############################
//


//
// ---------------------------------------------------------------------
// -------------------------- Parâmetros -------------------------------
// OBS: Segue abaixo a descriação de cada parâmetro
// 1) pQtdeRompimentos -> Refere-se a quantidade de rompimentos necessários
// para confirmar um topo ou fundo. Ex: se o candle de referência de um 
// possível topo tem o valor de mínima igual a X. Somente após ocorrem pQtdeRompimentos
// barras com valor de mínimo menor que X é que o candle de referência será
// confirmado como topo.
// Como o valor mínimo dos candles subsequentes podem ficar abaixo do último
// topo identificado antes dessa condição. O candle de referência também será
// confirmado como topo se a condição de rompimento não for atendida e o valor
// mínimo do candle atual for menor que o último fundo.
//
// 2) pAtualizarReferenciaRompimento -> Se true, uma vez rompido o candle de referencia, o novo
// valor de máxima ou mínima será atualizado para verificação do próximo rompimento. Caso false,
// a referência de rompimento será mantida fixa para avaliação dos rompimentos.
//
// 3) pModoPlot -> Configura se e como as séries de confirmação, topo e fundo serão plotadas
//    pModoPlot = 0: Não realiza plots de topo/fundo, apenas confirmação        
//    pModoPlot = 1: Plota o útimo topo/fundo confirmado, bem como topo/fundo em detecção
//    pModoPlot = 2: Plota apenas o topo/fundo a ser confirmado
//                   
// 4) pExibirTextoConfirmacao -> Configura exibição de texto de confirmação de topo/fundo 
// ---------------------------------------------------------------------

input
  pQtdeRompimentos(2);
  pAtualizarReferenciaRompimento(false);
  pModoPlot(1);
  pExibirTextoConfirmacao(true); 
  // ---------------------------------------------------------------------
  // ---------------------- Variáveis globais ----------------------------
  // ---------------------------------------------------------------------
var
  iIdentUltimaBarraIdentificada : integer;
  fMaximoAtual,fMinimoAtual : float;
  fMinimoRefRomp, fMaximoRefRomp, fManimoRefRomp: float;
  iMaximoAtual, iMinimoAtual: integer;
  fVolatilidadeMedia: float;
  fTopoFundoConfirmado: float;
  iContadorRompimentos: integer;

begin
  

  // ---------------------------------------------------------------------
  // ------------ Atribuição de variáveis por processamento --------------
  // ---------------------------------------------------------------------
  // Manutenção de valor da variável entre processamentos da estratégia
  // O comportamento de retenção de valor das variáveis tem sofrido alterações não previsiveis
  // nas últimas atualizações do Profit
  fMaximoAtual := fMaximoAtual[1];
  fMinimoAtual := fMinimoAtual[1];
  fMaximoRefRomp := fMaximoRefRomp[1];
  fMinimoRefRomp := fManimoRefRomp[1];
  iContadorRompimentos := iContadorRompimentos[1];
  fTopoFundoConfirmado := fTopoFundoConfirmado[1];
  iIdentUltimaBarraIdentificada := iIdentUltimaBarraIdentificada[1];

  // ---------------------------------------------------------------------
  // --------------------- Cálculo do indicador  -------------------------
  // OBS: Inserir lógica de cálculo do indicador e caso ele possa ser plo_
  // tado, atribuir em algum momento True para variável bPlotIndicador
  // ---------------------------------------------------------------------

  // Inicialização do algoritmo quando tem dados suficientes
  if CurrentBar = 1 then
    begin
      fMaximoAtual := High[1];
      fMinimoAtual := Low[1];
      fMaximoRefRomp := High[1];
      fMinimoRefRomp := Low[1];
      iMaximoAtual := CurrentBar;
      iMinimoAtual := CurrentBar;
      iIdentUltimaBarraIdentificada := -1*(CurrentBar-1);
    end
  else
    begin
      iMaximoAtual := iMaximoAtual[1];
      iMinimoAtual := iMinimoAtual[1];
    end;


  // Algoritmo inicia execução
  // Última confirmação do indicador foi um topo
  // Esse trecho deve tentar identificar um fundo
  if (iIdentUltimaBarraIdentificada > 0) then
    begin
      // Atualiza o valor mínimo atual
      if Low < fMinimoAtual then 
      begin
        fMinimoAtual := Low;  
        iMinimoAtual := CurrentBar;
        fMaximoRefRomp := High;
        iContadorRompimentos := 0;
      end;

      if pAtualizarReferenciaRompimento then
      begin
        if High > fMaximoRefRomp then
        begin
          fMaximoRefRomp := High;
          iContadorRompimentos := iContadorRompimentos + 1;
        end;
      end
      else  
        if High > High[CurrentBar-iMinimoAtual] then iContadorRompimentos := iContadorRompimentos + 1;


      // Verifica se houve pQtdeRompimentos do valor máximo da barra de referencia
      // A barra de referência é aquela com o menor valor mínimo até o momento
      if (iContadorRompimentos = pQtdeRompimentos) 
      // Ou volatilidade da barra excedeu o range anterior entre topos e fundos
      or (High > fMaximoAtual)
      then
      begin
        // Plota o fundo identificado, atualiza o índice da barra de fundo com valor negativo (economia de memória)
        // e estabelece um valor inicial para o máximo atual
        fTopoFundoConfirmado := fMinimoAtual;
        plot(fTopoFundoConfirmado);
        iIdentUltimaBarraIdentificada := -1*CurrentBar;
        fMaximoAtual := High;
        iMaximoAtual := CurrentBar;
        fMinimoRefRomp := Low;
        //PaintBar(clGreen);
        if pExibirTextoConfirmacao then PlotText(fTopoFundoConfirmado,clGreen,-1,9);
        iContadorRompimentos := 0;
      end;
    end

  // Última confirmação do indicador foi um fundo
  // Esse trecho deve tentar identificar um topo
  else
  begin
    // Atualiza o valor máximo atual
    if High > fMaximoAtual then 
    begin
      fMaximoAtual := High;
      iMaximoAtual := CurrentBar;
      fMinimoRefRomp := Low;
      iContadorRompimentos := 0;
    end;

    if pAtualizarReferenciaRompimento then
    begin
      if Low < fMinimoRefRomp then
      begin
        fMinimoRefRomp := Low;
        iContadorRompimentos := iContadorRompimentos + 1;
      end;
    end
    else 
      if Low < Low[CurrentBar-iMaximoAtual] then iContadorRompimentos := iContadorRompimentos + 1;

    // Verifica se houve pQtdeRompimentos do valor máximo da barra de referencia
    // A barra de referência é aquela com o menor valor mínimo até o momento      
    if (iContadorRompimentos = pQtdeRompimentos) 
    // Ou volatilidade da barra excedeu o range anterior entre topos e fundos
    or (Low < fMinimoAtual)
    then
    begin                                                          
      // Plota o topo identificado, atualiza o índice da barra de topo com valor positivo (economia de memória)
      // e estabelece um valor inicial para o mínimo atual
      fTopoFundoConfirmado := fMaximoAtual;
      plot(fTopoFundoConfirmado);
      iIdentUltimaBarraIdentificada := CurrentBar;
      fMinimoAtual := Low;
      iMinimoAtual := CurrentBar;
      fMaximoRefRomp := High;
      //PaintBar(clRed);
      if pExibirTextoConfirmacao then PlotText(fTopoFundoConfirmado,clRed,-1,9);
      iContadorRompimentos := 0;
    end;
  end;


  //
  // ---------------------------------------------------------------------
  // ------------------ Plota valores do indicador -----------------------
  // OBS: A série de confirmação de topo/fundo (1) é plotada na lógica do indicador.
  // Abaixo são plotadas as séries de valor máximo e mínimo atual, séries 2 e 3, respectivamente.
  // ---------------------------------------------------------------------
  plot2(fMaximoAtual);
  plot3(fMinimoAtual);

  // Configura estilo dos plots 
  SetPlotWidth(1,2);
  SetPlotWidth(2,2);
  SetPlotWidth(3,2);
  SetPlotColor(2,clRed);
  SetPlotColor(3,clGreen);
  SetPlotStyle(2,psDash);
  SetPlotStyle(3,psDash);

  //Modo de uso para chamada em NTSL a partir de outras estratégias
  //Não plota nenhuma série no gráfico
  if pModoPlot = 0 then
  begin
    NoPlot(2);
    NoPlot(3);
  end;  
 
  //Plota topo/fundo confirmado e em detecção
  if pModoPlot = 1 then NoPlot(1);

  //Plota apenas o topo/fundo que está em detecção no momento, não plota confirmação
  if pModoPlot = 2 then
  begin
    NoPlot(1);
    //Buscando confirmação de fundo
    if iIdentUltimaBarraIdentificada > 0 then NoPlot(2)
    else NoPlot(3);
  end;

end;