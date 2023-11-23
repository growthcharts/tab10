#' Create coordinates to visualise the probability of an event
#'
#' @param n    Sample size
#' @param xlim Numerical vector of length 2 with minimum and maximum probability
#' @param ylim Numerical vector of length 2 regulating high of the bar
#' @param m    number of points to try each step
#' @param info logical. Should minimum distance between printed
#' @return A data frame with columns `x`, `y` and `case` (0 or 1)
#' @examples
#' p <- probability_bar(n = 1000, ylim = c(0, 0.2))
#' col <- c("navy", "red")[p$case + 1]
#' MASS::eqscplot(x = p$x, y = p$y, pch = 19, cex = 0.7, col = col)
#' @export
probability_bar <- function (n, xlim = c(0, 1), ylim = c(0, 1),
                             m = 10, info = TRUE)
{
  # Inspired on pracma::poisson2disk()
  sample1 <- function(n, xlim, ylim) {
    runif(n, min = c(xlim[1L], ylim[1L]), max = c(xlim[2L], ylim[2L]))
  }
  distmat <- function (X, Y)
  {
    if (!is.numeric(X) || !is.numeric(Y))
      stop("X and Y must be numeric vectors or matrices.")
    if (is.vector(X))
      dim(X) <- c(1, length(X))
    if (is.vector(Y))
      dim(Y) <- c(1, length(Y))
    if (ncol(X) != ncol(Y))
      stop("X and Y must have the same number of columns.")
    m <- nrow(X)
    n <- nrow(Y)
    XY <- X %*% t(Y)
    XX <- matrix(rep(apply(X * X, 1, sum), n), m, n, byrow = F)
    YY <- matrix(rep(apply(Y * Y, 1, sum), m), m, n, byrow = T)
    sqrt(pmax(XX + YY - 2 * XY, 0))
  }

  stopifnot(all(xlim >= 0 & xlim <= 1))
  stopifnot(all(ylim >= 0 & ylim <= 1))
  if (floor(n) != ceiling(n) || n < 1 || floor(m) != ceiling(m) ||
      m < 1)
    stop("n and m must be integer numbers.")
  A <- matrix(0, n, 2)
  A[1, ] <- sample1(2, xlim, ylim)
  i <- 2
  while (i <= n) {
    B <- matrix(sample1(2 * m, xlim, ylim), nrow = m, ncol = 2, byrow = TRUE)
    C <- distmat(B, A[1:(i - 1), ])
    k <- which.max(apply(C, 1, min))
    A[i, ] <- B[k, ]
    i <- i + 1
  }
  # draw colors proportional to X
  case <- rbinom(n, size = 1, prob = A[, 1])

  if (info) {
    AA <- distmat(A, A)
    diag(AA) <- max(AA)
    d <- sqrt(2 * (xlim[2] - xlim[1]) * (ylim[2] - ylim[1])/n)
    cat("Minimal Distance between points: ", min(AA), "\n")
  }

  return(data.frame(
    x = A[, 1],
    y = A[, 2],
    case = case
  ))
}
