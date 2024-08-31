input
  //ALTO VOLUME
  // Parâmetros do Pivô e Volume
  LookbackRight(5);
  LookbackLeft(5);
  VolumeAlto(10000);  // Ajuste este valor conforme necessário para definir "alto volume" 


var
 VolumeAtual, MediaMovelVol, MediaMovelM: float; 

 // Variáveis para armazenar valores de preço e volume
  PrecoPivo: float;
  PivoBaixo: boolean;
  PivoAlto: boolean;
  PullbackAltoVolume: boolean;
  VolumePlusMedia, VolumeMnrMedia: boolean;

inicio
VolumeAtual := Volume;
MediaMovelVol := mediaExp(7, VolumeAtual);
MediaMovelM := mediaExp(7, MediaMovelVol);

 // Determinar pivôs de alta e baixa
  PivoBaixo := (Low < Low[LookbackLeft]) and (Low < Low[LookbackRight]);
  PivoAlto := (High > High[LookbackLeft]) and (High > High[LookbackRight]);

PullbackAltoVolume := ((PivoBaixo or PivoAlto) and (VolumeAtual > VolumeAlto));
VolumePlusMedia :=  (MediaMovelVol > MediaMovelM);
VolumeMnrMedia := (MediaMovelVol < MediaMovelM);

SetPlotColor(1, clwhite);
SetPlotWidth(1, 2);
//SetPlotColor(2, clMedGray);              
                           
             
                

 // Colorir a barra se houver um pullback com alto volume
se not PullbackAltoVolume então
 SetPlotColor(1, clBlue)
senão se VolumePlusMedia então                   
  SetPlotColor(1, clGreen)
senão se VolumeMnrMedia então
  SetPlotColor(1, clRed); 

plot(MediaMovelVol);
//plot2(media(34+22, VolumeAtual));

fim;