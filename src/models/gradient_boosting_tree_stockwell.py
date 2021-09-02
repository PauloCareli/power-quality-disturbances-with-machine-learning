import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report, confusion_matrix
from sklearn.ensemble import GradientBoostingClassifier


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
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2) # 70% training and 30% test


lr_list = [0.05, 0.075, 0.1, 0.25, 0.5, 0.75,0.8,0.85, 1] #learning rate, 0.8 is the best atm with this dataset

for learning_rate in lr_list: #find the best LR
    gb_model = GradientBoostingClassifier(n_estimators=20, learning_rate=learning_rate, max_features=2, max_depth=2, random_state=0)
    gb_model.fit(X_train, y_train)

    print("Learning rate: ", learning_rate)
    print("Accuracy score (training): {0:.3f}".format(gb_model.score(X_train, y_train)))
    print("Accuracy score (validation): {0:.3f}".format(gb_model.score(X_test, y_test)))

gb_model2 = GradientBoostingClassifier(n_estimators=20, learning_rate=0.5, max_features=2, max_depth=2, random_state=0)
gb_model2.fit(X_train, y_train)
predictions = gb_model2.predict(X_test)

print("Confusion Matrix:")
print(confusion_matrix(y_test, predictions))

print("Classification Report")
print(classification_report(y_test, predictions))

print("Accuracy score (training): {0:.3f}".format(gb_model2.score(X_train, y_train)))
print("Accuracy score (validation): {0:.3f}".format(gb_model2.score(X_test, y_test)))

gb_model = gb_model2

#Export model
import joblib

joblib_file_name = "gb_model.pkl"  
joblib.dump(gb_model, "models/" +  joblib_file_name)

joblib_model = joblib.load("models/" + joblib_file_name)

joblib_model
