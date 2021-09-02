import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report, confusion_matrix
from xgboost import XGBClassifier


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

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3) # 70% training and 30% test, dataset is large

xgb_model = XGBClassifier()
xgb_model.fit(X_train, y_train)

predictions = xgb_model.predict(X_test)

print("Confusion Matrix:")
print(confusion_matrix(y_test, predictions))

print("Classification Report")
print(classification_report(y_test, predictions))

accuracy_score_training = xgb_model.score(X_train, y_train)
accuracy_score_validation = xgb_model.score(X_test, y_test)
print("Accuracy score (training): " , accuracy_score_training)
print("Accuracy score (validation): ", accuracy_score_validation)

import joblib #export model

joblib_file_name = "xgb_model.pkl"  
joblib.dump(xgb_model, "models/" +  joblib_file_name)

joblib_model = joblib.load("models/" + joblib_file_name)

joblib_model