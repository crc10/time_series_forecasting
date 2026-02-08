#' Validation Croisée Glissante (Rolling Origin)
#'
#' Applique une validation croisée sur les derniers jours de la série.
#'
#' @param ts_data Vecteur numérique. La série temporelle complète (nettoyée).
#' @param forecast_func Une fonction de prévision qui accepte (train_set, h).
#' @param h Horizon de prévision (défaut 96).
#' @param n_folds Nombre de jours à tester (défaut 7).
#'
#' @return Un vecteur avec le MAPE moyen et le RMSE moyen.
#' @export
cross_validate <- function(ts_data, forecast_func, h = 96, n_folds = 7) {
  n <- length(ts_data)
  mapes <- c()
  rmses <- c()

  for (i in 1:n_folds) {
    # On recule de 'i' horizons pour définir la fin de l'entrainement
    # Ex: Si i=1, on s'arrête juste avant le dernier jour.
    # Si i=7, on s'arrête 7 jours avant la fin.
    train_end <- n - (i * h)

    # Sécurité : vérifier qu'on ne sort pas des bornes
    if (train_end < 1) break

    # Découpage (Indices simples, marche sur vecteur et ts)
    train_set <- ts_data[1:train_end]
    real_val  <- ts_data[(train_end + 1):(train_end + h)]

    # Appel de la fonction de prévision générique
    # Note: On attend que forecast_func renvoie juste le vecteur de prévision
    pred_values <- forecast_func(train_set, h)

    # Calcul métriques
    metrics <- accuracy_metrics(pred_values, real_val)
    mapes <- c(mapes, metrics["MAPE"])
    rmses <- c(rmses, metrics["RMSE"])
  }

  return(c(MAPE = mean(mapes, na.rm = TRUE), RMSE = mean(rmses, na.rm = TRUE)))
}
