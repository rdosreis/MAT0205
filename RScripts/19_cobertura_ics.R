# ---------------------------------
# Pacotes
# ---------------------------------

library(samplingbook)

# ---------------------------------
# Parâmetros da simulação
# ---------------------------------

P <- 0.3 # proporção pop.
N <- 10000 # tamanho da pop.
Y <- c(rep(0, N - N*P),
       rep(1, N*P)) # característica Y

n <- 100 # tamanho da amostra
ic.conf <- 0.95 # probabilidade de confiança dos ICs

M <- 1000 # número de réplicas de MC

# vetores para armazenar avaliação da cobertura
# e amplitude dos IC em cada réplica de MC
cobertura.ic.p.aprox <- vector(length = M)
cobertura.ic.p.exato <- vector(length = M)
amplitude.ic.p.aprox <- vector(length = M)
amplitude.ic.p.exato <- vector(length = M)

set.seed(2358)
# ---------------------------------
# Simulação Monte Carlo
# ---------------------------------

for (i in 1:M){
  # sorteia a amostra
  id_amostra <- sample(x = 1:N, size = n, replace = FALSE)
  
  # número de unidades tipo C na amostra
  a <- sum(Y[id_amostra])
  
  # construção ICs aproximado (normal) e exato para P
  ic.p <- Sprop(m = a, n = n, N = N, level = ic.conf)
  
  # avalia se IC contém o verdadeiro parâmetro P
  cobertura.ic.p.aprox[i] <- ifelse(
    test = (ic.p$ci$approx[1] <= P & ic.p$ci$approx[2] >= P),
    1, 0)
  
  cobertura.ic.p.exato[i] <- ifelse(
    test = (ic.p$ci$exact[1] <= P & ic.p$ci$exact[2] >= P),
    1, 0)
  
  # amplitude do IC
  amplitude.ic.p.aprox[i] <- diff(ic.p$ci$approx)
  amplitude.ic.p.exato[i] <- diff(ic.p$ci$exact)
  
}

# ---------------------------------
# Coberturas e amplitudes MC
#   dos ICs de 95% para P
# ---------------------------------

mean(cobertura.ic.p.aprox); mean(amplitude.ic.p.aprox)
mean(cobertura.ic.p.exato); mean(amplitude.ic.p.exato)
