# ReyCoquaisConstantin

## Overview

This R package constitutes the final delivery for the **Time Series Forecasting Academic Project**. 
The goal is to forecast the electricity consumption of a building (measured every 15 minutes) for a specific target day, using historical data from January 1st, 2010, to February 16th, 2010, along with outdoor temperature data.

The project is divided into two distinct parts:
1.  **Part 1**: Exploration and forecasting using classical methods (SARIMA, ETS, Neural Networks).
2.  **Part 2**: Implementation of the **Weighted Nearest Neighbors (WNN)** algorithm and performance comparison.

---

## 📂 Project Structure & Navigation

To ensure a smooth review process without long re-computation times, the project is organized as follows:

### 1. Part I: Classical Forecasting Models (Pre-rendered)
This part involves heavy computations (auto.arima, neural network training). To avoid long installation times, the full analysis has been **pre-rendered**.

* **Content**: Data exploration, cleaning, seasonality analysis, and model competition (ETS, SARIMA, NNAR).
* **How to access**:
    You can open the full PDF report directly from the installed package using:
    ```r
    # Open the pre-computed report (PDF)
    system.file("report_part1", "main.pdf", package = "ReyCoquaisConstantin") |> 
      browseURL()
    
    # Access the source code (.Rmd)
    system.file("report_part1", "main.Rmd", package = "ReyCoquaisConstantin") |> 
      file.edit()
    ```

### 2. Part II: WNN Implementation (Package)
The second part focuses on the implementation of the WNN method described by *Talavera-Llames et al. (2016)*. The algorithm is implemented as a native function of this package.

* **Main function**: `wnn_forecast()`
* **Demonstration**: A vignette is provided to demonstrate the usage of the function and benchmark it against the best model from Part 1.
    ```r
    # Open the comparison vignette
    vignette("comparaison_wnn", package = "ReyCoquaisConstantin")
    ```

### 3. Data & Resources
Raw data and subject documentation are stored within the package:
```r
# Path to the raw Excel file
system.file("extdata", "Elec-train.xlsx", package = "ReyCoquaisConstantin")

# Path to the WNN research paper
system.file("docs", "WNN_Paper.pdf", package = "ReyCoquaisConstantin")
```

🚀 Installation
You can install the package directly from the source file (.tar.gz) or via GitHub.

From Source (tar.gz)
```R
# Adapt the path to the file location
install.packages("path/to/ReyCoquaisConstantin_0.1.0.tar.gz", repos = NULL, type = "source")
```

From GitHub
```R
# install.packages("devtools")
devtools::install_github("ConstantinRey/ReyCoquaisConstantin")
```

📊 Summary of Methods

| Method | Type | Context | Status |
| :--- | :--- | :--- | :--- |
| SARIMA / Auto-ARIMA | Parametric | Part 1 | Implemented & Tuned |
| Exponential Smoothing (ETS) | Parametric | Part 1 | Implemented |
| Neural Networks (NNAR) | Stochastic | Part 1 | Implemented |
| WNN (Weighted Nearest Neighbors) | Non-Parametric | Part 2 | Core Feature of this Package |

Author
Constantin REY-COQUAIS Master SISE - 2026
