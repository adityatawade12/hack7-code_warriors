import pandas as pd
import numpy as np
import csv
import json
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error
from joblib import dump


spending_data = pd.read_csv('data_file.csv')

# Define the features and target variable
X = spending_data[['income']]
y = spending_data['expenditure']

# Split the data into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Train a linear regression model on the training data
model = LinearRegression()
model.fit(X_train, y_train)

# Make predictions on the testing data
y_pred = model.predict(X_test)

# Calculate the root mean squared error of the model
rmse = np.sqrt(mean_squared_error(y_test, y_pred))
print('Root Mean Squared Error:', rmse)
print(model.predict([[10000]]))
dump(model, 'model.joblib')






# import pandas as pd
# import numpy as np
# from sklearn.linear_model import LinearRegression
# from sklearn.model_selection import train_test_split
# from sklearn.preprocessing import StandardScaler
# from sklearn.metrics import mean_squared_error

# # Load the spending data into a pandas DataFrame
# spending_data = pd.read_csv('spending_data.csv')

# # Feature engineering: create new features
# spending_data['debt_to_income'] = spending_data['credit_card_debt'] / spending_data['income']
# spending_data['balance_to_limit'] = spending_data['balance'] / spending_data['credit_limit']

# # Define the features and target variable
# X = spending_data[['age', 'income', 'credit_score', 'debt_to_income', 'balance_to_limit']]
# y = spending_data['monthly_spending']

# # Data processing: scale the features
# scaler = StandardScaler()
# X = scaler.fit_transform(X)

# # Split the data into training and testing sets
# X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# # Train a linear regression model on the training data
# model = LinearRegression()
# model.fit(X_train, y_train)

# # Make predictions on the testing data
# y_pred = model.predict(X_test)

# # Calculate the root mean squared error of the model
# rmse = np.sqrt(mean_squared_error(y_test, y_pred))
# print('Root Mean Squared Error:', rmse)




# import pandas as pd
# import numpy as np
# from sklearn.ensemble import RandomForestRegressor
# from sklearn.model_selection import train_test_split
# from sklearn.preprocessing import StandardScaler
# from sklearn.metrics import mean_squared_error

# # Load the spending data into a pandas DataFrame
# spending_data = pd.read_csv('data_file.csv')

# # Feature engineering: create new features
# # spending_data['debt_to_income'] = spending_data['credit_card_debt'] / spending_data['income']
# # spending_data['balance_to_limit'] = spending_data['balance'] / spending_data['credit_limit']

# # Define the features and target variable
# X = spending_data[['income']]
# y = spending_data['expenditure']

# # Data processing: scale the features
# scaler = StandardScaler()
# X = scaler.fit_transform(X)

# # Split the data into training and testing sets
# X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# # Train a random forest regressor on the training data
# model = RandomForestRegressor(n_estimators=100, max_depth=10, random_state=42)
# model.fit(X_train, y_train)

# # Make predictions on the testing data
# y_pred = model.predict(X_test)
# # print(y_pred)

# # Calculate the root mean squared error of the model
# rmse = np.sqrt(mean_squared_error(y_test, y_pred))
# print('Root Mean Squared Error:', rmse)
