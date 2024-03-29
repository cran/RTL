#' EIA weekly supply-demand information by product group
#' @description Given a product group extracts all information to create SD Balances.
#' @param market "mogas", "dist", "jet" or "resid". `character`
#' @param key Your private EIA API token. `character`
#' @param from Date as character "2020-07-01". Default to all dates available. `character`
#' @param legend.pos Defaults to list(x = 0.4, y = 0.53). `list`
#' @param output "chart" for plotly object or "data" for dataframe.
#' @returns A plotly chart `htmlwidget` or a `tibble`.
#' @export chart_eia_sd
#' @author Philippe Cote
#' @examples
#' \dontrun{
#' chart_eia_sd(key = key, market = "mogas")
#' }
#'
chart_eia_sd <- function(market = "mogas",
                         key = "your EIA.gov API key",
                         from = "2011-01-01",
                         legend.pos = list(x = 0.4, y = 0.53),
                         output = "chart") {
  df <- tickers_eia %>%
    dplyr::filter(sd_category == market) %>%
    dplyr::mutate(tick.r = stringr::str_replace_all(tick.r, paste0("eia.", market, "."), ""))
  eia_df <- tibble::tribble(~ticker, ~name) %>%
    dplyr::add_row(ticker = df$tick.eia[1:nrow(df)], name = df$category[1:nrow(df)]) %>%
    RTL::eia2tidy_all(key = key, long = FALSE) %>%
    dplyr::mutate(balance = imports + supply - exports - demand)
  if (!is.null(from)) {
    eia_df <- eia_df %>% dplyr::filter(date >= from)
  }

  fig.title <- paste0(stringr::str_to_title(market), " US SD Balance Components (kbd) and Stocks (kbs)")

  if (output == "data") {
    return(eia_df)
  } else {
    out <- eia_df %>%
      tidyr::pivot_longer(-date, names_to = "series", values_to = "value") %>%
      dplyr::mutate(group = dplyr::case_when(series == "stocks" ~ 2, TRUE ~ 1)) %>%
      split(.$group) %>%
      lapply(function(d) {
        plotly::plot_ly(d,
          x = ~date, y = ~value,
          color = ~series, colors = c("red", "black", "blue"),
          type = c("scatter"), mode = "lines"
        )
      }) %>%
      plotly::subplot(nrows = NROW(.), shareX = TRUE) %>%
      plotly::layout(
        title = list(text = fig.title, x = 0),
        xaxis = list(title = " "),
        yaxis = list(title = "kbd"),
        legend = legend.pos
      )
    return(out)
  }
}
