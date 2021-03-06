## ----label=C11transfinite, echo=TRUE, cache=TRUE-------------------------
##  --------------------------------------------------------------------
##  t r a n s f i n i t e . R
##  --------------------------------------------------------------------

transfinite <- function(lower, upper, n = length(lower)) {
    stopifnot(is.numeric(lower), is.numeric(upper))
    if (any(is.na(lower)) || any(is.na(upper)))
        stop("Any 'NA's not allowed in 'lower' or 'upper' bounds.")
    if (length(lower) != length(upper))
        stop("Length of 'lower' and 'upper' bounds must be equal.")
    if (any(lower == upper))
        stop("No component of 'lower' can be equal to the one in 'upper'.")
    if (length(lower) == 1 && n > 1) {
        lower <- rep(lower, n)
        upper <- rep(upper, n)
    } else if (length(lower) != n)
        stop("If 'length(lower)' not equal 'n', then it must be one.")

    low.finite <- is.finite(lower)
    upp.finite <- is.finite(upper)
    c1 <- low.finite & upp.finite    # both lower and upper bounds are finite 
    c2 <- !(low.finite | upp.finite) # both lower and upper bounds infinite
    c3 <- !(c1 | c2) & low.finite    # finite lower bound, infinite upper bound
    c4 <- !(c1 | c2) & upp.finite    # finite upper bound, infinite lower bound

    q <- function(x) {
        if (any(x < lower) || any (x > upper)) 
            return(rep(NA, n))
        
        qx <- x
        qx[c1] <- atanh(2 * (x[c1] - lower[c1]) / (upper[c1] - lower[c1]) - 1)
        qx[c3] <- log(x[c3] - lower[c3])
        qx[c4] <- log(upper[c4] - x[c4])
        return(qx)
    }

    qinv <- function(x) {
        qix <- x
        qix[c1] <- lower[c1] + (upper[c1] - lower[c1])/2 * (1 + tanh(x[c1]))
        qix[c3] <- lower[c3] + exp(x[c3])
        qix[c4] <- upper[c4] - exp(x[c4])
        return(qix)
    }
    return(list(q = q, qinv = qinv))
}
