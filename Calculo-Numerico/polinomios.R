library(ggplot2)

# funcao a interpolar
f <- function(x){(1/sqrt(pi))*exp(-(x^2))}

# metodo de interpolacao
interpolate <- function(f, interval, degree, precision=1000){
  # sequencia dos xi valores dentro do intervalo
  xn = seq(from=interval[1], to=interval[2], by=(interval[2]-interval[1])/degree)
  
  # data frame que guarda as ordens do calculo
  orders <- data.frame(xn, f(xn))
  
  for (j in 0:(degree-1))
  {
    aux <- c()
    for (i in 1:(degree-j))
    {
      aux[i] <- (orders[i + 1, j + 2] - orders[i, j + 2]) / (orders[i + (j + 1), 1] - orders[i, 1])
    }
    length(aux) <- degree + 1
    names <- names(orders)
    orders <- cbind(orders, aux)
    names[max(names)] <- paste("order", j+1)
    names(orders) <- names
  }
  
  # lambdas associados ao calculo do polinomio
  lambdas <- orders[1,2:(degree+2)]

  # vetor com os fatores associados a potencia zero
  conv <- c(1)
  # vetor dos coeficientes do polinomio
  poly_factors <- round(lambdas[1,1] * conv, digits=precision)
  
  # loop que roda ate um a menos que a potencia desejada
  for (i in 1:(length(xn)-1))
  {
    # convolucao dos coeficientes da potencia i-1 com os da proxima potencia
    conv <- convolve(conv, rev(c(1, -xn[i])), type="open")
    
    # adiciona os fatores aos antigos
    ## Multiplicamos pela lambda associada, adicionamos um 0 no vetor antigo e somamos
    poly_factors <- c(0, poly_factors) + round(lambdas[1, i + 1] * conv, digits=precision)
  }
  
  # mostra os coeficientes do polinomio adquirido
  print(poly_factors)
  
  # ajusta o polinomio encontrado para formar uma expression
  polynomial = ""
  poly_factors <- rev(poly_factors)
  for(i in length(poly_factors):2)
  {
    polynomial <- paste(polynomial, "(", format(round(poly_factors[i], digits=precision), scientific=FALSE), ")*x^", i - 1, " + ", sep="")
  }
  polynomial <- paste(polynomial, "(", format(round(poly_factors[1], digits=precision),scientific=FALSE), ")", sep="")
  
  print(paste("Expression:", polynomial)) # mostra a expressao
  exp <- parse(text = polynomial)
  
  # polinomial integration
  print(paste("Integral:", sum(poly_factors / (1:length(poly_factors)))))
  
  return(exp) # retorna a expressao para ser utilizada fora da funcao
}

exp <- interpolate(f, c(0,25), 10)
exp
