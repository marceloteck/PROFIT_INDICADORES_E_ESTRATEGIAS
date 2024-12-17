// Definir variáveis e parâmetros
input
  //médias moveis
  Preco(close);
  MediaSuperLongaMM(72);
  MediaLongaMM(34);
  MediaMeioMM(21);
  MediaCurtaMM(12); 
   
  // BALANÇA DE PODER
  PeriodoBOP(14);
  TipoMediaBOP(0); // 0 - Aritmética, 1 - Exponencial, 2 - Welles Wilder, 3 - Ponderada
  PeriodoMediaArit(7); // Período da média exponencial

  //DI
  PeriodoDI(12);

  //RSI
  PeriodoRSI(9);

  //MACD
  MediaLonga(26);
  MediaCurta(12);
  Sinal(9);

  //Cumulative Delta
  PeriodoMediaCD(21); // Período da média do Cumulative Delta

  // Rastrear consolidação
  PeriodoADX(14);//Período do ADX
  PeriodoBB(20);//Período das Bandas de Bollinger
  PeriodoMediaADX(14);//Novo parâmetro para o período da média do ADX
  DesvioBB(2.0);//Desvio Padrão das Bandas de Bollinger
  LimiteADX(25);//Limite do ADX para considerar consolidação
  TipoMedia(0); //0 = Aritmética, 1 = Exponencial, 2 = Welles Wilder, 3 = Ponderada
  ColorFundo(clFuchsia);

  //Acumulação/distribuição
  PeriodoMediaAccuDistr(12); // Período da média móvel

  //ALTO VOLUME
  // Parâmetros do Pivô e Volume
  LookbackRight(5);
  LookbackLeft(5);
  VolumeAlto(10000);  // Ajuste este valor conforme necessário para definir "alto volume"

  // Média AVB
  PeriodoMediaMAVB(34);


var
  COMPRA, MediaAlta, AlertCompra: Boolean;
  VENDA, MediaBaixa, AlertVenda: boolean;
  CONSOLIDACAO: Boolean;

  Media72, Media34, Media21, Media12: float;

  // BALANÇA DE PODER
  BOPValor: float;
  MediaBOP: float;

  //DI
  DIPlus: float;
  DIMinus: float;

  //RSI
  RSIValor: float;

  //MACD
  MACD_Linha: float;
  MACD_Histograma: float;
  MACD_MediaM: float;

  //PullBackFinder
  PullBackFinderValor: float;
  PullBackFinderAtivo: float;

  //Cumulative Delta
  CDValor: float; // Valor do Cumulative Delta
  MediaCD: float; // Média do Cumulative Delta
  MediaMOV: float; // Média dos preços
  VolumeComprado: float; // Volume comprado
  VolumeVendido: float; // Volume vendido
  MComparationAlta: Boolean;
  MComparationBaixa: Boolean;

  //Rastrear consolidação
  ADXValor: inteiro;
  MediaBB: inteiro;
  BandaSuperior: inteiro;
  BandaInferior: inteiro;
  AmplitudeBB: inteiro;

  //outros
  MediaMovel: float;

  //Acumulação/distribuição
  nAcc: float; // Valor do indicador de Acumulação/Distribuição
  MediaAcc: float; // Média móvel do indicador de Acumulação/Distribuição

   VolumeAtual, MediaMovelVol, MediaMovelM: float; 

 // Variáveis para armazenar valores de preço e volume
  PrecoPivo: float;
  PivoBaixo: boolean;
  PivoAlto: boolean;
  PullbackAltoVolume: boolean;
  VolumePlusMedia, VolumeMnrMedia: boolean; 

  // AVB
  avb: float;
  MediaAVB: float;
  MediaMovelAVB: float;
  ColorMAVB: string;
  ifAVBMediaAlta, ifAVBMediaBaixa: boolean;

   // POSIÇÃO
   buyPos, sellPos: inteiro;

   //VWAP
   nVWAP: float;
   RegiaoVWapUp, RegiaoVWapDown: boolean;


Inicio
  // Calcular Balança do Poder
  BOPValor := BalanceOfPower(PeriodoBOP, TipoMediaBOP);

  // Calcular DI
  DIPlus := DiPDiM(PeriodoDI)|0|;
  DIMinus := DiPDiM(PeriodoDI)|1|;

  // Calcular Média Exponencial da Balança do Poder
  MediaBOP := MediaExp(PeriodoMediaArit, BOPValor);

  // Calcular RSI
  RSIValor := RSI(PeriodoRSI, 0);

  // Calcular MACD
  MACD_Linha := MACD(MediaLonga, MediaCurta, Sinal)|0|;
  MACD_Histograma := MACD(MediaLonga, MediaCurta, Sinal)|1|;

  // Calcular Média Móvel do Sinal do MACD
  MACD_MediaM := Media(39, MACD_Linha);

  // Calcular o valor do Nelogica PullBack Finder
  PullBackFinderValor := NelogicaPullBackFinder|1|;
  PullBackFinderAtivo := NelogicaPullBackFinder|0|;

  // Calcular o volume comprado e vendido
  VolumeComprado := AgressionVolBuy;
  VolumeVendido := AgressionVolSell;

  // Calcular o Cumulative Delta
  CDValor := AccAgressSaldo(1); // Usar o acúmulo de agressão - saldo com quantidade

  // Calcular a média de 21 períodos do Cumulative Delta e dos preços
  MediaCD := MediaExp(PeriodoMediaCD, CDValor);
  MediaMOV := MediaExp(PeriodoMediaCD, close);



  // Cálculo da média móvel de 21 períodos (aritmética)
  MediaMovel := media(PeriodoMediaArit, Preco);


  //Rastrear consolidação ADX e Bandas de Bollinger 
  // Calcular ADX
  ADXValor := ADX(PeriodoADX, PeriodoMediaADX);
  
  // Calcular Bandas de Bollinger
  BandaSuperior := BollingerBands(DesvioBB, PeriodoBB, TipoMedia)|0|;
  BandaInferior := BollingerBands(DesvioBB, PeriodoBB, TipoMedia)|1|;
  AmplitudeBB := BollingerBandW(DesvioBB, PeriodoBB, TipoMedia);

  //Acumulação/Distribuição
  // Obter o valor do indicador de Acumulação/Distribuição
  nAcc := AccuDistr;
  // Calcular a média móvel de 34 períodos do indicador de Acumulação/Distribuição
  MediaAcc := Media(PeriodoMediaAccuDistr, nAcc);


