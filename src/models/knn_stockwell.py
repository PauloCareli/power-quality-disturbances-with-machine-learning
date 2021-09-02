

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler, MinMaxScaler, RobustScaler #scalers, robust worked better
from sklearn.neighbors import KNeighborsClassifier
from sklearn.metrics import classification_report, confusion_matrix, roc_auc_score

df = pd.read_csv("data/processed/256_20k_14possibilidades_dataset_F1_F9_teste.csv",index_col=[0])

print(df.head())
#df.applymap(np.absolute)

X = df.drop('tipo',axis=1)
y = df['tipo']

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.30)

scaler = RobustScaler() #handles the presence of outliers,
scaler.fit(X_train)

X_train = scaler.transform(X_train)
X_test = scaler.transform(X_test)

error = []

# Calculating error for K values between 1 and 40
for i in range(1, 40):
    knn = KNeighborsClassifier(n_neighbors=i)
    knn.fit(X_train, y_train)
    pred_i = knn.predict(X_test)
    error.append(np.mean(pred_i != y_test))

plt.figure(figsize=(12, 6))
plt.plot(range(1, 40), error, color='red', linestyle='dashed', marker='o',
         markerfacecolor='blue', markersize=10)
plt.title('Error Rate K Value')
plt.xlabel('K Value')
plt.ylabel('Mean Error')
plt.show()

knn_model = KNeighborsClassifier(n_neighbors=3) #3 had the lowest error, 5 might be better sometimes
knn_model.fit(X_train, y_train)

y_pred = knn_model.predict(X_test)
print(y_pred)

print(confusion_matrix(y_test, y_pred))
print(classification_report(y_test, y_pred))

print(knn_model.score(X_train,y_train))
print(knn_model.score(X_test,y_test))

#export model
import joblib

joblib_file_name = "knn_model.pkl"  
joblib.dump(knn_model, "models/" +  joblib_file_name)

joblib_model = joblib.load("models/" + joblib_file_name)

joblib_model