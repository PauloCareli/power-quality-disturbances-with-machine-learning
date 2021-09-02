#Importa a biblioteca do modelo Naive Bayes Gaussiano
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report, confusion_matrix
from sklearn.naive_bayes import GaussianNB
import numpy as np

df = pd.read_csv("data/processed/256_20k_14possibilidades_dataset_F1_F9_teste.csv",index_col=[0])

print(df.head())
#df.applymap(np.absolute)

X = df.drop('tipo',axis=1)
y = df['tipo']

'''
df_test = pd.read_csv('filename.csv') #another test dataset
X1 = df_test.drop('tipo',axis=1)
y1 = df_test['tipo']
'''

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3) # 70% training and 30% test, dataset is large

nb_model = GaussianNB()
nb_model.fit(X_train, y_train)

#Results
predictions = nb_model.predict(X_test)

print("Confusion Matrix:")
print(confusion_matrix(y_test, predictions))

print("Classification Report")
print(classification_report(y_test, predictions))

accuracy_score_training = nb_model.score(X_train, y_train)
accuracy_score_validation = nb_model.score(X_test, y_test)
print("Accuracy score (training): " , accuracy_score_training)
print("Accuracy score (validation): ", accuracy_score_validation)

#Export model
import joblib 

joblib_file_name = "nb_model.pkl"  
joblib.dump(nb_model, "models/" +  joblib_file_name)

joblib_model = joblib.load("models/" + joblib_file_name)

joblib_model