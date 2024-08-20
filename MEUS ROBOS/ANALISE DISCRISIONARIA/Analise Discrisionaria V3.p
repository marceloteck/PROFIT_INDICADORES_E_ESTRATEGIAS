INPUT
   AlvoFixo(False);
   TamanhoDoAlvoPts(0);
   TamanhoDoStopPts(0); 
   PermitirGradienteLinear(True);
   LimiteDeContratos(10);
   EntradaMinimaContratos(2);

   HoraInicio(900);
   HoraFim(1740);
   HoraFechamento(1740);

   periodoTopDown(10);
   DeslocamentoTopDown(0);

   DistanciaGradiente(25); 

VAR
   // 1 Minuto //
   Media34p, Media12p : Float;

   PowerVolumePlus_1m, PowerVolumeLow_1m, Exaustao_Vol_1m, 
   WeisWaveC_1m, WeisWaveV_1m,
   BopC_1m, BopV_1m,
   RsiC_1m, RsiV_1m, Rsi70_1m, Rsi30_1m: Boolean;

    // indicador AVB
   AgressaoCompra_1m, AgressaoVenda_1m :  Boolean;

   // 2 Minutos //
   Media89p_2m: Float;

   PowerVolumePlus_2m, PowerVolumeLow_2m, Exaustao_Vol_2m,
   WeisWaveC_2m, WeisWaveV_2m,
   BopC_2m, BopV_2m,
   RsiC_2m, RsiV_2m, Rsi70_2m, Rsi30_2m : Boolean;

   // indicador AVB
   AgressaoCompra_2m, AgressaoVenda_2m :  Boolean;

   // 5 Minutos //
   Media20p_5m, Media200p_5m,
   Rsi_5m : Float;


  
   // ANALISE DE MERCADO //
   RegiaoCompra, RegiaoVenda, Desalavancagem, Realavancagem, COMPRAR, VENDER, COMPRAR_PARC, VENDER_PARC, StopC, StopV,
   Absorsao, Exaustao_Vol, RegiaoLiquidez, CONSOLIDACAO, ondaElliot,
   TendenciaDeAlta, TendenciaDeBaixa, PERM  : Boolean;

   Pacial_25PcntC, Pacial_50PcntC, Pacial_75PcntC,
   Pacial_25PcntV, Pacial_50PcntV, Pacial_75PcntV : Boolean;

   QuantContratos : Inteiro;
   PrcEntrada : Float;
   
   // INDICADORES GERAIS // 
   VwapD, AjustD : Float;


   // ENTRADAS E SAIDAS VALIDAS //
   EtrdC1, EtrdC2, EtrdC3, EtrdC4, EtrdC5, EtrdC6, EtrdC7, EtrdC8, EtrdC9, EtrdC10,
   EtrdV1, EtrdV2, EtrdV3, EtrdV4, EtrdV5, EtrdV6, EtrdV7, EtrdV8, EtrdV9, EtrdV10 : Boolean;


   // NOVAS VARIAVEIS              #############

   DifM34_20, DifM20_89, DifM12_34, DifCloseVwap, 
   PERM_TOP: Boolean;

   A, B, mMin, mMax, Topo, Fundo, Atr: Float;

   DifM12_34Fl, DifM34_20Fl, DifM20_89Fl : Float;

   ValidatPERM1, ValidatPERM2, ValidatPERM3, ValidatPERM4, ValidatPERM5, ValidatPERM6 : Boolean;
   OTB, OTB1, OTB2, OTB3, OTB4, OTB5 : Boolean;
    


    Origem_Compra, Origem_Venda  : float;
    Contador_  : Inteiro;
    Posicao_   : float;
    Entrada_Compra_ : Array[0..1] of float;
    Entrada_Venda_ : Array[0..1] of float;



      PMB, PMS, PrC, PrV : Float;
      SinalTTC, SinalTTV : Boolean;    


  // NOVAS VARIAVEIS  ^            #############

   funcao AVB_Agress(Periodo : Inteiro; TipoValue : Inteiro) : Boolean;  // ## FUNÇÃO AGRESSÃO COMPRADORA E VENDEDORA
        Var
          AVB,
          MediaAVB,                   
          MediaMovelAVB : float;       
          {
            0 -> Agressão compradora
            1 -> Agressão vendedora
            #Periodo
            1m -> 7p
            2m -> 14p
            5m -> 35p
          }
          
        Inicio
               AVB := AgressionVolBalance;
               MediaAVB := MediaExp(Periodo, avb); 
               MediaMovelAVB := Media(Periodo, MediaAVB);
               //condição avb
               Se TipoValue = 0 então Result := (MediaAVB > MediaMovelAVB);   // AGRESSÃO COMPRADORA
               Se TipoValue = 1 então Result := (MediaAVB < MediaMovelAVB);   // AGRESSÃO VENDEDORA            
        fim;

    Funcao MediaMovelClose(Periodo : Inteiro):float;
        Inicio
           Result:= Media(Periodo, close);  // MEDIA MOVEL PELO FECHAMENTO
        fim;

    Funcao AnaliseVolume(PeriodoAnl : Inteiro; TipoVol : Inteiro): Boolean;  // Analisar Volume Financeiro
        {
          1 Minuto -> MediaExp : 7p       
          2 Minutos-> MediaExp : 14p
        }
        Var
           VolumeAtual, MediaMovelVol, MediaMovelM : Float;
           PivoBaixo, PivoAlto, PullbackAltoVolume : Boolean; 
        Inicio
            VolumeAtual := Volume;
            MediaMovelVol := mediaExp(PeriodoAnl, VolumeAtual);
            MediaMovelM := mediaExp(PeriodoAnl, MediaMovelVol);
            
            PivoBaixo := (Low < Low[8]) and (Low < Low[5]);
            PivoAlto := (High > High[8]) and (High > High[5]);
            PullbackAltoVolume := ((PivoBaixo or PivoAlto) and (VolumeAtual > 10000));
          
            se TipoVol = 0 então Result := not PullbackAltoVolume;               // EXAUSTÃO DO VOLUME
            se TipoVol = 1 então Result :=  (MediaMovelVol > MediaMovelM);       // VOLUME ALTO 
            se TipoVol = 2 então Result := (MediaMovelVol < MediaMovelM);        // VOLUME BAIXO  
        Fim;

    Funcao WeiWaveN(Periodo:Inteiro; TipoW:inteiro):Boolean;         // Indicador Weis Wave
    {
      1 Minuto -> 2 periodos
      2 Minutos -> 4 Periodos     
    }
        Var
           WeisWavep : Float;
        Inicio
           WeisWavep := NelogicaWeisWave(Periodo);

           Se TipoW = 0 então Result := WeisWavep > 0; // WEIS WAVE COMPRADOR
           Se TipoW = 1 então Result := WeisWavep < 0; // WEIS WAVE VENDEDOR
        fim;

    Funcao BopPower(Periodo:Inteiro; TipoB:inteiro):Boolean;         // Indicador Balança do Poder
    {
      1 Minuto -> 14 periodos     
    }
        Var
           IndicadorBop : Float;
        Inicio
           IndicadorBop := BalanceOfPower(Periodo, 0);

           Se TipoB = 0 então Result := IndicadorBop > 0; // BOP COMPRADOR
           Se TipoB = 1 então Result := IndicadorBop < 0; // BOP VENDEDOR
        fim;

    Funcao RsiValorIFR(Periodo:Inteiro; TipoR:inteiro):Boolean;         // Indicador RSI ou IFR
    {
      1 Minuto -> 14 periodos
      2 Minutos -> 28 periodos     
    }
        Var
           IndicadorRsi : Float;
        Inicio
           IndicadorRsi := RSI(Periodo, 0);

              // RSI VALORES
             Se TipoR = 51 então Result := IndicadorRsi > 50;    // RSI COMPRADOR      > 50
             Se TipoR = 49 então Result := IndicadorRsi < 50;    // RSI VENDEDOR       < 50
             Se TipoR = 71 então Result := IndicadorRsi > 70;    // RSI SOBRE-COMPRADO > 70
             Se TipoR = 29 então Result := IndicadorRsi < 30;    // RSI SOBRE-VENDIDO  < 30 
        fim;



    funcao PivoUpDownDivergt(TipoV : Inteiro):Boolean;
      var
        PivoBaixo: boolean;
        PivoAlto: boolean;
        RSivl : float;
        DivergntRSI, DivergntBOP : Inteiro;
      
        BOP_vl : float;
        ValidatAlta, ValidateBaixa, DivgMov : Boolean;
      
        LookbackRight, LookbackLeft : inteiro;
      
      inicio
        RSivl := RSI(14, 0);
        BOP_vl := BalanceOfPower(14, 0);
      
        LookbackRight := 8;
        LookbackLeft := 5;
      
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
      
        Se TipoV = 0 então Result := ValidatAlta;
        Se TipoV = 1 então Result := ValidateBaixa;
        Se TipoV = 2 então Result := DivgMov;
      fim; 

        {
          # LISTA DAS FUNÇÕES
            AVB_Agress       -> Agressão compradora e vendedora no momento
            MediaMovelClose  -> Media movel pelo fechamento
            AnaliseVolume    -> Analise de volume financeiro, ALTO, BAIXO, EXAUSTÃO
            WeiWaveN         -> Indicador WEIS WAVE
            BopPower         -> Indicador Balança do poder
            RsiValorIFR      -> Indicador RSI
        }

