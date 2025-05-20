library(ggplot2)
library(dplyr)
library(ggcorrplot)
library(corrplot)
library(psych)
library(factoextra)
library(cluster)

# Load the dataset (modify the path accordingly)
data<- read.csv("C:\\Users\\DELL\\Desktop\\audio_features (3).csv")
head(data,5)
 
colnames(data)
ncol(data)
nrow(data)
summary(data)
str(data)

sum(duplicated(data)) # duplication rows
data <- data[!duplicated(data), ]

sum(duplicated(t(data))) # duplication column

sum(is.na(data)) # check missing value in dataset
filtered_data<- na.omit(data) #remove rows with missing values

# Convert character to factor (only for categorical variables)
filtered_data <- filtered_data %>%
  mutate(across(where(is.character), as.factor))

# Convert TRUE/FALSE to 1/0
filtered_data$spotify_track_explicit <- as.numeric(filtered_data$spotify_track_explicit)

# Data Visualization

# Univerite Visualization
ggplot(filtered_data, aes(x = spotify_track_popularity)) +
  geom_histogram(bins = 30, fill = "darkorange2", color = "black") +
  labs(title = "Histogram of spotify_track_popularity", x = "spotify_track_popularity", y = "Frequency") +
  theme_minimal()

 
# Bivarite Visualization


#Categorical vs quantitative -> popularity by Explicitness
#Box plot
# Convert spotify_track_explicit to a factor to use as x-axis
filtered_data$spotify_track_explicit <- factor(filtered_data$spotify_track_explicit)

ggplot(filtered_data, aes(x = spotify_track_explicit, y = spotify_track_popularity, fill = spotify_track_explicit)) +
  geom_boxplot() +
  labs(
    title = "Box Plot: Popularity by Explicitness",
    x = "Explicit Content",
    y = "Popularity"
  ) +
  scale_fill_manual(values = c("lightblue", "lightcoral")) +
  theme_minimal()


#quantitative vs quantitative -> popularity Vs dancebility
#scatter plot
ggplot(filtered_data[1:3500,], aes(x = energy, y = spotify_track_popularity, color = spotify_track_explicit)) +
  geom_point() +
  labs(
    title = "Popularity Vs Energy",
    x = "Popularity",
    y = "Energy",
    color = "Explicit Content"
  ) +
  scale_color_manual(values = c("lightgoldenrod", "red4")) +
  theme_minimal()

#Multivarite  visuvaluzation

#install.packages("corrplot")

# Select numeric columns properly
num_vars <- filtered_data %>%
  select(spotify_track_popularity, danceability, energy, loudness, acousticness, liveness) %>%
  mutate(across(everything(), as.numeric))

# Now plot
corrplot(cor(num_vars), method = "color", addCoef.col = "black", number.cex = 0.7)




#make sure the data meet assumptions

#normality
hist(filtered_data$danceability, xlab = "danceability",col = "lightgreen",main = "Histogram of danceability")
 

#linearity
 plot(spotify_track_popularity ~ loudness, data =filtered_data,main = "Scatter Plot of Loudness Vs popularity", 
     xlab = "loudness", 
     ylab = "popularity", 
     pch = 20, col = "skyblue") 


# Simple Linear Model 
 lm_simple <- lm(spotify_track_popularity ~ loudness, data = filtered_data)
 summary(lm_simple)
 
# Multiple Linear Model
 lm_multiple <- lm(spotify_track_popularity ~ loudness + danceability + valence + energy, data = filtered_data)
 summary(lm_multiple)
 
 
#PCA
 pca <- prcomp(scale(num_vars))
 print(summary(pca))
 screeplot(pca, type = "lines", main = "Screeplot of PCA")
 
#Factor analysis
 
 fa_result <- fa(num_vars, nfactors = 2, rotate = "varimax")
 print(fa_result)
 
 cor_matrix <- cor(num_vars)
 eigen_values <- eigen(cor_matrix)$values
 
 scree_data <- data.frame(
   Factor = 1:length(eigen_values),
   Eigenvalue = eigen_values
 )
 
 ggplot(scree_data, aes(x = Factor, y = Eigenvalue)) +
   geom_line(color = "blue") +
   geom_point(color = "blue") +
   geom_hline(yintercept = 1, linetype = "dashed", color = "red") +
   annotate("text", x = 4, y = 1.1, label = "Kaiser Criterion (Eigenvalue = 1)", color = "red") +
   labs(
     title = "Scree Plot for Factor Analysis",
     x = "Factor Number",
     y = "Eigenvalue"
   ) +
   theme_minimal()

 
# Cluster Analysis
 
 # Select only numeric columns
 numeric_data <- filtered_data %>% select(where(is.numeric))
 
 # Scale the numeric data
 scaled_data <- scale(numeric_data)
 scaled_data_10 <- scaled_data[1:100, ]
 
 # Perform k-means clustering with 3 clusters
 res.km <- kmeans(scaled_data_10, centers = 3, nstart = 100)
 
 # View k-means clustering result
 print(res.km)
 
 kmeans_clusters <- as.data.frame(scaled_data_10)
 kmeans_clusters$Cluster <- as.factor(res.km$cluster)
 
 # Plot the clusters
 fviz_cluster(res.km, 
              data = scaled_data_10,
              palette = c("red", "blue", "green3"), 
              ellipse.type = "norm",
              star.plot = TRUE, 
              repel = TRUE,
              ggtheme = theme_minimal())
 
 # Calculate Euclidean distance matrix 
 res.dist <- dist(scaled_data_10, method = "euclidean")
 
 # View first 6x6 part of distance matrix
 x <- as.matrix(res.dist)[1:100, 1:100]
 x
 round(x, digits = 4)
 
 # Find the best number of clusters using Elbow Method
 fviz_nbclust(scaled_data_10, kmeans, method = "wss") +
   labs(subtitle = "Elbow Method for Finding Optimal K")
 
 # Perform hierarchical clustering
 res.hc <- hclust(d = res.dist, method = "complete")
 
 # Plot dendrogram
 plot(res.hc)
 
 rect.hclust(res.hc, k = 3, border = "red")  # Highlight 3 clusters
 
 
 fviz_dend(x = res.hc, cex = 0.8, lwd = 0.8, k = 3, 
           k_colors = c("green3", "blue", "red"))
 
 # Perform hierarchical clustering using different linkage methods
 # Single linkage
 res.hc_single <- hclust(d = res.dist, method = "single")
 # Plot dendrogram for single linkage
 plot(res.hc_single, main = "Single Linkage")
 rect.hclust(res.hc_single, k = 3, border = "red")  # Highlight 3 clusters for single linkage
 
 # Complete linkage
 res.hc_complete <- hclust(d = res.dist, method = "complete")
 # Plot dendrogram for complete linkage
 plot(res.hc_complete, main = "Complete Linkage")
 rect.hclust(res.hc_complete, k = 3, border = "red")  # Highlight 3 clusters for complete linkage
 
 # Average linkage
 res.hc_average <- hclust(d = res.dist, method = "average")
 # Plot dendrogram for average linkage
 plot(res.hc_average, main = "Average Linkage")
 rect.hclust(res.hc_average, k = 3, border = "red")  # Highlight 3 clusters for average linkage
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 

  
  
 















































