//se (BOPValor > 0) e (RSIValor > 50) e (fechamento > MediaMovel) então
//   PaintBar(clYellow) 
// senão se (BOPValor < 0) e (RSIValor < 50) e (fechamento < MediaMovel) então
//  PaintBar(clYellow) senão

 
 // Determinar pivôs de alta e baixa
  PivoBaixo := (Low < Low[LookbackLeft]) and (Low < Low[LookbackRight]);
  PivoAlto := (High > High[LookbackLeft]) and (High > High[LookbackRight]);

  // Verificar se há um pullback com alto volume após um pivô
  VolumeAtual := Volume;
  MediaMovelVol := mediaExp(7, VolumeAtual);
  MediaMovelM := mediaExp(7, MediaMovelVol);
  
   // Determinar pivôs de alta e baixa
    PivoBaixo := (Low < Low[LookbackLeft]) and (Low < Low[LookbackRight]);
    PivoAlto := (High > High[LookbackLeft]) and (High > High[LookbackRight]);
  
  PullbackAltoVolume := ((PivoBaixo or PivoAlto) and (VolumeAtual > VolumeAlto));
  VolumePlusMedia :=  (MediaMovelVol > MediaMovelM);
  VolumeMnrMedia := (MediaMovelVol < MediaMovelM);
  
   
  
  //AVB ###
  // Obter o saldo de agressão atual
  avb := AgressionVolBalance;                     
  // Calcular a média móvel do saldo de agressão
  MediaAVB := MediaExp(PeriodoMediaMAVB, avb); 
  MediaMovelAVB := Media(PeriodoMediaMAVB, MediaAVB);
  //condição avb
  ifAVBMediaAlta := (MediaAVB > MediaMovelAVB);
  ifAVBMediaBaixa := (MediaAVB < MediaMovelAVB);
     

  //MEDIAS MOVEIS 
  Media72 := media(MediaSuperLongaMM, Preco); 
  Media34 := media(MediaLongaMM, Preco);
  Media21 := media(MediaMeioMM, Preco);
  Media12 := media(MediaCurtaMM, Preco);

  //VWAP
  nVWAP := VWAP(1);
  RegiaoVWapUp := (fechamento >= nVWAP) and (fechamento <= nVWAP + 150);
  RegiaoVWapDown := (fechamento <= nVWAP) and (fechamento >= nVWAP - 150); 
  
  // ####################################################################
  // Determinar condições de comparação comulative delta
  //MComparationAlta := (fechamento > MediaMOV) e (abertura > MediaMOV);
  //MComparationBaixa := (fechamento < MediaMOV) e (abertura < MediaMOV);


  //Condição de compra Média movel
  MediaAlta  := (fechamento > Media21) e (fechamento > Media12) e (fechamento > Media34) e (fechamento > Media72);
  MediaBaixa := (fechamento < Media21) e (fechamento < Media12) e (fechamento < Media34) e (fechamento < Media72);
      
//ALERTA MERCADO
  AlertCompra := (DIPlus > DIMinus) e (RSIValor > 50) e (PullBackFinderValor > 0) e MediaAlta ;
  AlertVenda := (DIPlus < DIMinus) e (RSIValor < 50) e (PullBackFinderValor < 0) e MediaBaixa;

// ####################################################################

 // CONDIÇÕES COMPRA
 COMPRA := (DIPlus > DIMinus) e (RSIValor > 50)
 e (ifAVBMediaAlta) e (PullBackFinderValor > 0)
 e (BOPValor > 0) e (MACD_Histograma > 0) 
 //e MediaAlta  
 //e (CDValor > MediaCD)
  ;

// CONDIÇÕES VENDA
 VENDA := (DIPlus < DIMinus) e (RSIValor < 50)
 e (ifAVBMediaBaixa) e (BOPValor < 0) e (PullBackFinderValor < 0)
 e (MACD_Histograma < 0)
 //e (MACD_Linha < MACD_MediaM) 
// e MediaBaixa e (CDValor < MediaCD) 
  ; 
  
// CONDIÇÕES CONSOLIDAÇÃO
 CONSOLIDACAO := (ADXValor < LimiteADX) e (AmplitudeBB < 0.05) e não MediaAlta e não MediaBaixa; 
  
// #################################################################### 
  
  
  se(CONSOLIDACAO) então
 Se (Fechamento[0] < Fechamento[1]) então
      PaintBar(clSkyBlue)
    Senão
      PaintBar(clFuchsia);   
   
                      
 
  Se COMPRA então
      PaintBar(clGreen) // Balança do Poder acima de 0 e Média Exponencial acima de 0 - Tendência de alta

  //senão se (MediaExponencialBOP < 0) e (DIPlus < DIMinus) e (RSIValor < 50) 
  senão se VENDA então
      PaintBar(clRed); // Balança do Poder abaixo de 0 e Média Exponencial abaixo de 0 - Tendência de baixa

  // Colorir a barra se houver um pullback com alto volume
  if not PullbackAltoVolume then
    PaintBar(clBlue);


fim 
                         
                          
                  