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


   // NOVAS VARIAVEIS


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
                                          

   //----------------------------------------------------------------------------
   // PERM -  OPERAÇÃO DE INVERSÃO DE FLUXO COM PADRÃO DE EXECUÇÃO DE RETORNO A MÉDIA



  TendenciaDeAlta  := (Media12p > Media34p) e (Media34p >  Media20p_5m) e (Media20p_5m > Media89p_2m);
  TendenciaDeBaixa := (Media12p < Media34p) e (Media34p <  Media20p_5m) e (Media20p_5m < Media89p_2m);


  Se TendenciaDeAlta e AgressaoVenda_1m e WeisWaveV_1m e BopV_1m e not HasPosition então
    Se (Open[1] > Media34p) e (close[1] < Media34p) e (close[1] < open[1]) então
       Se (Maxima > Minima[1]) então
         Inicio
             VENDER_PARC := True;
             QuantContratos := Round(LimiteDeContratos / 2);
             PrcEntrada := Minima[1];
             PERM := True;
         Fim;


   Se IsSold então
     Se PERM então
       Se (close < Media20p_5m) então 
         inicio
            StopV := True;
            PERM  := false;
            VENDER_PARC := false;           
            QuantContratos := 0;
            PrcEntrada := 0;   
         fim;

 


  //PERM := TendenciaDeAlta e BopV_1m e AgressaoVenda_1m e WeisWaveV_1m;

   //LimiteDeContratos  PrcEntrada






  
    // CONFIRMAÇÃO DE ENTRADA ##    
    COMPRAR      := False;
    COMPRAR_PARC := False;

    VENDER      := False;


    // CONFIRMAÇÃO DE SAIDA ##
    StopC          := False;
    Pacial_25PcntC := False;
    Pacial_50PcntC := False;
    Pacial_75PcntC := False;

    Pacial_25PcntV := False;
    Pacial_50PcntV := False;
    Pacial_75PcntV := False;


  //########## CONTROLE DE OPERAÇÕES ##########//
  Se not HasPosition e (Time >= HoraInicio) e (Time < HoraFim) então
     Inicio
         Se COMPRAR então BuyAtMarket(LimiteDeContratos);
         Se COMPRAR_PARC então BuyAtMarket(QuantContratos);

         Se VENDER então SellShortAtMarket(LimiteDeContratos);
         Se VENDER_PARC então SellShortLimit(PrcEntrada, QuantContratos);
     fim;

  Se HasPosition então
     Inicio
         Se IsBought então
            Inicio
               Se StopC então ClosePosition;
               Se Pacial_25PcntC então SellToCoverAtMarket(Round(BuyPosition*0.25));
               Se Pacial_50PcntC então SellToCoverAtMarket(Round(BuyPosition*0.50));
               Se Pacial_75PcntC então SellToCoverAtMarket(Round(BuyPosition*0.75));

               Se AlvoFixo então
                  Inicio
                     SellToCoverLimit(BuyPrice+TamanhoDoAlvoPts);
                     SellToCoverStop(BuyPrice-TamanhoDoStopPts, BuyPrice-TamanhoDoStopPts-3);
                  fim;
            fim;
            
         Se IsSold então
            Inicio
               Se StopV então BuyToCoverAtMarket;
               Se Pacial_25PcntV então BuyToCoverAtMarket(Round(SellPosition*0.25));
               Se Pacial_50PcntV então BuyToCoverAtMarket(Round(SellPosition*0.50));
               Se Pacial_75PcntV então BuyToCoverAtMarket(Round(SellPosition*0.75));

                Se AlvoFixo então
                  Inicio
                     BuyToCoverLimit(SellPrice-TamanhoDoAlvoPts);
                     BuyToCoverStop(SellPrice+TamanhoDoStopPts, SellPrice+TamanhoDoStopPts+3);
                  fim;
            fim;
         Se (Time > HoraFechamento) então ClosePosition;
     fim;


END;

