INPUT
     DistanciaMedia(30.00);
     Media1(9);
     Media2(20);

VAR
    Dist, m1, m2 : Float;

BEGIN

     m1 := Media(media1, Close);
     m2 := Media(media2, Close);

     Dist := Abs(m1-m2);

     se (Dist < DistanciaMedia) então PaintBar(clFucsia);

END;

{
    // 1. Define the indicator parameters
    calcula a distancia entre as duas medias e mostra que as que estiverem
    menor que 30 pontos para o mini indice então ele está em consolidação
}