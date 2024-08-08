input
  Preco(close);
  PeriodoMediaMAVB(21);

var
  avb: float;
  MediaAVB: float;
  MediaMovelAVB: float;
  ColorMAVB: string;
  ifAVBMediaAlta, ifAVBMediaBaixa: boolean;
                                                            
Inicio
  // Obter o saldo de agressão atual
  avb := AgressionVolBalance;                     

  // Calcular a média móvel de 9 períodos do saldo de agressão
  MediaAVB := MediaExp(PeriodoMediaMAVB, avb); 
  MediaMovelAVB := Media(PeriodoMediaMAVB, MediaAVB);

  //condição avb
  ifAVBMediaAlta := (MediaAVB > MediaMovelAVB);
  ifAVBMediaBaixa := (MediaAVB < MediaMovelAVB);

  // Condições para tendência de alta e baixa
  if ifAVBMediaAlta then
  begin
    SetPlotColor(1, clLime); // Tendência de alta, pintar de verde
  end
  else if ifAVBMediaBaixa then
  begin
    SetPlotColor(1, clred); // Tendência de baixa, pintar de vermelho
  end;

  // Plotar a média móvel do saldo de agressão
  SetPlotWidth(1, 2);
  Plot(MediaAVB);

  

Fim
