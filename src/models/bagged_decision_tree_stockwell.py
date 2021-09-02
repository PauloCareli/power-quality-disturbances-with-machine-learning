# Bagged Decision Trees for Classification
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report, confusion_matrix
from sklearn import metrics
from sklearn.ensemble import BaggingClassifier

df = pd.read_csv("data/processed/256_20k_14possibilidades_dataset_F1_F9_teste.csv",index_col=[0])

print(df.head())
print(df.shape)
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

bdt_model = BaggingClassifier()
bdt_model.fit(X_train, y_train)

predictions = bdt_model.predict(X_test)

print("Confusion Matrix:")
print(confusion_matrix(y_test, predictions))

print("Classification Report")
print(classification_report(y_test, predictions))

print("Accuracy score (training): {0:.3f}".format(bdt_model.score(X_train, y_train)))
print("Accuracy score (validation): {0:.3f}".format(bdt_model.score(X_test, y_test)))

#Export model
import joblib

joblib_file_name = "bdt_model.pkl"  
joblib.dump(bdt_model, "models/" +  joblib_file_name)

joblib_model = joblib.load("models/" + joblib_file_name)

joblib_model