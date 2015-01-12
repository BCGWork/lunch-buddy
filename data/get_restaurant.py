import csv
import json
import os
import requests
from requests_oauthlib import OAuth1

# CUR_DIR = os.getcwd()
# f = csv.reader(open(os.path.abspath(os.path.join(CUR_DIR, "yelp_key.txt")), "r"))
f = csv.reader(open("yelp_key.txt", "r"))
data = open("restaurant_data.txt", "w")
data_json = []
KEY = {}
for row in f:
	k, v = row
	KEY[k] = v

URL = "http://api.yelp.com/v2/search"
args = {"term": "lunch", "location": "53 State Street, Boston, MA 02109", "sort": 2, "radius_filter": 300, "limit": 20}
auth = OAuth1(KEY["consumer_key"], KEY["consumer_secret"], KEY["token"], KEY["token_secret"])
r = requests.get(URL, params=args, auth=auth)
output = r.json()["businesses"]

for i in range(len(output)):
	rest_object = output[i]
	
	name = rest_object["name"]
	address = ", ".join(rest_object["location"]["display_address"])
	lat = rest_object["location"]["coordinate"]["latitude"]
	long = rest_object["location"]["coordinate"]["longitude"]
	url = rest_object["url"]
	
	out = {"name": name, "address": address, "lat": lat, "long": long, "url": url}
	data_json.append(out)
	print name, "recorded."

json.dump(data_json, data)
