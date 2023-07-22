# type: ignore
# flake8: noqa
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
# Importing the pandas library for data manipulation and analysis
import pandas as pd

# Importing the NumPy library for numerical operations
import numpy as np

# Importing the seaborn library for data visualization
import seaborn as sns

# Importing the matplotlib library for creating plots and charts
import matplotlib.pyplot as plt

# Importing the nltk library for natural language processing tasks
import nltk

# Importing the re module for regular expressions
import re

# Importing stopwords from the nltk.corpus module
from nltk.corpus import stopwords

# Importing the WordNetLemmatizer from the nltk.stem module
from nltk.stem import WordNetLemmatizer

# Importing Counter from the collections module
from collections import Counter

# Importing train_test_split for splitting the data into training and testing sets
from sklearn.model_selection import train_test_split,  cross_val_score

# Importing the MinMaxScaler for feature scaling
from sklearn.preprocessing import MinMaxScaler

# Importing the RandomForestClassifier from the sklearn.ensemble module
from sklearn.ensemble import RandomForestClassifier

# Importing evaluation metrics from the sklearn.metrics module
from sklearn.metrics import (

    cohen_kappa_score,
    roc_auc_score,
    accuracy_score,
    precision_score,
    recall_score,
    confusion_matrix,
)

# Importing GridSearchCV from the sklearn.model_selection module
from sklearn.model_selection import GridSearchCV
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
# Read the CSV file into a DataFrame
games = pd.read_csv("Final_dev_pub.csv")
games.dropna(inplace=True)
print(games.shape)


# Define rating ranges and corresponding labels
rating_ranges = [(0, 67, "Poor"),
                 (68, 72, "Mixed"),
                 (73, 76, "Good"),
                 (77, 80, "Great"),
                 (81, 84, "Excellent"),
                 (85, 100, "Masterpiece")]

# Create a new column for the categorical labels
games["metacritic_category"] = pd.cut(
    games["metacritic"],
    bins=[r[0] for r in rating_ranges] + [101],
    labels=[r[2] for r in rating_ranges],
    right=False
)

# Convert "released" column to datetime type
games["released"] = pd.to_datetime(games["released"])

def get_season(date):
    if date.month in (3, 4, 5):
        return "Spring"
    elif date.month in (6, 7, 8):
        return "Summer"
    elif date.month in (9, 10, 11):
        return "Fall"
    elif date.month in (12, 1, 2):
        return "Winter"
    else:
        return "Invalid date"

# Apply the get_season function to the "released" column and create the "season" column
games["season"] = games["released"].apply(get_season)

# Print the first 5 rows with the new "season" column
print(games.head(5))
print("Shape:", games.shape)

# Define the playtime ranges and corresponding categories
playtime_ranges = [(0, 10), (11, 50), (51, 100), (101, float('inf'))]
playtime_categories = ['Novice', 'Casual', 'Experienced', 'Veteran']

# Create a new column with categorical values based on playtime
games['playtime_category'] = pd.cut(
    games['playtime'],
    bins=[range[0] - 1 for range in playtime_ranges] + [playtime_ranges[-1][1]],
    labels=playtime_categories
)

# Drop the missing values
games.dropna(inplace=True)

#
#
#
# Clean up the genres column
games['genres'] = games['genres'].str.replace('\[.*?\]', '')  # Remove anything within square brackets [...]
games['genres'] = games['genres'].str.replace('\(.*?\)', '')  # Remove anything within parentheses (...)
games['genres'] = games['genres'].str.strip()  # Remove leading/trailing whitespace

