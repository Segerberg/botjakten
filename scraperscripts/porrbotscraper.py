'''
Req Twitterscraper by Taspinar: https://github.com/taspinar/twitterscraper
Script written by https://github.com/christopherkullenberg/

Schema for sqlite3 database:
CREATE TABLE users(id INTEGER PRIMARY KEY, tweetid TEXT UNIQUE, user TEXT,
timestamp TEXT, text TEXT);
'''

import pandas as pd
from twitterscraper import query_tweets
import sqlite3


conn = sqlite3.connect('porrtweets.sqlite3')
cursor = conn.cursor()

df = pd.read_csv("porrbotar.csv")  # Load up twitter usernames

listofusernames = []

for d in df.iterrows():
    if d[1][1].startswith("@"):
        listofusernames.append(d[1][1][1:])
    else:
        listofusernames.append(d[1][1])


for l in listofusernames:
    for tweet in query_tweets(l, 10):
        print("Tweet ID: " + tweet.id)
        print("User: " + tweet.user)
        print("Timestamp: " + str(tweet.timestamp))
        print("Text: " + tweet.text)
        try:
            cursor.execute('''INSERT INTO users(tweetid, user, timestamp, text)
                      VALUES(?, ?, ?, ?)''', (tweet.id, tweet.user, tweet.timestamp, tweet.text))
            conn.commit()
            print("SUCCESS! Added to database.")
        except sqlite3.IntegrityError:
            print("Already in database, continuing....")
        print("-" * 80)
