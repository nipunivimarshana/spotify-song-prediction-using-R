# 🎵 Statistical Analysis of Spotify Songs Audio Features Dataset

## 📘 Overview
This project presents a comprehensive statistical analysis of the Billboard Hot 100 Spotify tracks from 2000 to 2019. The analysis explores the relationships between audio features and track popularity using a variety of statistical and machine learning techniques implemented in **R**.

## 🧠 Objectives
- Visualize and interpret audio characteristics of Spotify tracks.
- Build predictive models to estimate song popularity.
- Perform dimensionality reduction (PCA, Factor Analysis).
- Cluster similar songs based on audio attributes.

## 📊 Dataset Summary
- **Source**: Billboard Hot 100 and Spotify Web API
- **Size**: 29,479 tracks with 22 attributes
- **Key Audio Features**: Danceability, Energy, Loudness, Valence, Tempo, Popularity, etc.
- **Completeness**: No missing values in key audio variables

## 🧹 Data Preparation
- Removal of duplicates and missing values
- Categorical conversions (e.g., genre, mode)
- Feature scaling and standardization for multivariate analysis

## 📈 Analyses Performed

### 🔹 Univariate & Bivariate Visualization
- Histograms, Box plots, and Scatter plots
- Insights into explicitness, popularity, and genre distributions

### 🔹 Regression Modeling
- **Simple Linear Regression**: Popularity ~ Loudness  
- **Multiple Linear Regression**: Popularity ~ Loudness + Energy + Valence + Danceability  
- Key finding: Energy and Loudness are significant predictors of popularity

### 🔹 Multivariate Analysis
- **PCA**: Reduced six features to four principal components, explaining 87% of total variance
- **Factor Analysis**: Identified two latent factors — "Energy & Loudness" and "Popularity & Danceability"

### 🔹 Clustering
- Hierarchical clustering using single, average, and complete linkage
- Identified distinct clusters based on energy, tempo, and loudness

## 📌 Key Insights
- High energy and loud tracks are generally more popular
- Explicit songs tend to have higher popularity
- PCA and clustering help in discovering meaningful song groupings

## 🚧 Challenges
- Multicollinearity between features like energy and loudness
- Class imbalance in popularity scores

## 🛠 Technologies Used
- **Language**: R
- **Libraries**: `ggplot2`, `dplyr`, `corrplot`, `psych`, `factoextra`

## 👨‍💻 Team Members
- D.B.Yatigammana (22UG1-0041)
- H.M.N.V.Herath (22UG1-0819)
- S.M.C.Sankalpana (22UG1-0481)
- K.M.L.Madushan (22UG1-0824)
- N.K.B.N.Silva (22UG1-0477)
- D.K.Nivedya (22UG1-0883)

## 📚 References
- Billboard Hot 100 – Wikipedia  
- Spotify Web API  
- Dataset Source: Data.World
