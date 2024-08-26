input
  Preco(close);
  PeriodoMediaMAVB(34);

var
  avb: float;
  MediaAVB, MediaMovel: float;
  MediaMovelAVB: float;
  ColorMAVB: string;
  ifAVBMediaAlta, ifAVBMediaBaixa: boolean;
                                                            
Inicio
  // Obter o saldo de agressão atual
  avb := AgressionVolBalance;                     

  // Calcular a média móvel de 9 períodos do saldo de agressão
  MediaAVB := MediaExp(PeriodoMediaMAVB, avb); 
  MediaMovelAVB := Media(PeriodoMediaMAVB, MediaAVB);
  MediaMovel := Media(PeriodoMediaMAVB, close);

  //condição avb
  ifAVBMediaAlta := (MediaAVB > MediaMovelAVB);
  ifAVBMediaBaixa := (MediaAVB < MediaMovelAVB);

  // Condições para tendência de alta e baixa
  if ifAVBMediaAlta then
  begin
   if not HasPosition então
    BuyAtMarket
   senão se (IsSold) então
     BuyToCoverAtMarket; 
  end
  else if ifAVBMediaBaixa then
  begin
  if not HasPosition então
    SellShortAtMarket
  senão se(IsBought)então
    SellToCoverAtMarket;
  end;
  
  if ifAVBMediaAlta then
   PaintBar(clgreen)
  else if ifAVBMediaBaixa then
   Paintbar(clred);

   // Plotar a média móvel do saldo de agressão
  SetPlotWidth(1, 2);
  Plot(MediaAVB);
  SetPlotColor(2, clwhite);
  plot2(MediaMovelAVB);

  

Fim
