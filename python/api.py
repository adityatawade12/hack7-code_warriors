from flask import Flask
from joblib import load
app = Flask(__name__)

model = load('model.joblib')
@app.route('/predict', methods=['POST'])
def predict():
    # Get input data from the request
    input_data = request.get_json()

    # Make prediction using machine learning model
    prediction = model.predict(input_data)

    # Return prediction as JSON response
    return jsonify({'prediction': prediction})
