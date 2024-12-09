import pandas as pd
import requests

def download_audio(csv_file):
    names = {} 
    df = pd.read_csv(csv_file)
    for _ , row in df.iterrows():
        name = row['name']
        if name in names:
            names[name]+=1
        else:
            names[name] = 0
        url = row['target']
        filename = f"{name}_{names[name]}.mp3"
        try:
            response = requests.get(url)
            if response.status_code == 200:
                with open(filename, 'wb') as audio:
                    audio.write(response.content)
                print(f"Downloaded: {filename}") #you can remove  this i was testing
            else:
                print(f"Failed to download {filename}: {response.status_code}")
        except Exception as e:
            print(f"Error: {e}") #so program doesnt exit every time we have a little problem
download_audio('names_data.csv')