BEGIN
   ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // CHAMADA DOS INDICADORES
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////// 

   VwapD := VWAP(1);
   AjustD := PriorCote(4);                                    

   Atr := AvgTrueRange(10, 0);


  // time in trade
  PMB := PowerMeter(Osbuy, 1);  // 1 -> 1 MINUTO
  PMS := PowerMeter(OsSell, 1);

  PrC := Round(PMB/(PMB+PMS)*100);
  PrV := Round(PMS/(PMB+PMS)*100);

  SinalTTC := PrC > PrV;
  SinalTTV := PrV > PrC; 


   
  //----------------------------------------------------------------------------
  // 1 MINUTO 
  //----------------------------------------------------------------------------
   Media12p := MediaMovelClose(12);  // Mm 12 periodo 1 Minuto
   Media34p := MediaMovelClose(34);  // Mm 34 periodo 1 Minuto

   // WEIS WAVE
   WeisWaveC_1m := WeiWaveN(3, 0); // WEIS WAVE COMPRADOR 1 Minuto
   WeisWaveV_1m := WeiWaveN(3, 1); // WEIS WAVE VENDEDOR 1 Minuto

   // Balança do poder
   BopC_1m := BopPower(14, 0);  // BOP COMPRADOR 1 Minuto
   BopV_1m := BopPower(14, 1);  // BOP VENDEDOR 1 Minuto

   // RSI VALORES
   RsiC_1m := RsiValorIFR(14, 51);    // RSI COMPRADOR      > 50
   RsiV_1m := RsiValorIFR(14, 49);    // RSI VENDEDOR       < 50
   Rsi70_1m:= RsiValorIFR(14, 71);    // RSI SOBRE-COMPRADO > 70
   Rsi30_1m:= RsiValorIFR(14, 29);    // RSI SOBRE-VENDIDO  < 30
   
   // AVB - SALDO DE AGRESSÃO    
   AgressaoCompra_1m := AVB_Agress(7, 0);  // AGRESSÃO COMPRADORA 1 Minuto
   AgressaoVenda_1m  := AVB_Agress(7, 1);  // AGRESSÃO VENDEDORA  1 Minuto

   // MEDIA VOLUME
   Exaustao_Vol_1m    := AnaliseVolume(7, 0);   // EXAUSTÃO DO VOLUME 1 Minuto
   PowerVolumePlus_1m := AnaliseVolume(7, 1);   // VOLUME ALTO 1 Minuto
   PowerVolumeLow_1m  := AnaliseVolume(7, 2);   // VOLUME BAIXO 1 Minuto 


  //----------------------------------------------------------------------------
  // 2 MINUTOS 
  //----------------------------------------------------------------------------
   Media89p_2m :=  MediaMovelClose(178);


  //----------------------------------------------------------------------------
  // 5 MINUTOS 
  //----------------------------------------------------------------------------

   Media20p_5m := MediaMovelClose(90);
   


  //----------------------------------------------------------------------------
  // Indicador de topos e fundos 
  //----------------------------------------------------------------------------
   A := Highest(HIGH, periodoTopDown)[DeslocamentoTopDown];
   B := Lowest(low, periodoTopDown)[DeslocamentoTopDown];

   Se (Minima > Minima[1]) e (Minima[1] <= Minima[2]) então // (Maxima > Maxima[1]) então
       mMin := Minima[1];

       Se (B >= mMin) então
           Fundo := mMIn;

   Se (Maxima < Maxima[1]) e (Maxima[1] >= Maxima[2]) então
       mMax := Maxima[1];

       Se (A <= mMax) então
           Topo := mMax;


   ////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  //                                     REGRAS DE ENTRADAS E SAIDAS

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////// 

  {     validação do PERM   - OPERAÇÃO FEITA CONTRA A TENDENCIA

   | tendencia de alta |  [] Parâmetros operacionais:

      - CLOSE > M20p
      - CLOSE > M34p

      [] Analise feita nos graficos de 1 e 2 minutos
          - Analise de divervencias: RSI, BOP, SALDO DE AGRESSÃO, VOLUME


      - A media de 34p deve está acompanhando os preços
      - Deve ser observadas nas tentativas de renovação, Absorção
      - Deve ter um desequilibrio nas agressões do TIMES IN TRADES contra o movimento principal
      - A linha de tendencia deve ser rompida

      - Acontece então um rompimento da media de 34 periodo e um retorno, fazendo um puback com teste e confirmação
      - Inverão de fluxo no BOP
      - Principal agressão é vendedora

      - A entrada acontece com o aumento do fluxo no times in trade


      | [] Parâmetros gerenciais:

      - Stop atras do utimo topo de referencia
      - alvo, qualquer media que esteja mais proxima dos preços
          : -> media de 20 periodos, de 200 periodos, Vwap ou trade location

       /* FAZER PARCIAL COM 100 PTS NESTA OPERAÇÃO E A SAIDA TOTAL NA MEDIA DE 20P OU AS DEFINIDAS ANTERIOMENTE.
        DEPOIS DOS 100 PTS deve ter um traling stop no ponto de entrada + 1 tick. */


        PROTEÇÃO

        - Caso a operação não flua, deve ativar o gradiente linear (se close > 34p) levando o ponto de entrada pra cima.
          e deve sair da operação definitiva com 2 tick do no positivo.
  }
                                          
  Se (Time >= HoraInicio) e (Time < HoraFim) e (ContadorDeCandle > 1) então
  INICIO
  //----------------------------------------------------------------------------
  // PERM -  OPERAÇÃO DE INVERSÃO DE FLUXO COM PADRÃO DE EXECUÇÃO DE RETORNO A MÉDIA

    DifM12_34 := abs(Media12p-Media34p) >= 100; // indice : 100 
    DifM34_20 := (abs(Media34p-Media20p_5m) >= 70) e (abs(close-Media20p_5m) >=70); // indice : 100 
  
    DifCloseVwap := (abs(Close-VwapD) >= 70) e (abs(open-VwapD) >= 70); // indice 70
  
    TendenciaDeAlta  := (Media34p >  Media20p_5m) e (Media20p_5m > Media89p_2m) e (close > Media20p_5m);
    TendenciaDeBaixa :=  (Media34p <  Media20p_5m) e (Media20p_5m < Media89p_2m) e (close < Media20p_5m);

    // ---------- VALIDAÇÃO PERM DE VENDA
    ValidatPERM1 := TendenciaDeAlta e AgressaoVenda_1m e WeisWaveV_1m e BopV_1m;
    ValidatPERM2 := (close < Media34p) e (open < Media34p); 
    ValidatPERM3 := DifM34_20 e DifCloseVwap; 

        // ---------- VALIDAÇÃO PERM DE COMPRA
    ValidatPERM4 := TendenciaDeBaixa e AgressaoCompra_1m e WeisWaveC_1m e BopC_1m;
    ValidatPERM5 := (close > Media34p) e (open > Media34p); 
    ValidatPERM6 := DifM34_20 e DifCloseVwap e ((minima - Media34p) <= 30);

    se not HasPosition e ValidatPERM4 e PivoUpDownDivergt(0) e ValidatPERM5 e ValidatPERM6 então    // COMPRAR
    Inicio BuyAtMarket(2); PERM := true;  fim;

    se not HasPosition e ValidatPERM1 e PivoUpDownDivergt(1) e ValidatPERM2 e ValidatPERM3 então    // VENDER
    Inicio SellShortAtMarket(2); PERM := true;  fim;


    Se IsBought e PERM então      // STOP COMPRADO PERM
    Inicio
       se WeisWaveV_1m e (close > BuyPrice) e (BopV_1m) então  SellToCoverAtMarket(SellPosition);
       se WeisWaveV_1m e BopV_1m e PowerVolumePlus_1m e (close < Media34p) e PivoUpDownDivergt(1) então ClosePosition;
    fim;

    Se IsSold e PERM então      // STOP VENDIDO PERM
    Inicio
       se WeisWaveC_1m e (close < SellPrice) e (BopC_1m) então BuyToCoverAtMarket(SellPosition);
       se WeisWaveC_1m e BopC_1m e PowerVolumePlus_1m e (close > Media34p) e PivoUpDownDivergt(0) então ClosePosition;
    fim;

    
  
  //-------------------------------------------------------------------------------------------------------------------

  // OPERAÇÃO DE CONTINUAÇÃO DE TENDENCIA DE BAIXA - OTB          // Atr - volatilidade
  //OTB : array de 1 a 10
  //SinalTTC | times in trade comprador
  //SinalTTV | times in trade vendedor

