import json
import pandas as pd
# with open('data.json', 'r+') as f:
#     data = json.load(f)
#     data['id'] = 134 # <--- add `id` value.
#     f.seek(0)        # <--- should reset file position to the beginning.
#     json.dump(data, f, indent=4)
#     f.truncate()

# f = open("dataset.json", "r")
# data = f.read()
# data_use = json.loads(data)
df = pd.read_json("dataset.json")
latest = df.transactions[len(df.transactions)-1]
current_month = latest["date"]
if(current_month == "January"):
    with open("dataset2.json", "r") as jsonFile:
        data = json.load(jsonFile)

    data["month"][0]["expenditure"] = str(int(data["month"][0]["expenditure"]) + int(latest["amount"]))
    if(latest["type_of_currency"]=="ethereum"):
         data["month"][0]["ethereum"] = str(int(data["month"][0]["ethereum"]) + int(latest["amount"]))
    if(latest["type_of_currency"]=="solana"):
         data["month"][0]["solana"] = str(int(data["month"][0]["solana"]) + int(latest["amount"]))
    if(latest["type_of_currency"]=="kjh"):
         data["month"][0]["kjh"] = str(int(data["month"][0]["kjh"]) + int(latest["amount"]))
    if(latest["category"]=="groceries"):
        data["month"][0]["categories"][0]["amount"] = str(int(data["month"][0]["categories"][0]["amount"]) + int(latest["amount"]))
    if(latest["category"]=="entertainment"):
        data["month"][0]["categories"][1]["amount"] = str(int(data["month"][0]["categories"][1]["amount"]) + int(latest["amount"]))
    if(latest["category"]=="travel"):
        data["month"][0]["categories"][2]["amount"] = str(int(data["month"][0]["categories"][2]["amount"]) + int(latest["amount"]))


    with open("dataset2.json", "w") as jsonFile:
        json.dump(data, jsonFile)
        print("done")

elif(current_month == "February"):
    with open("dataset2.json", "r") as jsonFile:
        data = json.load(jsonFile)

    data["month"][1]["expenditure"] = str(int(data["month"][1]["expenditure"]) + int(latest["amount"]))
    if(latest["type_of_currency"]=="ethereum"):
         data["month"][1]["ethereum"] = str(int(data["month"][1]["ethereum"]) + int(latest["amount"]))
    if(latest["type_of_currency"]=="solana"):
         data["month"][1]["solana"] = str(int(data["month"][1]["solana"]) + int(latest["amount"]))
    if(latest["type_of_currency"]=="kjh"):
         data["month"][1]["kjh"] = str(int(data["month"][1]["kjh"]) + int(latest["amount"]))
    if(latest["category"]=="groceries"):
        data["month"][1]["categories"][0]["amount"] = str(int(data["month"][1]["categories"][0]["amount"]) + int(latest["amount"]))
    if(latest["category"]=="entertainment"):
        data["month"][1]["categories"][1]["amount"] = str(int(data["month"][1]["categories"][1]["amount"]) + int(latest["amount"]))
    if(latest["category"]=="travel"):
        data["month"][1]["categories"][2]["amount"] = str(int(data["month"][1]["categories"][2]["amount"]) + int(latest["amount"]))


    with open("dataset2.json", "w") as jsonFile:
        json.dump(data, jsonFile)
        print("done")

elif(current_month == "March"):
    with open("dataset2.json", "r") as jsonFile:
        data = json.load(jsonFile)

    data["month"][2]["expenditure"] = str(int(data["month"][2]["expenditure"]) + int(latest["amount"]))
    if(latest["type_of_currency"]=="ethereum"):
         data["month"][2]["ethereum"] = str(int(data["month"][2]["ethereum"]) + int(latest["amount"]))
    if(latest["type_of_currency"]=="solana"):
         data["month"][2]["solana"] = str(int(data["month"][2]["solana"]) + int(latest["amount"]))
    if(latest["type_of_currency"]=="kjh"):
         data["month"][2]["kjh"] = str(int(data["month"][2]["kjh"]) + int(latest["amount"]))
    if(latest["category"]=="groceries"):
        data["month"][2]["categories"][0]["amount"] = str(int(data["month"][2]["categories"][0]["amount"]) + int(latest["amount"]))
    if(latest["category"]=="entertainment"):
        data["month"][2]["categories"][1]["amount"] = str(int(data["month"][2]["categories"][1]["amount"]) + int(latest["amount"]))
    if(latest["category"]=="travel"):
        data["month"][2]["categories"][2]["amount"] = str(int(data["month"][2]["categories"][2]["amount"]) + int(latest["amount"]))


    with open("dataset2.json", "w") as jsonFile:
        json.dump(data, jsonFile)
        print("done")