# Split the genres and create new rows
new_rows = []
for index, row in games.iterrows():
    genres = row["genres"].split(",")
    for genre in genres:
        genre = genre.strip()
        if "-" in genre:
            genre_parts = genre.split("-")
            genre_parts = [part.capitalize() for part in genre_parts]
            genre = "-".join(genre_parts)
        elif "\n" in genre:
            genre_parts = genre.split("\n")
            genre_parts = [part.capitalize() for part in genre_parts]
            genre = " ".join(genre_parts)
        else:
            genre = genre.capitalize()

        # Create a dictionary to store the information for each subgenre row
        new_row = {"subgenres": genre}

        # Copy the relevant information from the other columns of the original DataFrame
        for col in games.columns:
            if col != "genres" and col != "subgenres":
                new_row[col] = row[col]

        new_rows.append(new_row)

# Update the DataFrame from the new rows
games = pd.DataFrame(new_rows)

# Capitalize the "subgenres" column
games['subgenres'] = new_games['subgenres'].str.title()

# Display the updated dataset with subgenres information
print(games)

# List all the columns in the DataFrame 'games'
print(list(games.columns))
#
#
#
#
#
#
#
# ADD FEATURE: Multi-Platform, etc.

# List of platform columns to check for multiple true values
platform_columns = ["PC", "macOS", "Linux", "Xbox One", "PlayStation 4", "Nintendo Switch",
                    "Wii U", "Xbox 360", "PlayStation 3", "Xbox", "PlayStation 2",
                    "Xbox Series S/X", "Nintendo 3DS", "PlayStation 5", "GameCube"]

# Create a new column "Multiplatform" where the value is 1 if there are more than one true values in the platform columns
games["Multiplatform"] = games[platform_columns].apply(lambda row: sum(row), axis=1).apply(lambda x: 1 if x > 1 else 0)

# Print the updated 'games' to see the new "Multiplatform" column
print(games)


# ADD FEATURE: year

# Step 1: Convert the 'released' column to datetime type
games['released'] = pd.to_datetime(games['released'])

# Step 2: Extract the year and create a new column 'year'
games['year'] = games['released'].dt.year

# ADD FEATURE: metacritic trend line

# Step 1: Group the data by year and category, calculate the average score
grouped = games.groupby(['year', 'metacritic_category']).agg(avg_score=('metacritic', 'mean')).reset_index()

# Step 2: Calculate the year-over-year difference in scores
grouped['yoy_diff'] = grouped.groupby('metacritic_category')['avg_score'].diff()

# Step 3: Create the trend line column
grouped['trend_line_metacritic_yoy'] = ''

# Step 4: Assign the trend line values based on the year-over-year difference
grouped.loc[grouped['yoy_diff'] > 0, 'trend_line_metacritic_yoy'] = 'Positive'
grouped.loc[grouped['yoy_diff'] < 0, 'trend_line_metacritic_yoy'] = 'Negative'
grouped.loc[grouped['yoy_diff'] == 0, 'trend_line_metacritic_yoy'] = 'Stable'

# Merge the trend line column back into the 'games' DataFrame
games = pd.merge(games, grouped[['year', 'metacritic_category', 'trend_line_metacritic_yoy']], on=['year', 'metacritic_category'], how='left')

# ADD FEATURE: playtime trend line

# Step 1: Group the data by year and calculate the average playtime
grouped = games.groupby('year')['playtime'].mean().reset_index()

# Step 2: Calculate the year-over-year difference in playtime
grouped['yoy_diff'] = grouped['playtime'].diff()

# Step 3: Create the trend line column
grouped['trend_line_playtime_yoy'] = ''

# Step 4: Assign the trend line values based on the year-over-year difference
grouped.loc[grouped['yoy_diff'] > 0, 'trend_line_playtime_yoy'] = 'Increasing'
grouped.loc[grouped['yoy_diff'] < 0, 'trend_line_playtime_yoy'] = 'Decreasing'
grouped.loc[grouped['yoy_diff'] == 0, 'trend_line_playtime_yoy'] = 'Stable'

# Merge the trend line column back into the 'games' DataFrame
games = pd.merge(games, grouped[['year', 'trend_line_playtime_yoy']], on='year', how='left')

