#takes too long to train large datasets, needs to tune C and gamma, better values makes it slower
#got acceptable results with small dataset

import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report, confusion_matrix
from sklearn.svm import SVC
from sklearn.metrics import accuracy_score
from sklearn.model_selection import GridSearchCV

df = pd.read_csv("data/processed/256_20k_14possibilidades_dataset_F1_F9_teste.csv",index_col=[0])

print(df.head())
#df.applymap(np.absolute)

X = df.drop('tipo',axis=1)
y = df['tipo']

''' Import another dataset to predict
df_test = pd.read_csv('filename.csv',index_col=[0])
X1 = df_test.drop('tipo',axis=1)
y1 = df_test['tipo']
X_train1, X_test1, y_train1, y_test1 = train_test_split(X1, y1, test_size = 0.99)
'''

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.50)
#X_train.applymap(np.absolute)

''' Perform Gridsearch to find better hyperparameters
param_grid = {'C': [0.1,1, 10, 100,10**4,10**5,10**7], 'gamma': [2,1,0.1,0.01,0.001],'kernel': ['rbf', 'sigmoid']} #dataset is not linear, rbf seems the better for the task, since it can build very complex decision boundaries and build a better hyperplane
grid = GridSearchCV(SVC(),param_grid,refit=True,verbose=2)
grid.fit(X_train,y_train)
print(grid.best_estimator_)
grid_predictions = grid.predict(X_test)
print(confusion_matrix(y_test,grid_predictions))
print(classification_report(y_test,grid_predictions))
#grid search returns C = 10**7 e gamma=0.01
'''
svm_model = SVC(kernel='rbf',C=10**7,gamma=0.01) #higher C = lowest misclassified examples, lowest C = lowest penalty for misclassified. lowest gamma = considerates points far from the line, highest gamma = use points closest to the line
svm_model.fit(X_train, y_train) #taking too long to train, high C

y_pred = svm_model.predict(X_test)

#set(y_test) - set(y_pred)

#print(confusion_matrix(y_test,y_pred))
print(classification_report(y_test,y_pred))

y_pred1 = svm_model.predict(X_test1)
print(classification_report(y_test1,y_pred1))

accuracy_score(y_test1,y_pred1)

svm_model.score(X_train,y_train)
svm_model.score(X_test,y_test)

print("Confusion Matrix:")
print(confusion_matrix(y_test, predictions))

print("Classification Report")
print(classification_report(y_test, predictions))

accuracy_score_training = svm_model.score(X_train, y_train)
accuracy_score_validation = svm_model.score(X_test, y_test)
print("Accuracy score (training): " , accuracy_score_training)
print("Accuracy score (validation): ", accuracy_score_validation)

#export model
import joblib

joblib_file_name = "svm_model.pkl"  
joblib.dump(svm_model, "models/" +  joblib_file_name)

joblib_model = joblib.load("models/" + joblib_file_name)

joblib_model