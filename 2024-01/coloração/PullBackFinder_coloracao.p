// Definir variáveis e parâmetros
var
  PullBackFinderValor: float;

Inicio
  // Calcular o valor do Nelogica PullBack Finder
  PullBackFinderValor := NelogicaPullBackFinder|1|;

  // Condições de Coloração
  Se (PullBackFinderValor > 0) então
    PaintBar(clGreen) // Tendência de alta - PullBack Finder acima de 0

  senão se (PullBackFinderValor < 0) então
    PaintBar(clRed); // Tendência de baixa - PullBack Finder abaixo de 0
fim