# ADD FEATURES: playtime quartiles

# Step 1: Calculate the quartiles for playtime
quartiles = np.linspace(0, 1, num=5)  # Split into quartiles (0%, 25%, 50%, 75%, 100%)

# Step 2: Create the playtime quartile labels
quartile_labels = ['Q1', 'Q2', 'Q3', 'Q4']

# Step 3: Assign quartile labels to playtime quartiles
games['playtime_quartile'] = pd.qcut(games['playtime'], quartiles, labels=quartile_labels, duplicates='drop')

# Fill missing values with a default label if any
games['playtime_quartile'] = games['playtime_quartile'].cat.add_categories('N/A').fillna('N/A')


# ADD FEATURES: playtime ratios

# Step 1: Calculate the maximum playtime in the dataset
max_playtime = games['playtime'].max()

# Step 2: Create the playtime ratio feature
games['playtime_ratio'] = games['playtime'] / max_playtime


# ADD FEATURES: interactions variables

# DO NOT ADD AT THIS MOMENT

games.head(10)
print(list(games.columns))
#
#
#
# Save the 'id' column before removing it from the DataFrame
id_column = games['id']

# Remove the specified columns
columns_to_remove = ['id', 'background_image', 'metacritic', 'name', 'playtime', 'description', 'released', 'developers', 'publishers','n']
games.drop(columns_to_remove, axis=1, inplace=True)
print(games.shape)

modelDs = games
print(list(modelDs.columns))
#
#
#
#
#
columns_to_dummy = ['esrb_rating_name', 'genre', 'season', 'subgenres',
                    'playtime_category', 'subgenres', 'year',
                    'trend_line_metacritic_yoy', 'trend_line_playtime_yoy',
                    'playtime_quartile']

print("Shape of modelDs DataFrame:", modelDs.shape)
print("Number of columns in modelDs DataFrame:", modelDs.shape[1])
print("Expected number of columns:", len(columns_to_dummy))
print("Columns to dummy:", columns_to_dummy)

prefix = columns_to_dummy[:-1]  # Remove the last element from the prefix list

dummy_cols = pd.get_dummies(modelDs[columns_to_dummy], prefix=prefix, drop_first=True)
modelDs = pd.concat([modelDs, dummy_cols], axis=1)
modelDs.drop(columns_to_dummy, axis=1, inplace=True)

modelDs
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
# Split the data into features (X) and target (y)
X = modelDs.drop('metacritic_category', axis=1)  # Features (input variables)
y = modelDs['metacritic_category']  # Target variable

# Split the data into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=154)

# Define the final hyperparameters
param_grid = {
    'n_estimators': 300,
    'max_depth': None,
    'min_samples_split': 2,
    'min_samples_leaf': 1,
    'criterion': 'entropy',
    'min_impurity_decrease': 0.0
}

# Create the RandomForestClassifier instance with the final hyperparameters
rf_classifier = RandomForestClassifier(**param_grid)

# Perform cross-validation and print out the average accuracy
cv_scores = cross_val_score(rf_classifier, X_train, y_train, cv=5)
print("Cross-Validation Scores:", cv_scores)
print("Average Accuracy:", cv_scores.mean())

# Fit the classifier to the training data
rf_classifier.fit(X_train, y_train)

# Use the trained classifier for predictions
y_pred = rf_classifier.predict(X_test)

# Make predictions with class probabilities
y_pred_prob = rf_classifier.predict_proba(X_test)

# Calculate ROC AUC score
roc_auc = roc_auc_score(y_test, y_pred_prob, multi_class='ovr')
print(f"ROC AUC: {roc_auc}")

# Calculate Kappa coefficient
kappa = cohen_kappa_score(y_test, y_pred)
print(f"Kappa: {kappa}")

# Calculate accuracy
accuracy = accuracy_score(y_test, y_pred)
print(f"Accuracy: {accuracy}")

