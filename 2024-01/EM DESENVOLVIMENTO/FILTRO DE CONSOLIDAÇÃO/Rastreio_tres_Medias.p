INPUT
     Media1(9);
     Media2(20);
     Media3(50);

VAR
     m1, m2, m3 : Float;

BEGIN

     m1 := Media(media1, Close);
     m2 := Media(media2, Close);
     m3 := Media(media3, Close);

     Se ((m1 > m2) e (m2 > m3)) então PaintBar(clgreen) 
     senão se (( m1 < m2) e (m2 < m3)) então PaintBar(clred)
     senão PaintBar(clFucsia);

END;

{
    MOSTRA TENDENCIA E TAMBÉM A CONSOLIDAÇÃO
    TENDENCIA DE ALTA: VERDE
    TENDENCIA DE BAIXA: VERMELHO
    CONSOLIDAÇÃO: ROXO.
}