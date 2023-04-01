import csv
import json

with open('dataset2.json') as json_file:
    data = json.load(json_file)
month_data = data['month']
data_file = open('data_file.csv', 'w')
csv_writer = csv.writer(data_file)
count = 0
for emp in month_data:
    if count == 0:
 
        # Writing headers of CSV file
        header = emp.keys()
        csv_writer.writerow(header)
        count += 1
 
    # Writing data of CSV file
    csv_writer.writerow(emp.values())
 
data_file.close()