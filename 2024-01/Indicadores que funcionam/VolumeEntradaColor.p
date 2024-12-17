input
  // Parâmetros do Pivô e Volume
  Preco(close);
  LookbackRight(5);
  LookbackLeft(5);
  VolumeAlto(10000);  // Ajuste este valor conforme necessário para definir "alto volume"

var
  // Variáveis para armazenar valores de preço e volume
  PrecoPivo: float;
  VolumeAtual: float;
  PivoBaixo: boolean;
  PivoAlto: boolean;
  PullbackAltoVolume: boolean;

Inicio
  // Determinar pivôs de alta e baixa
  PivoBaixo := (Low < Low[LookbackLeft]) and (Low < Low[LookbackRight]);
  PivoAlto := (High > High[LookbackLeft]) and (High > High[LookbackRight]);

  // Verificar se há um pullback com alto volume após um pivô
  VolumeAtual := Volume;
  PullbackAltoVolume := ((PivoBaixo or PivoAlto) and (VolumeAtual > VolumeAlto));

  // Colorir a barra se houver um pullback com alto volume
  if not PullbackAltoVolume then
    PaintBar(clBlue);

Fim
