INPUT
   LimiteDeContratos(10);
   HoraInicio(900);
   HoraFim(1740);
   HoraFechamento(1740);
   DistanciaGradiente(25); 
    
VAR
   i : Inteiro; 
   DifM12_34Fl, DifM34_20Fl, DifM20_89Fl : Float;
   
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

   // 5 Minutos //
   Media20p_5m, Media200p_5m : Float;

   // INDICADORES GERAIS // 
   VwapD, AjustD, Atr : Float;

   OTB    : Array [1..20] of Boolean;
   PAINTC : Array [1..10] of Boolean;
   PAINTV : Array [1..10] of Boolean;

   Origem_Compra, Origem_Venda  : float;
   Contador_  : Inteiro;
   Posicao_   : float;

   ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // FUNÇÕES
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    Funcao MediaMovelClose(Periodo : Inteiro):float;
        Inicio
           Result:= Media(Periodo, close);  // MEDIA MOVEL PELO FECHAMENTO
        fim;
        //--------

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
        //--------

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
        //--------

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
        //--------

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
        //--------
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
        //--------


BEGIN
   ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // CHAMADA DOS INDICADORES
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////// 

   VwapD := VWAP(1);
   AjustD := PriorCote(4);                                    

   Atr := AvgTrueRange(10, 0);

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
   




  Se (Time >= HoraInicio) e (Time < HoraFim) e (ContadorDeCandle > 1) então
  INICIO
  // -----
  DifM12_34Fl := (abs(Media12p-Media34p));
  DifM34_20Fl := (abs(Media34p-Media20p_5m));
  DifM20_89Fl := (abs(Media20p_5m-Media89p_2m));
  // -----

  //// -- PLACAR ESTATISTICO

  //-- AJUSTE E VWAP
  Se (close > AjustD+(atr*2)) ou (close < AjustD-atr) então OTB[1] := true senão OTB[1] := false; // OTB[1] -> AJUSTE DIARIO
  Se (Close > VwapD) então OTB[2] := True senão OTB[2] := False; //  OTB[2] -> fechamento maior que vwap diario
  Se (Close < VwapD) então OTB[3] := True senão OTB[3] := False; //  OTB[3] -> fechamento menor que vwap diario

  // Fechamento e abertura na vwap
  Se (Open < VwapD) e (Close < VwapD) então OTB[13] := True senão OTB[13] := False; // o preço deve confirmar abaixo da vwap
  Se (Maxima > VwapD) então OTB[16] := True senão OTB[16] := False; // Maxima maior que vwap
  Se (Minima < VwapD) então OTB[17] := True senão OTB[17] := False; // Minima Menor que vwap
  Se (close[1] < VwapD)  e (close[2] < VwapD) e (ContadorDeCandle > 2) então OTB[20]:= True senão OTB[20] := False; // 
  //-- 

  //-- MÉDIAS MOVEIS
  Se (Media34p > Media20p_5m) então OTB[4] := True senão OTB[4] := False; //  OTB[4] -> Variavel simples de Tendencia de alta Alto risco **
  Se (Media34p > Media20p_5m) e (Media20p_5m > Media89p_2m) então OTB[5] := True senão OTB[5] := False; //  OTB[5] -> Tendencia de alta Baixo Risco *

  Se (Media34p < Media20p_5m) então OTB[6] := True senão OTB[6] := False; //  OTB[6] -> Tendencia de Baixa fraca
  Se (Media34p < Media20p_5m) e (Media20p_5m < Media89p_2m) então OTB[7] := True senão OTB[7] := False; //  OTB[7] -> Tendencia de Baixa forte

  Se (Media12p < Media34p) então OTB[14] := True senão OTB[14] := False; // Media de 12 menor que a media de 34
  Se (Media12p > Media34p) então OTB[15] := True senão OTB[15] := False; // Media de 12 menor que a media de 34

  Se (DifM34_20Fl >= (30)) e (DifM20_89Fl >= (30)) então OTB[8] := True senão OTB[8] := False; // OTB[8] -> se  ainda está em tendencia forte   ## NÃO FUNCIONAL AINDA

  Se (Media34p < Media34p[34]) e (Media20p_5m < Media20p_5m[90]) e (Media89p_2m < Media89p_2m[178]) então OTB[19] := True senão OTB[19] := False;

  // Fechamento e abertura nas medias
  Se OTB[4] e (close < Media34p) e (close < Media20p_5m) então OTB[9] := true senão OTB[9] := false;  // Divergencia na tendencia de alta
  Se OTB[6] e (close > Media34p) e (close > Media20p_5m) então OTB[10] := true senão OTB[10] := false;  // Divergencia na tendencia de baixa
  //-- 

  //-- INDICADORES DE FORÇA E DIVERGENCIAS
  Se BopC_1m e BopC_2m e WeisWaveC_1m e WeisWaveC_2m e RsiC_1m então OTB[11]:= True senão OTB[11] := False; // convervencia no movimento 1 e 2 minutos | COMPRADOR
  Se BopV_1m e BopV_2m e WeisWaveV_1m e WeisWaveV_2m e RsiV_1m então OTB[12]:= True senão OTB[12] := False; // convervencia no movimento 1 e 2 minutos | VENDEDOR

  Se BopV_1m  e WeisWaveV_1m então OTB[18]:= True senão OTB[18] := False; // 




  //-------------------------------------------------------------------------------------------------------------------
  // OPERAÇÃO DE CONTINUAÇÃO DE TENDENCIA DE BAIXA - OTB          

  //       Validação vendedora                    
       Se OTB[6] então   // tendencia de baixa com maior risco
       Se OTB[1] então  // distante do ajuste em zona segura 
         INICIO
           // - Vwap
           Se OTB[7] e OTB[8] e OTB[13] e OTB[14] e OTB[16] e OTB[19] e OTB[20] então 
             Inicio 
               Se not HasPosition então SellShortLimit(VwapD-5, 2); // ENTRADA NA VWAP
               PAINTV[1] := True; 
             fim 
             Senão PAINTV[1] := False;  
          // -





         FIM;



    // se OTB[19] então PAINTV[1] := true;




















    //----------------------------------------------------------------------------
    // REGRA DE COLORAÇÃO
    //----------------------------------------------------------------------------

    FOR i := 1 TO 10 Do Se PAINTV[i] então PaintBar(255);      // COLORAÇÃO VENDEDORA
    FOR i := 1 TO 10 Do Se PAINTC[i] então PaintBar(clGreen);  // COLORAÇÃO COMPRADORA


    //----------------------------------------------------------------------------
    // PROTEÇÃO GRADIENTE LINEAR
    //----------------------------------------------------------------------------
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

  FIM;  { DENTRO DO TIME }

    Se (Time > HoraFechamento) então ClosePosition;

END;  { BLOCO PRINCIPAL }