# Calculate precision
precision = precision_score(y_test, y_pred, average='weighted')
print(f"Precision: {precision}")

# Calculate recall
recall = recall_score(y_test, y_pred, average='weighted')
print(f"Recall: {recall}")

# Calculate confusion matrix
confusion = confusion_matrix(y_test, y_pred)
print("Confusion Matrix:")
print(confusion)


# Feature selection for the top 25 features overall
rf_classifier.fit(X_train, y_train)
feature_importances = rf_classifier.feature_importances_
top_features_indices = feature_importances.argsort()[-22:][::-1]
top_features = X_train.columns[top_features_indices].tolist()

# Select the top 25 features overall to create a new dataset
X_train_selected = X_train[top_features]
X_test_selected = X_test[top_features]

# Train the final classifier with the selected features
final_rf_classifier = RandomForestClassifier(**param_grid)
final_rf_classifier.fit(X_train_selected, y_train)

# Use the final model for predictions
y_pred_final = final_rf_classifier.predict(X_test_selected)

# Make predictions with class probabilities using the final model
y_pred_prob_final = final_rf_classifier.predict_proba(X_test_selected)

# Evaluate the final model
# Calculate ROC AUC score for the final model
roc_auc_final = roc_auc_score(y_test, y_pred_prob_final, multi_class='ovr')
print(f"ROC AUC (Final Model): {roc_auc_final}")

# Calculate Kappa coefficient for the final model
kappa_final = cohen_kappa_score(y_test, y_pred_final)
print(f"Kappa (Final Model): {kappa_final}")

# Calculate accuracy for the final model
accuracy_final = accuracy_score(y_test, y_pred_final)
print(f"Accuracy (Final Model): {accuracy_final}")

# Calculate precision for the final model
precision_final = precision_score(y_test, y_pred_final, average='weighted', zero_division='warn')
print(f"Precision (Final Model): {precision_final}")

# Calculate recall for the final model
recall_final = recall_score(y_test, y_pred_final, average='weighted', zero_division='warn')
print(f"Recall (Final Model): {recall_final}")

# Calculate confusion matrix for the final model
confusion_final = confusion_matrix(y_test, y_pred_final)
print("Confusion Matrix (Final Model):")
print(confusion_final)

#
#
#
#
print(X_train_selected.columns)
#
#
#
#
#
#
#
#
#
#
#
from sklearn.svm import SVC

# Create the SVM classifier
svm_classifier = SVC(probability = True)

# Perform cross-validation and print out the average accuracy
cv_scores_svm = cross_val_score(svm_classifier, X_train, y_train, cv=5)
print("SVM Cross-Validation Scores:", cv_scores_svm)
print("Average SVM Accuracy:", cv_scores_svm.mean())

# Fit the SVM classifier to the training data
svm_classifier.fit(X_train, y_train)

# Use the trained SVM classifier for predictions
y_pred_svm = svm_classifier.predict(X_test)

# Make predictions with class probabilities
y_pred_prob_svm = svm_classifier.predict_proba(X_test)

# Calculate ROC AUC score
roc_auc_svm = roc_auc_score(y_test, y_pred_prob_svm, multi_class='ovr')
print(f"ROC AUC (SVM): {roc_auc_svm}")

# Calculate Kappa coefficient
kappa_svm = cohen_kappa_score(y_test, y_pred_svm)
print(f"Kappa (SVM): {kappa_svm}")

# Calculate accuracy
accuracy_svm = accuracy_score(y_test, y_pred_svm)
print(f"Accuracy (SVM): {accuracy_svm}")

# Calculate precision
precision_svm = precision_score(y_test, y_pred_svm, average='weighted')
print(f"Precision (SVM): {precision_svm}")

# Calculate recall
recall_svm = recall_score(y_test, y_pred_svm, average='weighted')
print(f"Recall (SVM): {recall_svm}")

