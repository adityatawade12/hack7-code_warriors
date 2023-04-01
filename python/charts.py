# from __future__ import print_function
# import base64

# from flask import *
# import pickle
import os
# import base64
# import pickle
# import datetime
# import sys
# import importlib
# from threading import Thread
# import sendgrid
import pandas as pd
from pandas.plotting import register_matplotlib_converters
import numpy as np
import altair as alt
from altair_saver import save
import json
from bokeh.plotting import figure, show
import matplotlib.pyplot as plt
import plotly.express as px
PARAMS_FILE = 'dataset.json'
# with open(PARAMS_FILE) as params_file:
#     params = json.load(params_file)
f = open("dataset2.json", "r")
data = f.read()
data_use = json.loads(data)
# print(data_use)
# data_use['groceries']['amount']
# db = SQLAlchemy()


# global params
# y_bottom = np.zeros(12) #ndarray of zeros having given shape, order and datatype.
# charts = []
# df1 = pd.DataFrame()
# print(data_use['month'][0])
incomes = []
expenditure = []
average_income = []
average_expenditure = []
for i in range(0,12):
    incomes.append(int(data_use['month'][0]['income']))
    expenditure.append(int(data_use['month'][0]['expenditure']))
score_data = pd.DataFrame({
    'Month': ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
    'Score': incomes,
    'Expenditure': expenditure
})
print(score_data)
for i in range(0,12):
    inc = 0
    exp = 0
    avg_inc = 0
    avg_exp =0  
    for j in range(0,i+1):
        inc = inc + int(data_use['month'][j]['income'])
        exp = exp + int(data_use['month'][j]['expenditure'])
    avg_inc = inc / i+1
    avg_exp = exp / i+1
    average_income.append(avg_inc)
    average_expenditure.append(avg_exp)




# df1 = pd.DataFrame('Month', sales=[10, 8, 30]))
# df2 = pd.DataFrame(dict(market=[4, 2, 5]))
fig = px.bar(score_data, score_data['Month'], score_data['Score'], color=score_data['Expenditure'])
fig.show()
# p = figure(title="Spending Analysis", x_axis_label="x", y_axis_label="y")
# p.vbar(x=score_data['Month'],y=score_data['Score'] , legend_label="Rate", width=0.5, bottom=0, color="red")
# show(p)
# alt.renderers.enable('mimetype')  

# repchart = alt.Chart(score_data).mark_bar().encode(
#     # Mapping the Website column to x-axis
#     x='Website',
#     # Mapping the Score column to y-axis
#     y='Score'
# ).interactive()
# repchart.save('chart.html')
# st.altair_chart(repchart)
# alt.renderers.enable("html")
# save(repchart, "chart.png")
# for month in data_use.month:
#     if(month["name"]=="January"): 
#         print(month)
# try:
#     x = dataset_month
#     y = category_name
# except Exception as e:
#     print(e)
#     continue
# print(category_name, y)
# y_bottom = np.add(y_bottom, y)
# source = pd.DataFrame({
#     'month': x,
#     'spent': y,
#     'company': [company_name] * 12
# })
# chart = alt.Chart(source).mark_bar(size=15).encode(
#     x=alt.X('month', title=''),
#     y=alt.Y('spent', title='Amount spent (₹)')
# ).properties(
#     title=company_name,
# )
# charts.append(chart)
# source.set_index('month')
# if not df1.size:
#     df1 = source
# else:
#     df1 = df1.append(source)
#     # if not df1.size:
#     #     print('No data found for ')
#     # return
# stackedchart = alt.Chart(df1).mark_bar(size=15).encode(
# alt.X('month', title=''),
# y=alt.Y('sum(spent)', title='Amount spent (₹)'),
# color='company'
# ).properties(
# title='Aggregate Monthly Spending'
# )
# charts.insert(0, stackedchart)
# repchart = alt.VConcatChart(vconcat=charts)
# save(repchart, os.path.dirname(os.path.abspath(__file__)) + '/data/report.png', scale_factor=1.5)
# with app.app_context():
#     context = {'amount': np.sum(y_bottom)}







# def getData(company_name, filename_to_dump):
#     sys.path.append('src')
#     return importlib.import_module('src.analysis_' + company_name).getData(filename_to_dump)

# def coerceData(x, y):
#     df = pd.DataFrame({'Amount': y}, index=x)
#     df.index = pd.to_datetime(df.index.strftime('%Y-%m-%d'))
#     df = df['Amount'].resample('M').sum()
#     df = df.reindex(pd.date_range('2019-07-01', periods=12, freq='M')).fillna(0.0)
#     x = df.index.tolist()
#     y = df.values
#     return x, y