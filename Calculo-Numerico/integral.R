# funcao que quermos integrar
f <- function(x){exp(-(x^2))}

# funcao de integracao pelo metodos dos trapesios
integral <- function(f, interval, partitions = 1000)
{
  # tamanho do intervalo
  step <- (interval[2] - interval[1]) / partitions
  
  # vetor com os valores de x escolhidos 
  ## Sequencia de x0 a xn de step em step
  x <- seq(interval[1], interval[2], step)
  
  # resultado final da integracao
  result <- 0
  for(i in 1:length(x))
  {
    # somar os valores das areas dos trapesios
    if (i == 1 || i == length(x))
      result <- result + f(x[i])
    else # caso nao sejam o primeiro ou o ultimo valor, multiplicar por 2
      result <- result + (2 * f(x[i]))
  }
  # multiplica o resultado final multiplicado pela base do trapesio por 2
  result <- result * (step / 2)
  return(result)
}

#integral de teste
print(integral(f, c(0,1), 1000))