elif(current_month == "April"):
    with open("dataset2.json", "r") as jsonFile:
        data = json.load(jsonFile)

    data["month"][3]["expenditure"] = str(int(data["month"][3]["expenditure"]) + int(latest["amount"]))
    if(latest["type_of_currency"]=="ethereum"):
         data["month"][3]["ethereum"] = str(int(data["month"][3]["ethereum"]) + int(latest["amount"]))
    if(latest["type_of_currency"]=="solana"):
         data["month"][3]["solana"] = str(int(data["month"][3]["solana"]) + int(latest["amount"]))
    if(latest["type_of_currency"]=="kjh"):
         data["month"][3]["kjh"] = str(int(data["month"][3]["kjh"]) + int(latest["amount"]))
    if(latest["category"]=="groceries"):
        data["month"][3]["categories"][0]["amount"] = str(int(data["month"][3]["categories"][0]["amount"]) + int(latest["amount"]))
    if(latest["category"]=="entertainment"):
        data["month"][3]["categories"][1]["amount"] = str(int(data["month"][3]["categories"][1]["amount"]) + int(latest["amount"]))
    if(latest["category"]=="travel"):
        data["month"][3]["categories"][2]["amount"] = str(int(data["month"][3]["categories"][2]["amount"]) + int(latest["amount"]))


    with open("dataset2.json", "w") as jsonFile:
        json.dump(data, jsonFile)
        print("done")

elif(current_month == "May"):
    with open("dataset2.json", "r") as jsonFile:
        data = json.load(jsonFile)

    data["month"][4]["expenditure"] = str(int(data["month"][4]["expenditure"]) + int(latest["amount"]))
    if(latest["type_of_currency"]=="ethereum"):
         data["month"][4]["ethereum"] = str(int(data["month"][4]["ethereum"]) + int(latest["amount"]))
    if(latest["type_of_currency"]=="solana"):
         data["month"][4]["solana"] = str(int(data["month"][4]["solana"]) + int(latest["amount"]))
    if(latest["type_of_currency"]=="kjh"):
         data["month"][4]["kjh"] = str(int(data["month"][4]["kjh"]) + int(latest["amount"])) 
    if(latest["category"]=="groceries"):
        data["month"][4]["categories"][0]["amount"] = str(int(data["month"][4]["categories"][0]["amount"]) + int(latest["amount"]))
    if(latest["category"]=="entertainment"):
        data["month"][4]["categories"][1]["amount"] = str(int(data["month"][4]["categories"][1]["amount"]) + int(latest["amount"]))
    if(latest["category"]=="travel"):
        data["month"][4]["categories"][2]["amount"] = str(int(data["month"][4]["categories"][2]["amount"]) + int(latest["amount"]))


    with open("dataset2.json", "w") as jsonFile:
        json.dump(data, jsonFile)
        print("done")

elif(current_month == "June"):
    with open("dataset2.json", "r") as jsonFile:
        data = json.load(jsonFile)
    data["month"][5]["expenditure"] = str(int(data["month"][5]["expenditure"]) + int(latest["amount"]))
    if(latest["type_of_currency"]=="ethereum"):
         data["month"][5]["ethereum"] = str(int(data["month"][5]["ethereum"]) + int(latest["amount"]))
    if(latest["type_of_currency"]=="solana"):
         data["month"][5]["solana"] = str(int(data["month"][5]["solana"]) + int(latest["amount"]))
    if(latest["type_of_currency"]=="kjh"):
         data["month"][5]["kjh"] = str(int(data["month"][5]["kjh"]) + int(latest["amount"]))
    if(latest["category"]=="groceries"):
        data["month"][5]["categories"][0]["amount"] = str(int(data["month"][5]["categories"][0]["amount"]) + int(latest["amount"]))
    if(latest["category"]=="entertainment"):
        data["month"][5]["categories"][1]["amount"] = str(int(data["month"][5]["categories"][1]["amount"]) + int(latest["amount"]))
    if(latest["category"]=="travel"):
        data["month"][5]["categories"][2]["amount"] = str(int(data["month"][5]["categories"][2]["amount"]) + int(latest["amount"]))


    with open("dataset2.json", "w") as jsonFile:
        json.dump(data, jsonFile)
        print("done")

