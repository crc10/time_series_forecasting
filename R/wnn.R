#' Weighted Nearest Neighbours Forecast
#'
#' Implements the WNN forecasting method described by Talavera-Llames et al. (2016).
#' It finds similar patterns (windows) in the history and aggregates their future values
#' based on distance-weighted averaging.
#'
#' @param timeseries Numeric vector. The historical time series data.
#' @param w Integer. The size of the window (pattern length). Default is 96 (one day).
#' @param h Integer. The forecasting horizon. Default is 96 (one day).
#' @param k Integer. The number of nearest neighbours to select. Default is 5.
#'
#' @return A numeric vector of length h containing the forecast.
#' @examples
#' \dontrun{
#'   # Generate dummy data
#'   data <- sin(seq(0, 100, 0.1)) + rnorm(1001, 0, 0.1)
#'   # Forecast next 20 points based on pattern of length 50
#'   pred <- wnn_forecast(data, w = 50, h = 20, k = 3)
#'   plot(pred, type = 'l')
#' }
#' @export
wnn_forecast <- function(timeseries, w = 96, h = 96, k = 5) {

  ts_vec <- as.numeric(timeseries)
  n <- length(ts_vec)

  # Safety checks
  if (n < (w + h)) {
    stop("Time series is too short for the specified w and h parameters.")
  }

  # 1. Extract the Query Pattern (the last w values)
  query_pattern <- ts_vec[(n - w + 1):n]

  # 2. Define the Valid History Range
  # We need windows that have 'h' known values following them.
  # Last start index possible: n - h - w + 1
  limit_index <- n - h - w + 1

  if (limit_index < 1) stop("Not enough history for training.")

  # 3. Create Lagged Matrix for fast distance computation
  # We look at data excluding the query pattern itself (and the h gap)
  # valid_history includes all points that can be part of a historical window
  end_of_history <- n - h
  valid_history_data <- ts_vec[1:end_of_history]

  distances <- numeric(limit_index)

  # Optimization: Calculate distances
  # Iterating is fast enough for N < 50,000 in R
  for (i in 1:limit_index) {
    # Extract candidate window
    candidate_window <- ts_vec[i:(i + w - 1)]

    # Euclidean Distance
    d <- sqrt(sum((candidate_window - query_pattern)^2))
    distances[i] <- d
  }

  # 4. Handle exact matches (distance 0) to avoid division by zero
  distances <- pmax(distances, 1e-10)

  # 5. Select k Nearest Neighbours
  sorted_indices <- order(distances) # Indices of the starts of the windows
  nearest_indices <- sorted_indices[1:k]
  nearest_dists <- distances[nearest_indices]

  # 6. Compute Weights (Inverse square distance)
  weights <- 1 / (nearest_dists^2)
  total_weight <- sum(weights)

  # 7. Aggregate Forecast
  final_forecast <- numeric(h)

  for (j in 1:k) {
    idx <- nearest_indices[j]
    # The future values are those immediately following the window
    # Window is [idx, idx+w-1], so Future is [idx+w, idx+w+h-1]
    future_values <- ts_vec[(idx + w):(idx + w + h - 1)]

    final_forecast <- final_forecast + (weights[j] * future_values)
  }

  return(final_forecast / total_weight)
}
