# -*- coding: utf-8 -*-
'''
Small util for monitoring live stream of tweets as they happend and filter out only those accounts that match
 a certain pattern i users profile description. Outpu is a txt file with twitter id's

 Usage:
 % python monitorbots.py > output.txt

'''
import twarc
consumer_key = ''
consumer_secret = ''
access_token = ''
access_token_secret = ''

t = twarc.Twarc(consumer_key, consumer_secret, access_token, access_token_secret)
patterns = {'gotny.xyz','go4to.info','minego.info','1xgo.xyz','go2to.info','ibergo.info','5gox.xyz','ggtou.xyz','wusgo.info','take-your-pleasure.com','datewith-me1.com'}
x = t.filter(track=u'#pldebatt,sweden')

seen = {}
for tweet in x:
    try:
        print ()
        if any(ext in tweet['user']["description"]for ext in patterns):
            if tweet['id'] not in seen:
                seen[tweet['id']] = True
                print (tweet['id'])
    except:
        pass