//  WeisWaveC_Atl, WeisWaveV_Atl, WeisWaveC_Ant, WeisWaveV_Ant : Float;


  DifM12_34Fl := (abs(Media12p-Media34p));
  DifM34_20Fl := (abs(Media34p-Media20p_5m));
  DifM20_89Fl := (abs(Media20p_5m-Media89p_2m));

  // -----

  //// -- PLACAR ESTATISTICO
  Se (close > AjustD+(atr*2)) ou (close < AjustD-atr) então OTB[1] := true senão OTB[1] := false; // OTB[1] -> AJUSTE DIARIO
  Se (Close > VwapD) então OTB[2] := True senão OTB[2] := False; //  OTB[2] -> fechamento maior que vwap diario
  Se (Close < VwapD) então OTB[3] := True senão OTB[3] := False; //  OTB[3] -> fechamento menor que vwap diario
  //Se (close > VwapD+(atr*2)) ou (close < VwapD-atr) então OTB[13] := true senão OTB[13] := false; // OTB[13] -> distante da vwap

  Se (Media34p > Media20p_5m) então OTB[4] := True senão OTB[4] := False; //  OTB[4] -> Variavel simples de Tendencia de alta Alto risco **
  Se (Media34p > Media20p_5m) e (Media20p_5m > Media89p_2m) então OTB[5] := True senão OTB[5] := False; //  OTB[5] -> Tendencia de alta Baixo Risco *

  Se (Media34p < Media20p_5m) então OTB[6] := True senão OTB[6] := False; //  OTB[6] -> Tendencia de Baixa fraca
  Se (Media34p < Media20p_5m) e (Media20p_5m < Media89p_2m) então OTB[7] := True senão OTB[7] := False; //  OTB[7] -> Tendencia de Baixa forte


  Se (DifM34_20Fl >= (30)) e (DifM20_89Fl >= (30)) então OTB[8] := True senão OTB[8] := False; // OTB[8] -> se  ainda está em tendencia forte   ## NÃO FUNCIONAL AINDA

  Se OTB[4] e (close < Media34p) e (close < Media20p_5m) então OTB[9] := true senão OTB[9] := false;  // Divergencia na tendencia de alta
  Se OTB[6] e (close > Media34p) e (close > Media20p_5m) então OTB[10] := true senão OTB[10] := false;  // Divergencia na tendencia de baixa
  
  Se BopC_1m e BopC_2m e WeisWaveC_1m e WeisWaveC_2m e RsiC_1m então OTB[11]:= True senão OTB[11] := False; // convervencia no movimento 1 e 2 minutos | COMPRADOR
  Se BopV_1m e BopV_2m e WeisWaveV_1m e WeisWaveV_2m e RsiV_1m então OTB[12]:= True senão OTB[12] := False; // convervencia no movimento 1 e 2 minutos | VENDEDOR

  Se (Open < VwapD) e (Close < VwapD) então OTB[13] := True senão OTB[13] := False; // o preço deve confirmar abaixo da vwap



  /// ------------- 
  // Validação vendedora

  Se not HasPosition e not HasPendingOrders então
    Inicio
       Se OTB[6] então  // tendencia de baixa com maior risco
       Se OTB[1] então  // distante do ajuste em zona segura 
         Inicio
           Se OTB[7] e OTB[13] e OTB[3] e (Media12p < Media34p) e (Maxima > VwapD) então PaintBar(clyellow); //SellShortLimit(VwapD-5, LimiteDeContratos); // entrada 1 continuação de tendencia depois da VWAP DIARIO
         fim;
      


    Fim;








   //Se OTB[13]então // distante da vwap zona segura 




   //-------------------------------------------------------------------------------------------------------------------

  // PROTEÇÃO GRADIENTE LINEAR
    Origem_Compra := BuyPrice + DistanciaGradiente;
    Origem_Venda := SellPrice - DistanciaGradiente;


    se IsBought então  // ESTÁ VEMDIDO
    inicio
     // inicio das compras
      se (BuyPosition <= LimiteDeContratos) então
      inicio
        FOR Contador_ := (BuyPosition + 1) TO LimiteDeContratos Do
          inicio
          Posicao_ := Origem_Compra - (Contador_ * DistanciaGradiente);
            se (close >  Posicao_) então BuyLimit(Posicao_, 1);
          fim;
      fim;
    fim; 

    se  IsSold então  // ESTÁ COMPRADO
      inicio
        se (SellPosition <= LimiteDeContratos) então
        inicio
          FOR Contador_ := (SellPosition + 1) TO LimiteDeContratos Do
            inicio
            Posicao_ := Origem_Venda + (Contador_ * DistanciaGradiente);
              se (close <  Posicao_) então SellShortLimit(Posicao_, 1);
            fim;
        fim;
      fim;


        







  
  
  
  FIM;
  Se (Time > HoraFechamento) ou HasPendingOrders e not HasPosition então ClosePosition;
  Se not HasPosition então
  inicio 
      PERM := false;
  Fim;

END;


