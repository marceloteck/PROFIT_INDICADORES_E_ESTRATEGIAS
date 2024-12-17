 input
 //médias moveis
    Preco(close);
    MediaSuperLonga(72);
    MediaLonga(34);
    MediaMeio(21);
    MediaCurta(12);
    EspessuraMedia(2);

// Variáveis para as médias móveis
var 
  Media34: float;
  Media21: float;
  Media12: float;
  Media72: float;

Inicio
// Cálculo da média móvel de 34 períodos (aritmética)
Media72 := media(MediaSuperLonga, Preco);
         
// Cálculo da média móvel de 34 períodos (aritmética)
Media34 := media(MediaLonga, Preco);

// Cálculo da média móvel de 21 períodos (aritmética)
Media21 := media(MediaMeio, Preco);

// Cálculo da média móvel de 12 períodos (exponencial)
Media12 := media(MediaCurta, Preco);                          

// Plotando a média móvel de 34 períodos (cor azul)


Plot(Media72);     
Plot2(Media34);
Plot3(Media21);
Plot4(Media12);


se (fechamento < Media12) então        
  SetPlotColor(1, clMaroon)
  
senão se(fechamento < Media21) então       
  SetPlotColor(1, clYellow)
  
senão se(fechamento > Media12) então
  SetPlotColor(1, clLime)
senão se(fechamento > Media21) então       
  SetPlotColor(1, clBlue);             

 //cores e estilos Médias moveis
SetPlotColor(1, clCream);
SetPlotWidth(1, EspessuraMedia);             
SetPlotColor(2, clCream);            
SetPlotColor(3, clYellow); 
SetPlotColor(4, clAqua);





Fim