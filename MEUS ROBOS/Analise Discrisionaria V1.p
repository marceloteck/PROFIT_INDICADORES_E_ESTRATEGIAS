INPUT
   AlvoFixo(False);
   PermitirGradienteLinear(True);
   LimiteDeContratos(10);
   EntradaMinimaContratos(2);

VAR
   // 1 Minuto //
   Media34p, Media12p,
   PowerVolume_1m, WeisWave_1m, Bop_1m, SaldoAgress_1m, MediaAgress_1m, Rsi_1m : Float;

   // 2 Minutos //
   Media89p_2m,
   PowerVolume_2m, WeisWave_2m, Bop_2m, SaldoAgress_2m, MediaAgress_2m, Rsi_2m : Float;

   // 5 Minutos //
   Media20p_5m, Media200p_5m,
   WeisWave_5m, Rsi_5m, PowerVolume_5m : Float;

   // 15 Minutos //
   VwapBands_15m : float;

   // 60 Minutos //
   MediaExp8p_60m, Media200p_60m : Float;
   SobreCompraBB_60m, SobreVendaBB_60m : Float; //Bandas de Bolliger 8p Exponencial 2.40 de desvio|fora das bandas marca true|


   // ANALISE DE MERCADO //
   RegiaoCompra, RegiaoVenda, Desalavancagem, Realavancagem, COMPRAR, VENDER, COMPRAR_PARC, VENDER_PARC, StopC, StopV,
   Absorsao, Exaustao, RegiaoLiquidez, CONSOLIDACAO, ondaElliot : Boolean;

   // ENTRADAS E SAIDAS VALIDAS //
   EtrdC1, EtrdC2, EtrdC3, EtrdC4, EtrdC5, EtrdC6, EtrdC7, EtrdC8, EtrdC9, EtrdC10,
   EtrdV1, EtrdV2, EtrdV3, EtrdV4, EtrdV5, EtrdV6, EtrdV7, EtrdV8, EtrdV9, EtrdV10 : Boolean;
   
   StopC1, StopC2, StopC3, StopC4, StopC5, StopC6, StopC7, StopC8, StopC9, StopC10,
   StopV1, StopV2, StopV3, StopV4, StopV5, StopV6, StopV7, StopV8, StopV9, StopV10 : Boolean;

   Pacial_25PcntC, Pacial_50PcntC, Pacial_75PcntC,
   Pacial_25PcntV, Pacial_50PcntV, Pacial_75PcntV : Boolean;

   QuantContratos : Inteiro;
   
   // INDICADORES GERAIS // 
   VwapD, AjustD : Float;

BEGIN
   //########## CHAMADA DOS INDICADORES ##########// 
   
   
   
   
   
   
  //########## REGRAS DE ENTRADAS E SAIDAS ##########//    

  //EntradaMinimaContratos

  //########## CONTROLE DE OPERAÇÕES ##########//
  Se not HasPosition então
     Inicio
         Se COMPRAR então BuyAtMarket(LimiteDeContratos);
         Se COMPRAR_PARC então BuyAtMarket(QuantContratos);

         Se VENDER então SellShortAtMarket(LimiteDeContratos);
         Se VENDER_PARC então SellShortAtMarket(QuantContratos);
     fim;

  Se HasPosition então
     Inicio
         Se IsBought então
            Inicio
               Se StopC então ClosePosition;
               Se Pacial_25PcntC então SellToCoverAtMarket(Round(BuyPosition*0.25));
               Se Pacial_50PcntC então SellToCoverAtMarket(Round(BuyPosition*0.50));
               Se Pacial_75PcntC então SellToCoverAtMarket(Round(BuyPosition*0.75));
            fim;
            
         Se IsSold então
            Inicio
               Se StopV então ClosePosition;
               Se Pacial_25PcntV então BuyToCoverAtMarket(Round(SellPosition*0.25));
               Se Pacial_50PcntV então BuyToCoverAtMarket(Round(SellPosition*0.50));
               Se Pacial_75PcntV então BuyToCoverAtMarket(Round(SellPosition*0.75));
            fim;
     fim;

END; 