elif(current_month == "July"):
    with open("dataset2.json", "r") as jsonFile:
        data = json.load(jsonFile)
    data["month"][6]["expenditure"] = str(int(data["month"][6]["expenditure"]) + int(latest["amount"]))
    if(latest["type_of_currency"]=="ethereum"):
         data["month"][6]["ethereum"] = str(int(data["month"][6]["ethereum"]) + int(latest["amount"]))
    if(latest["type_of_currency"]=="solana"):
         data["month"][6]["solana"] = str(int(data["month"][6]["solana"]) + int(latest["amount"]))
    if(latest["type_of_currency"]=="kjh"):
         data["month"][6]["kjh"] = str(int(data["month"][6]["kjh"]) + int(latest["amount"])) 
    if(latest["category"]=="groceries"):
        data["month"][6]["categories"][0]["amount"] = str(int(data["month"][6]["categories"][0]["amount"]) + int(latest["amount"]))
    if(latest["category"]=="entertainment"):
        data["month"][6]["categories"][1]["amount"] = str(int(data["month"][6]["categories"][1]["amount"]) + int(latest["amount"]))
    if(latest["category"]=="travel"):
        data["month"][6]["categories"][2]["amount"] = str(int(data["month"][6]["categories"][2]["amount"]) + int(latest["amount"]))


    with open("dataset2.json", "w") as jsonFile:
        json.dump(data, jsonFile)
        print("done")

elif(current_month == "August"):
    with open("dataset2.json", "r") as jsonFile:
        data = json.load(jsonFile)
    data["month"][7]["expenditure"] = str(int(data["month"][7]["expenditure"]) + int(latest["amount"]))
    if(latest["type_of_currency"]=="ethereum"):
         data["month"][7]["ethereum"] = str(int(data["month"][7]["ethereum"]) + int(latest["amount"]))
    if(latest["type_of_currency"]=="solana"):
         data["month"][7]["solana"] = str(int(data["month"][7]["solana"]) + int(latest["amount"]))
    if(latest["type_of_currency"]=="kjh"):
         data["month"][7]["kjh"] = str(int(data["month"][7]["kjh"]) + int(latest["amount"]))
    if(latest["category"]=="groceries"):
        data["month"][7]["categories"][0]["amount"] = str(int(data["month"][7]["categories"][0]["amount"]) + int(latest["amount"]))
    if(latest["category"]=="entertainment"):
        data["month"][7]["categories"][1]["amount"] = str(int(data["month"][7]["categories"][1]["amount"]) + int(latest["amount"]))
    if(latest["category"]=="travel"):
        data["month"][7]["categories"][2]["amount"] = str(int(data["month"][7]["categories"][2]["amount"]) + int(latest["amount"]))


    with open("dataset2.json", "w") as jsonFile:
        json.dump(data, jsonFile)
        print("done")

elif(current_month == "September"):
    with open("dataset2.json", "r") as jsonFile:
        data = json.load(jsonFile)
    data["month"][8]["expenditure"] = str(int(data["month"][8]["expenditure"]) + int(latest["amount"]))
    if(latest["type_of_currency"]=="ethereum"):
         data["month"][8]["ethereum"] = str(int(data["month"][8]["ethereum"]) + int(latest["amount"]))
    if(latest["type_of_currency"]=="solana"):
         data["month"][8]["solana"] = str(int(data["month"][8]["solana"]) + int(latest["amount"]))
    if(latest["type_of_currency"]=="kjh"):
         data["month"][8]["kjh"] = str(int(data["month"][8]["kjh"]) + int(latest["amount"])) 
    if(latest["category"]=="groceries"):
        data["month"][8]["categories"][0]["amount"] = str(int(data["month"][8]["categories"][0]["amount"]) + int(latest["amount"]))
    if(latest["category"]=="entertainment"):
        data["month"][8]["categories"][1]["amount"] = str(int(data["month"][8]["categories"][1]["amount"]) + int(latest["amount"]))
    if(latest["category"]=="travel"):
        data["month"][8]["categories"][2]["amount"] = str(int(data["month"][8]["categories"][2]["amount"]) + int(latest["amount"]))


    with open("dataset2.json", "w") as jsonFile:
        json.dump(data, jsonFile)
        print("done")

