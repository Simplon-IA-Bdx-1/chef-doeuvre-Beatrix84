from flask import Flask,render_template, request
from flask_mysqldb import MySQL
from werkzeug.utils import secure_filename
import tensorflow as tf
from tensorflow import keras
import nibabel as nib
import skimage
from skimage import transform
import numpy as np
import os
import logging
import pandas as pd
import os
from dotenv import load_dotenv

app = Flask(__name__)

path='../BDD/.env'
load_dotenv(dotenv_path=path)

app.config['MYSQL_USER']=os.getenv("MYSQL_USER")
app.config['MYSQL_PASSWORD']=os.getenv("MYSQL_PASSWORD")
app.config['MYSQL_HOST']=os.getenv("MYSQL_HOST")
app.config['MYSQL_DB']=os.getenv("MYSQL_DATABASE")

mysql = MySQL(app)

@app.route('/')
def index():
    #Ask the database to show the list of doctors
    cursor = mysql.connection.cursor()
    cursor.execute('SELECT Doctor_id, Lastname FROM Doctor')
    doclist = cursor.fetchall() 
    #print(doclist)
    return render_template('index.html', doclist=doclist)

@app.route('/', methods=['GET', 'POST'])
def predict():

    #Upload image to predict
    file = request.files['file']
    filename = secure_filename(file.filename)
    filename = os.path.join('./uploads', filename) 
    file.save(filename)
    #print(filename)
    
    #Load model
    model = tf.keras.models.load_model('../models/keras3dcnn_model_1.h5')
    print('Loading model ..')

    #Image preprocessing 
    size = (21,42,42)
    #mean_pixel = 138
    #max_pixel = 5185
    x = nib.load(filename).get_fdata()
    x = skimage.transform.resize(x,(size))
    #x = (x - mean_pixel) / max_pixel
    x = x / float(np.max(x))
    img_preprocess = x.reshape(1, *(size), 1)

    #Prediction
    prediction = model.predict(img_preprocess)
    prediction_max = np.max(prediction)
    prediction_final = np.round(prediction_max* 100, 2)
    print(np.argmax(prediction,axis=1))
    print(prediction_max)
    print(prediction_final)

    app.logger.info(prediction)

    reponse = np.argmax(prediction,axis=1)

    #How to show the prediction
    if reponse == 0:
        show = 'Patient with Alzheimer disease'
        print("Patient with Alzheimer disease")
    elif reponse == 1:
        show = 'Healthy'
        print("Healthy")
    else:
        show = 'Patient with Mild Cognitive Impairment'
        print("Patient with Mild Cognitive Impairment")
    
    #Data request from web page 
    if request.method == 'POST':
        doc = request.form['j']
        birth = request.form['birthday']
        gender = request.form['gender']
        date = request.form['date']
        patient_id = filename.split('_')[-1].split('.')[0]
        
        print(patient_id)
        print(filename)
        #print(date)
    
        if reponse == 0:
            group = 'AD'
        elif reponse == 1:
            group = 'CN'
        else:
            group = 'MCI'
        #print(group)

        #Insert into mysql tables
        cursor = mysql.connection.cursor()
        cursor.execute ('''SELECT EXISTS(SELECT 1 FROM Patient WHERE Patient_id =%s)''',(patient_id,))
        result = cursor.fetchone()[0]
        print(result)
        
        if result == 0 :
            cursor.execute(''' INSERT INTO Patient VALUES(%s,%s,%s, %s)''',(patient_id, gender, birth, doc))
        
        cursor.execute(''' INSERT INTO Brain_scanner (`Patient_id`, `Image_path`, `Date`, `Group`) VALUES((SELECT Patient_id FROM Patient WHERE Patient_id=%s),%s,%s,%s)''',(patient_id, filename, date, group))
        mysql.connection.commit()
    
        cursor.execute ('''SELECT `Patient_id`,`Date`, `Group` FROM Brain_scanner WHERE Patient_id =%s''',(patient_id,))
        data = cursor.fetchall()
        cursor.close()
        print("Loaded into the followup tables!")

        return render_template('result.html', Text = show, Prediction = prediction_final, data=data ) 
    

if __name__ == '__main__':
    app.run(debug=True, port=5000)
