INPUT
 Distancia(25); 
 Max_contratos(10);
 //Inicio_Compras(125600);

VAR
Origem_Compra, Origem_Venda  : float;
Contador_  : Inteiro;
Posicao_   : float;
Entrada_Compra_ : Array[0..1] of float;
Entrada_Venda_ : Array[0..1] of float;


INICIO
  // ## GATILHO DE ENTRADA
  Origem_Compra := BuyPrice + Distancia;
  Origem_Venda := SellPrice - Distancia;

  se IsBought então
  inicio
   // inicio das compras
    se (BuyPosition <= Max_contratos) então
    inicio
      FOR Contador_ := (BuyPosition + 1) TO Max_contratos Do
        inicio
        Posicao_ := Origem_Compra - (Contador_ * Distancia);
        se (close >  Posicao_) então BuyLimit(Posicao_, 1);
        fim;
    
    fim;
  
    // saidas das compras - stops
    FOR Contador_ := 0 to (BuyPosition - 1) Do
    inicio
      Posicao_  := Origem_Compra - (Contador_ * Distancia);
  
      se (close < Posicao_) então SellToCoverLimit(Posicao_, 1);
    fim;

  fim;


  se  IsSold então
  inicio
   // inicio das Vendas
    se (SellPosition <= Max_contratos) então
    inicio
      FOR Contador_ := (SellPosition + 1) TO Max_contratos Do
        inicio
        Posicao_ := Origem_Venda + (Contador_ * Distancia);
        se (close <  Posicao_) então SellShortLimit(Posicao_, 1);
        fim;
    
    fim;
  
    // saidas das Vendas - stops
    FOR Contador_ := 0 to (SellPosition - 1) Do
    inicio
      Posicao_  := Origem_Venda  + (Contador_ * Distancia);
  
      se (close > Posicao_) então BuyLimit(Posicao_, 1);
    fim;

  fim;








FIM;