elif(current_month == "October"):
    with open("dataset2.json", "r") as jsonFile:
        data = json.load(jsonFile)
    data["month"][9]["expenditure"] = str(int(data["month"][9]["expenditure"]) + int(latest["amount"]))
    if(latest["type_of_currency"]=="ethereum"):
         data["month"][9]["ethereum"] = str(int(data["month"][9]["ethereum"]) + int(latest["amount"]))
    if(latest["type_of_currency"]=="solana"):
         data["month"][9]["solana"] = str(int(data["month"][9]["solana"]) + int(latest["amount"]))
    if(latest["type_of_currency"]=="kjh"):
         data["month"][9]["kjh"] = str(int(data["month"][9]["kjh"]) + int(latest["amount"])) 
    if(latest["category"]=="groceries"):
        data["month"][9]["categories"][0]["amount"] = str(int(data["month"][9]["categories"][0]["amount"]) + int(latest["amount"]))
    if(latest["category"]=="entertainment"):
        data["month"][9]["categories"][1]["amount"] = str(int(data["month"][9]["categories"][1]["amount"]) + int(latest["amount"]))
    if(latest["category"]=="travel"):
        data["month"][9]["categories"][2]["amount"] = str(int(data["month"][9]["categories"][2]["amount"]) + int(latest["amount"]))


    with open("dataset2.json", "w") as jsonFile:
        json.dump(data, jsonFile)
        print("done")

elif(current_month == "November"):
    with open("dataset2.json", "r") as jsonFile:
        data = json.load(jsonFile)
    data["month"][10]["expenditure"] = str(int(data["month"][10]["expenditure"]) + int(latest["amount"]))
    if(latest["type_of_currency"]=="ethereum"):
         data["month"][10]["ethereum"] = str(int(data["month"][10]["ethereum"]) + int(latest["amount"]))
    if(latest["type_of_currency"]=="solana"):
         data["month"][10]["solana"] = str(int(data["month"][10]["solana"]) + int(latest["amount"]))
    if(latest["type_of_currency"]=="kjh"):
         data["month"][10]["kjh"] = str(int(data["month"][10]["kjh"]) + int(latest["amount"])) 
    if(latest["category"]=="groceries"):
        data["month"][10]["categories"][0]["amount"] = str(int(data["month"][10]["categories"][0]["amount"]) + int(latest["amount"]))
    if(latest["category"]=="entertainment"):
        data["month"][10]["categories"][1]["amount"] = str(int(data["month"][10]["categories"][1]["amount"]) + int(latest["amount"]))
    if(latest["category"]=="travel"):
        data["month"][10]["categories"][2]["amount"] = str(int(data["month"][10]["categories"][2]["amount"]) + int(latest["amount"]))


    with open("dataset2.json", "w") as jsonFile:
        json.dump(data, jsonFile)
        print("done")

elif(current_month == "December"):
    with open("dataset2.json", "r") as jsonFile:
        data = json.load(jsonFile)
    data["month"][11]["expenditure"] = str(int(data["month"][11]["expenditure"]) + int(latest["amount"]))
    if(latest["type_of_currency"]=="ethereum"):
         data["month"][11]["ethereum"] = str(int(data["month"][11]["ethereum"]) + int(latest["amount"]))
    if(latest["type_of_currency"]=="solana"):
         data["month"][11]["solana"] = str(int(data["month"][11]["solana"]) + int(latest["amount"]))
    if(latest["type_of_currency"]=="kjh"):
         data["month"][11]["kjh"] = str(int(data["month"][11]["kjh"]) + int(latest["amount"])) 
    if(latest["category"]=="groceries"):
        data["month"][11]["categories"][0]["amount"] = str(int(data["month"][11]["categories"][0]["amount"]) + int(latest["amount"]))
    if(latest["category"]=="entertainment"):
        data["month"][11]["categories"][1]["amount"] = str(int(data["month"][11]["categories"][1]["amount"]) + int(latest["amount"]))
    if(latest["category"]=="travel"):
        data["month"][11]["categories"][2]["amount"] = str(int(data["month"][11]["categories"][2]["amount"]) + int(latest["amount"]))


    with open("dataset2.json", "w") as jsonFile:
        json.dump(data, jsonFile)
        print("done")

print(current_month)


# .transactions[transactions.length-1]