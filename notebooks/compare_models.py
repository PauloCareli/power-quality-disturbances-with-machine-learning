import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

from tabulate import tabulate

from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report, confusion_matrix
from sklearn.preprocessing import StandardScaler, MinMaxScaler, RobustScaler #scalers, robust works the best, needed for KNN

from sklearn.metrics import accuracy_score
from sklearn.metrics import precision_score
from sklearn.metrics import recall_score
from sklearn.metrics import f1_score

from sklearn.metrics import confusion_matrix

import joblib


df = pd.read_csv("data/processed/256_20k_14possibilidades_dataset_F1_F9_teste.csv",index_col=[0])
print(df.shape)

X = df.drop('tipo',axis=1)
y = df['tipo']

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3) # 70% training and 30% test

scaler = RobustScaler() #handles the presence of outliers
scaler.fit(X_train)

X_train_original = X_train
X_test_original = X_test
X_train_KNN = scaler.transform(X_train)
X_test_KNN = scaler.transform(X_test)

path = "models/"

xgb_model = joblib.load(path + "xgb_model.pkl")
svm_model = joblib.load(path + "svm_model.pkl")
knn_model = joblib.load(path + "knn_model.pkl")
nb_model = joblib.load(path + "nb_model.pkl")
dt_model = joblib.load(path + "dt_model.pkl")
bdt_model = joblib.load(path + "bdt_model.pkl")
rf_model = joblib.load(path + "rf_model.pkl")
gb_model = joblib.load(path + "gb_model.pkl")

models = []
models.extend([xgb_model, svm_model, knn_model, nb_model, dt_model, bdt_model, rf_model, gb_model])

model_names = ["XGBoost", "SVM", "KNN", "Naive_Bayes", "Decision_Tree", "Bagged_Decision_Tree", "Random_Forest", "Gradient_Boosting_Tree"]
metrics_being_compared = ["Accuracy Score", "Precision Score", "Recall Score", "F1 Score"]

comparative_data = []

for index, model in enumerate(models):
    X_train = X_train_original
    X_test = X_test_original
    if (model_names[index] == "KNN"):
        X_train = X_train_KNN
        X_test = X_test_KNN

    predictions = model.predict(X_test)
    print("")
    print("---------------------------//---------------------------")
    print("")

    print("Model: ", model_names[index])
    print("")
    print("Confusion Matrix:")
    print(confusion_matrix(y_test, predictions))
    print("")
    print("Classification Report:")
    print(classification_report(y_test, predictions))

    accuracy_score_training = model.score(X_train, y_train)
    accuracy_score_validation = model.score(X_test, y_test)
    print("Accuracy score (training):  {0:.3f}".format(accuracy_score_training))
    print("Accuracy score (validation): {0:.3f}".format(accuracy_score_validation))

    M1 = accuracy_score(y_test, predictions)    
    M2 = precision_score(y_test, predictions, average='weighted')
    M3 = recall_score(y_test, predictions, average='weighted')
    M4 = f1_score(y_test, predictions, average='weighted')

    df_compare_values = np.array([M1,M2, M3, M4])
    comparative_data.append(df_compare_values)
    

#creating dataframe
comparative_df = pd.DataFrame(data=comparative_data,columns=metrics_being_compared)
comparative_df['Modelos'] = np.transpose(model_names)
comparative_df = comparative_df.round(3)
column_name="Modelos"
first_column = comparative_df.pop(column_name)
comparative_df.insert(0, column_name, first_column)

print("")
print("---------------------------//---------------------------")
print("")

print(tabulate(comparative_df, headers='keys', tablefmt='psql'))
comparative_df.to_html('comparative_df.html') #export the table