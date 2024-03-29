#' Plots historical forward curves
#' @description Returns a plot of forward curves through time
#' @param df Wide dataframe with date column and multiple series columns (multivariate). `tibble`
#' @param cmdty Futures contract code in expiry_table object: unique(expiry_table$cmdty). `character`
#' @param weekly Defaults to TRUE for weekly forward curves. `logical`
#' @param ... other graphical parameters
#' @returns plot of forward curves through time. `NULL`
#' @export chart_fwd_curves
#' @author Philippe Cote
#' @examples
#' df <- dfwide %>%
#'   dplyr::select(date, dplyr::starts_with("CL")) %>%
#'   tidyr::drop_na()
#' chart_fwd_curves(
#'   df = df, cmdty = "cmewti", weekly = TRUE,
#'   main = "WTI Forward Curves", ylab = "$ per bbl", xlab = "", cex = 2
#' )
chart_fwd_curves <- function(df = dfwide, cmdty = "cmewti", weekly = TRUE, ...) {
  term <- stats::na.omit(as.numeric(gsub("[^0-9]", "", colnames(df))))
  if (tibble::is_tibble(df)) {
    df <- as.data.frame(df)
  }
  tmp <- xts::xts(df[, -1], order.by = df[, 1])
  if (weekly == TRUE) {
    tmp <- xts::apply.weekly(tmp, xts::last)
  }
  price <- as.matrix(zoo::coredata(tmp))
  rownames(price) <- as.character(as.Date(zoo::index(tmp)))

  ttm <- matrix(term, nrow(tmp), ncol(tmp), byrow = TRUE)
  rownames(ttm) <- as.character(as.Date(zoo::index(tmp)))
  expiry <- RTL::expiry_table[RTL::expiry_table$cmdty == cmdty, ]$Last.Trade
  ttmxts <- xts::as.xts(ttm)

  contracts <- NULL
  contracts <- ncol(ttmxts)
  for (i in 1:nrow(ttmxts)) {
    d <- as.Date(zoo::index(ttmxts[i, ]))
    ttmxts[i, ] <- as.numeric(expiry[d <= expiry][1:contracts] - d)
  }

  ttm <- as.matrix(ttmxts)
  futures <- list("price" = price, "ttm" = ttm)

  ## charting
  dates <- as.Date(rownames(futures$ttm))
  graphics::plot(dates, futures$price[, 1], xlim = c(min(dates), max(dates) + max(futures$ttm[nrow(futures$ttm), ], na.rm = TRUE)), ylim = range(futures$price, na.rm = TRUE), type = "l", ...)
  col <- grDevices::rainbow(10)
  col.idx <- rep(1:length(col), length = nrow(futures$price))
  tmp.data <- cbind(futures$price, futures$ttm, data.frame(col.idx), 1:nrow(futures$price))
  plot.forward.curve <- function(x, col, d, dates) {
    graphics::lines(dates[x[2 * d + 2]] + c(0, x[(d + 1):(2 * d)]), x[c(1, 1:d)], col = col[x[2 * d + 1]], lty = "dotted")
  }
  apply(tmp.data, 1, plot.forward.curve, d = ncol(futures$ttm), col = col, dates = dates)
  graphics::legend("topleft", legend = c("Front Contract", "Forward Curves"), lty = c("solid", "dotted"), bg = "white", cex = 0.75)
  graphics::grid()
}
