import re
import csv
import requests
from bs4 import BeautifulSoup
from unidecode import unidecode
from urllib.request import urlopen
from urllib.request import Request
from urllib.request import urlretrieve
from string import ascii_lowercase

BREEDS_URL = 'http://dogtime.com/dog-breeds'
breed_data = {}

r = requests.get(BREEDS_URL)

breeds_soup = BeautifulSoup(r.text, 'html.parser')

breed_blocks = breeds_soup.find_all('a', class_=['post-title'])

for breed in breed_blocks:
    breed_info = {}
    breed_href = breed.get('href')

    breed_info['name'] = breed.get_text()

    s = requests.get(breed_href)
    breed_soup = BeautifulSoup(s.text, 'html.parser')

    feature_blocks = breed_soup.find_all('div', class_=['default-padding-bottom', 'star-by-breed', 'child-characteristic'])

    print(breed_href)

    for feature in feature_blocks:
        feature_a_tag = feature.find('a', class_=['js-list-item-trigger', 'item-trigger', 'more-info'])
        print(feature_a_tag)

        feature_desc = feature_a_tag.find('span', class_=['characteristic', 'item-trigger-title']).get_text()
        #feature_val = feature_a_tag.find('span', class_=['star'])

        print(feature_desc)
        # print(feature_val)
