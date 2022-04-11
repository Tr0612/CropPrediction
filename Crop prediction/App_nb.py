import pickle 
import numpy as np
import pandas as pd
import plotly.express as px
import matplotlib.pylab as plt
import plotly.graph_objects as go
import plotly.figure_factory as ff
from matplotlib.figure import Figure
from plotly.subplots import make_subplots
from flask import Flask, jsonify, request, render_template
from flask_restful import Resource,Api
from sklearn.model_selection import train_test_split
from matplotlib.backends.backend_agg import FigureCanvasAgg as FigureCanvas
import requests as req
import geocoder
from flask_cors import CORS

prop_name = ["Nitrogen","Phosphorous","Potassium","Temperature","Humidity","pH","Rainfall"]
soil = [dict(zip(prop_name,[0]*len(prop_name)))]
app = Flask(__name__, template_folder = 'template')
model1 = pickle.load(open('model_NB.pkl','rb'))

api = Api(app)
CORS(app)

@app.route('/home')
def home():
    return render_template('index.html')

@app.route('/', methods = ['GET','POST'])
def predict():
    # features = [float(x) for x in request.form.values()]
    features =[]
    print(request.form.get("Nitrogen"))
    features.append(request.form.get("Nitrogen"))
    features.append(request.form.get("Pho"))
    features.append(request.form.get("Pk"))
    features.append(request.form.get("temp"))
    features.append(request.form.get("humidity"))
    features.append(request.form.get("pH"))
    features.append(request.form.get("rain"))
    result = background_process_test()
    features[3] = (float(result["main"]["temp"]))-273.15
    features[4] = float(result["main"]["humidity"])
    print(features)
    check = features
    print(check)
    final_features = [np.array(features)]
    prediction = model1.predict(final_features)
    output = prediction[0]
    return render_template('output.html',prediction_text = 
                               'Type of crop is: {}'.format(output),temp=features[3],hum=features[4])   
@app.route('/detect')
def detector():
    result = background_process_test()
    return render_template("index.html",temp=(float(result["main"]["temp"]))-273.15,hum=float(result["main"]["humidity"]))

@app.route('/background_process_test')
def background_process_test():
    g = geocoder.ip('me')
    lat = str(g.latlng[0])
    lon = str(g.latlng[1])
    api = "f8e96aebc62d0f8b76a1a4353a7d092a"
    base_url = "http://api.openweathermap.org/data/2.5/weather?"
    url = base_url+"lat="+lat+"&lon="+lon+"&appid="+api
    res = req.get(url)
    result = res.json()
    print(result)
    return result

class Properties(Resource):
    def get(self):
        final_features =[]
        for i in range(0,len(prop_name)):
            final_features.append(soil[0][prop_name[i]])
        final_features = [np.array(final_features)]
        prediction = model1.predict(final_features)
        return jsonify({"cropName":prediction[0]})

@app.route("/putdata",methods=["POST"])
def addOne():
    new_prop = request.get_json()
    soil.pop(0)
    soil.append(new_prop)
    return jsonify({"soil":soil[0]})   
    
api.add_resource(Properties,'/check')

if __name__ == "__main__":
    app.run(debug=True)
    

