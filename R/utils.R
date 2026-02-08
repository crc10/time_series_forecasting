#' Nettoyage des données (Logique Partie 1)
#'
#' Remplace les valeurs inférieures à 130 kW par la moyenne des valeurs
#' aux mêmes heures les 3 jours précédents.
#'
#' @param numeric_vec Un vecteur numérique (la série temporelle).
#' @return Le vecteur nettoyé.
#' @export
clean_elec_data <- function(numeric_vec) {
  cleaned <- as.numeric(numeric_vec)
  idx_outliers <- which(cleaned < 130)

  for (i in idx_outliers) {
    if (i > (3 * 96)) {
      lags <- i - (1:3 * 96)
      cleaned[i] <- mean(cleaned[lags], na.rm = TRUE)
    }
  }
  return(cleaned)
}

#' Calcul du RMSE (Root Mean Squared Error)
#' @param actual Valeurs réelles
#' @param predicted Valeurs prédites
#' @export
calculate_rmse <- function(actual, predicted) {
  sqrt(mean((actual - predicted)^2, na.rm = TRUE))
}

#' Calcul du MAPE (Mean Absolute Percentage Error)
#' @param actual Valeurs réelles
#' @param predicted Valeurs prédites
#' @export
calculate_mape <- function(actual, predicted) {
  mean(abs((actual - predicted) / actual), na.rm = TRUE) * 100
}

#' Calcul des Métriques combinées
#'
#' @param forecast_val Vecteur des valeurs prédites.
#' @param real_val Vecteur des valeurs réelles.
#' @return Un vecteur nommé avec RMSE et MAPE.
#' @export
accuracy_metrics <- function(forecast_val, real_val) {
  # On réutilise les fonctions ci-dessus pour éviter de dupliquer le code
  c(
    RMSE = calculate_rmse(real_val, forecast_val),
    MAPE = calculate_mape(real_val, forecast_val)
  )
}
