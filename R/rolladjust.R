#' Adjusts daily returns for futures contracts roll
#' @description Returns a xts price or return object adjusted for contract roll. The methodology used to adjust returns is to remove the daily returns on the day after expiry and for prices to adjust historical rolling front month contracts by the size of the roll at each expiry. This is conducive to quantitative trading strategies as it reflects the PL of a financial trader.
#' @param x A df of returns.
#' @param commodityname Name of commodity in expiry_table: unique(expiry_table$cmdty) or "cmecan" for WCW
#' @param rolltype Type of contract roll: "Last.Trade" or "First.Notice".
#' @param ... Other parms
#' @return Roll-adjusted xts object of returns
#' @export rolladjust
#' @author Philippe Cote
#' @examples
#' ret <- dplyr::tibble(date = seq.Date(Sys.Date() - 60, Sys.Date(), 1), CL01 = rnorm(61, 0, 1))
#' rolladjust(x = ret, commodityname = c("cmewti"), rolltype = c("Last.Trade"))
rolladjust <- function(x, commodityname = c("cmewti"), rolltype = c("Last.Trade"), ...) {
  if (!(commodityname %in% c(unique(RTL::expiry_table$cmdty), "cmecan"))) stop("Unknown commodityname: Type unique(expiry_table$cmdty) for available selection")
  if (!(rolltype %in% c("Last.Trade", "First.Notice"))) stop("Incorrect rolltype specified")

  seriesname <- names(x)

  if (commodityname == "cmecan") {
    table <- tradeCycle %>%
      dplyr::filter(market == "canada") %>%
      dplyr::select(trade.cycle.end) %>%
      .[[1]]
  } else {
    table <- subset(RTL::expiry_table, cmdty == commodityname)
    if (rolltype == "Last.Trade") {
      table <- table$Last.Trade
    }
    if (rolltype == "First.Notice") {
      table <- table$First.Notice
    }
  }

  x$expiry <- 0
  x$date <- as.Date(x$date)
  table <- as.Date(table)

  if (class(x)[1] == "xts") {
    for (i in 1:length(table)) {
      x$expiry[as.Date(zoo::index(x)) == table[i]] <- 1
    }
    x$expiry <- stats::lag(x$expiry, lag = 1, arithmetic = FALSE)
    x$expiry[is.na(x$expiry)] <- 0
    x <- x[x$expiry != 1]
    x$expiry <- NULL
  }

  if (class(x)[1] != "xts") {
    for (i in 1:length(table)) {
      x <- x %>% dplyr::mutate(expiry = ifelse(date %in% table, 1, 0))
      # x$expiry[x$date==table[i]] <- 1
    }
    x$expiry <- dplyr::lag(x$expiry)
    # x$expiry <- stats::lag(x$expiry,lag=1,arithmetic=FALSE)
    # x$expiry[is.na(x$expiry)]<- 0
    x <- x %>%
      dplyr::filter(expiry != 1) %>%
      dplyr::select(-expiry)
  }

  return(x)
}