# Calculate confusion matrix
confusion_svm = confusion_matrix(y_test, y_pred_svm)
print("Confusion Matrix (SVM):")
print(confusion_svm)
#
#
#
#
from sklearn.linear_model import LogisticRegression

# Create the Logistic Regression classifier
logreg_classifier = LogisticRegression()

# Perform cross-validation and print out the average accuracy
cv_scores_logreg = cross_val_score(logreg_classifier, X_train, y_train, cv=5)
print("Logistic Regression Cross-Validation Scores:", cv_scores_logreg)
print("Average Logistic Regression Accuracy:", cv_scores_logreg.mean())

# Fit the Logistic Regression classifier to the training data
logreg_classifier.fit(X_train, y_train)

# Use the trained Logistic Regression classifier for predictions
y_pred_logreg = logreg_classifier.predict(X_test)

# Make predictions with class probabilities
y_pred_prob_logreg = logreg_classifier.predict_proba(X_test)

# Calculate ROC AUC score
roc_auc_logreg = roc_auc_score(y_test, y_pred_prob_logreg, multi_class='ovr')
print(f"ROC AUC (Logistic Regression): {roc_auc_logreg}")

# Calculate Kappa coefficient
kappa_logreg = cohen_kappa_score(y_test, y_pred_logreg)
print(f"Kappa (Logistic Regression): {kappa_logreg}")

# Calculate accuracy
accuracy_logreg = accuracy_score(y_test, y_pred_logreg)
print(f"Accuracy (Logistic Regression): {accuracy_logreg}")

# Calculate precision
precision_logreg = precision_score(y_test, y_pred_logreg, average='weighted')
print(f"Precision (Logistic Regression): {precision_logreg}")

# Calculate recall
recall_logreg = recall_score(y_test, y_pred_logreg, average='weighted')
print(f"Recall (Logistic Regression): {recall_logreg}")

# Calculate confusion matrix
confusion_logreg = confusion_matrix(y_test, y_pred_logreg)
print("Confusion Matrix (Logistic Regression):")
print(confusion_logreg)

#
#
#
#
from sklearn.ensemble import GradientBoostingClassifier

# Create the Gradient Boosting classifier
gb_classifier = GradientBoostingClassifier()

# Perform cross-validation and print out the average accuracy
cv_scores_gb = cross_val_score(gb_classifier, X_train, y_train, cv=5)
print("Gradient Boosting Cross-Validation Scores:", cv_scores_gb)
print("Average Gradient Boosting Accuracy:", cv_scores_gb.mean())

# Fit the Gradient Boosting classifier to the training data
gb_classifier.fit(X_train, y_train)

# Use the trained Gradient Boosting classifier for predictions
y_pred_gb = gb_classifier.predict(X_test)

# Make predictions with class probabilities
y_pred_prob_gb = gb_classifier.predict_proba(X_test)

# Calculate ROC AUC score
roc_auc_gb = roc_auc_score(y_test, y_pred_prob_gb, multi_class='ovr')
print(f"ROC AUC (Gradient Boosting): {roc_auc_gb}")

# Calculate Kappa coefficient
kappa_gb = cohen_kappa_score(y_test, y_pred_gb)
print(f"Kappa (Gradient Boosting): {kappa_gb}")

# Calculate accuracy
accuracy_gb = accuracy_score(y_test, y_pred_gb)
print(f"Accuracy (Gradient Boosting): {accuracy_gb}")

# Calculate precision
precision_gb = precision_score(y_test, y_pred_gb, average='weighted')
print(f"Precision (Gradient Boosting): {precision_gb}")

# Calculate recall
recall_gb = recall_score(y_test, y_pred_gb, average='weighted')
print(f"Recall (Gradient Boosting): {recall_gb}")

# Calculate confusion matrix
confusion_gb = confusion_matrix(y_test, y_pred_gb)
print("Confusion Matrix (Gradient Boosting):")
print(confusion_gb)

#
#
#
