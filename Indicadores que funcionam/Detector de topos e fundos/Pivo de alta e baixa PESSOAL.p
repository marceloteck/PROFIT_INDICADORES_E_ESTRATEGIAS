input
  //ALTO VOLUME
  // Parâmetros do Pivô e Volume
  LookbackRight(8);
  LookbackLeft(5);
  VolumeAlto(10000);  // Ajuste este valor conforme necessário para definir "alto volume" 


var
 VolumeAtual, MediaMovelVol, MediaMovelM: float; 

  PivoBaixo: boolean;
  PivoAlto: boolean;

  funcao PivoUpDown(TipoV : Inteiro):Boolean;
  Var
      LookbackRight,
      LookbackLeft,
      VolumeAlto : Inteiro;

      PivoBaixo, PivoAlto : Boolean;
  Inicio
      LookbackRight := 8;
      LookbackLeft  := 5;
      VolumeAlto    := 10000;

      PivoAlto := (High > High[LookbackLeft]) and (High > High[LookbackRight]);
      PivoBaixo := (Low < Low[LookbackLeft]) and (Low < Low[LookbackRight]);
  
      se TipoV = 0 então Result := PivoAlto;
      se TipoV = 1 então Result := PivoBaixo;
  Fim;

inicio


 // Determinar pivôs de alta e baixa
  PivoBaixo := (Low < Low[LookbackLeft]) and (Low < Low[LookbackRight]);
  PivoAlto := (High > High[LookbackLeft]) and (High > High[LookbackRight]);

  se PivoAlto então PaintBar(clLime);
  se PivoBaixo então PaintBar(255);

fim;