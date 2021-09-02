import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import classification_report, confusion_matrix
from sklearn import metrics
#import sklearn.metrics as metrics
from sklearn.ensemble import RandomForestClassifier

df = pd.read_csv("data/processed/256_20k_14possibilidades_dataset_F1_F9_teste.csv",index_col=[0])

print(df.head())
#df.applymap(np.absolute)

X = df.drop('tipo',axis=1)
y = df['tipo']

'''
df_test = pd.read_csv('filename.csv',index_col=[0]) #another test dataset
X1 = df_test.drop('tipo',axis=1)
y1 = df_test['tipo']
'''

# Split dataset into training set and test set
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3) # 70% training and 30% test

#Create a Gaussian Classifier
rf_model=RandomForestClassifier(n_estimators=100)

#Train the rf_model using the training sets predictions=rf_model.predict(X_test)
rf_model.fit(X_train,y_train)

predictions=rf_model.predict(X_test)

rf_model_1 = rf_model;

#metrics
print("Confusion Matrix:")
print(confusion_matrix(y_test, predictions))

print("Classification Report")
print(classification_report(y_test, predictions))

print("Accuracy score (training): {0:.3f}".format(rf_model.score(X_train, y_train)))
print("Accuracy score (validation): {0:.3f}".format(rf_model.score(X_test, y_test)))


feature_imp = pd.Series(rf_model.feature_importances_,index=X.columns.values).sort_values(ascending=False)

importance = rf_model.feature_importances_
# summarize feature importance
for i,v in enumerate(importance):
    print('Feature:', df.columns[i],  ' Score: %.5f' % (v)) #F2 and F8 seems that are not that important compared to the other features

X = X.drop(['F2','F8'],axis=1) #drop features with less impact

# Split dataset into training set and test set
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3) # 70% training and 30% test

#Create a Gaussian Classifier
rf_model=RandomForestClassifier(n_estimators=100)

#Train the rf_model using the training sets predictions=rf_model.predict(X_test)
rf_model.fit(X_train,y_train)

predictions=rf_model.predict(X_test)

#metrics
print("Confusion Matrix:")
print(confusion_matrix(y_test, predictions))

print("Classification Report")
print(classification_report(y_test, predictions))

print("Accuracy score without K2 and K8 (training): {0:.3f}".format(rf_model.score(X_train, y_train)))
print("Accuracy score without K2 and K8(validation): {0:.3f}".format(rf_model.score(X_test, y_test)))

rf_model = rf_model_1; #the model with all features has better results

#Export model
import joblib

joblib_file_name = "rf_model.pkl"  
joblib.dump(rf_model, "models/" +  joblib_file_name)

joblib_model = joblib.load("models/" + joblib_file_name)

joblib_model