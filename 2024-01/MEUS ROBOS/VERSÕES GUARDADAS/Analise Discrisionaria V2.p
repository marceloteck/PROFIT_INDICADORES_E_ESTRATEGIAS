INPUT
   AlvoFixo(False);
   TamanhoDoAlvoPts(0);
   TamanhoDoStopPts(0); 
   PermitirGradienteLinear(True);
   LimiteDeContratos(10);
   EntradaMinimaContratos(2);

   HoraInicio(900);
   HoraFim(1700);
   HoraFechamento(1740);

   periodoTopDown(10);
   DeslocamentoTopDown(0);

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


   // NOVAS VARIAVEIS              #############

   DifM34_20, DifM20_89, DifM12_34, DifCloseVwap, 
   PERM_TOP: Boolean;

   A, B, mMin, mMax, Topo, Fundo: Float;

   ValidatPERM1, ValidatPERM2, ValidatPERM3, ValidatPERM4, ValidatPERM5,
   TCG : Boolean; 


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

   
  //----------------------------------------------------------------------------
  // 1 MINUTO 
  //----------------------------------------------------------------------------
   Media12p := MediaMovelClose(12);  // Mm 12 periodo 1 Minuto
   Media34p := MediaMovelClose(34);  // Mm 34 periodo 1 Minuto

   // WEIS WAVE
   WeisWaveC_1m := WeiWaveN(2, 0); // WEIS WAVE COMPRADOR 1 Minuto
   WeisWaveV_1m := WeiWaveN(2, 1); // WEIS WAVE VENDEDOR 1 Minuto

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
                                          
  Se (Time >= HoraInicio) e (Time < HoraFim) então
  INICIO
  //----------------------------------------------------------------------------
  // PERM -  OPERAÇÃO DE INVERSÃO DE FLUXO COM PADRÃO DE EXECUÇÃO DE RETORNO A MÉDIA

  // ValidatPERM1, ValidatPERM2, ValidatPERM3, ValidatPERM4, ValidatPERM5 : Boolean;

   // plot(Topo);                  
   // plot2(Fundo);


    DifM12_34 := (Media12p-Media34p) >= 100; // indice : 100 
    DifM34_20 := (Media34p-Media20p_5m) >= 100; // indice : 100 
    DifM20_89 := (Media20p_5m-Media89p_2m) >= 100; // indice : 100 
  
    DifCloseVwap := (Close-VwapD) >= 70; // indice 70
  
    TendenciaDeAlta  := (Media34p >  Media20p_5m) e (Media20p_5m > Media89p_2m);
    TendenciaDeBaixa :=  (Media34p <  Media20p_5m) e (Media20p_5m < Media89p_2m);

    TCG := 
    (OPEN[2] > Media34p[2]) e (CLOSE[2] < Media34p[2]) e
    (CLOSE[1] > CLOSE[2]) E (CLOSE < OPEN[1]) e (close < Media34p); 

    // ---------- VALIDAÇÃO PERM
    ValidatPERM1 := TendenciaDeAlta e AgressaoVenda_1m e WeisWaveV_1m e BopV_1m;
    ValidatPERM2 := (close < Media34p) e (Open > Media34p); 
    ValidatPERM3 := DifM34_20 e DifM20_89 e DifM12_34[10]; //

  
  
      Se Not HasPosition e ValidatPERM1  e ValidatPERM3 e TCG então
        Inicio
           Se (close <= Fundo) então
             Inicio
                PERM_TOP := true;
                PaintBar(clPurple);
             fim
             senão
             Inicio
               //SellShortLimit(Minima, Round(LimiteDeContratos / 2));
               SellShortAtMarket;
             fim;
           
           PERM := True;
           Pacial_50PcntV := false;
           PaintBar(255);
        Fim;



   Se not DifCloseVwap então
     Inicio
        BuyToCoverStop(VwapD+4, VwapD+5, SellPosition); 
     fim;

   Se PERM_TOP e PERM e not HasPosition então
     se TendenciaDeAlta e AgressaoVenda_1m e WeisWaveV_1m e BopV_1m então
       Inicio
           SellShortLimit(Maxima, Round(LimiteDeContratos / 2));
       fim;


   se (close <= Media20p_5m) ou (close > Media34p+50) então
    Inicio
       PERM_TOP := false;
    fim;

  
   Se IsSold então
      Se PERM então
       Inicio
           //BuyToCoverStop(SellPrice+100, SellPrice+121, SellPosition); // stop
           BuyToCoverStop(Media34p+5, Media34p+6, SellPosition); // stop
           Se WeisWaveC_1m e PowerVolumeLow_1m e not Pacial_50PcntV então 
             Inicio         
               BuyToCoverAtMarket(Round(SellPosition*0.50)); // mini indice     - SAIDA PARCIAL 75%
               PaintBar(clAqua);
               Pacial_50PcntV := true;
             fim; 
             
           Se Pacial_50PcntV então
             Inicio
                 BuyToCoverStop(SellPrice-15, SellPosition);
             fim;                                              
  
  
             Se WeisWaveC_1m e PowerVolumePlus_1m e BopC_1m então  
               Inicio 
                 ClosePosition; 
                 PaintBar(clblue);
                 PERM := false;
                 Pacial_50PcntV := false;
               Fim;
  
       fim;


  
  
  
  
  
    
  
  
  
  
  
  
  FIM;
  Se (Time > HoraFechamento) então ClosePosition;

END;

