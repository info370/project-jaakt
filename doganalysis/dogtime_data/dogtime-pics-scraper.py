import re
import sys
import csv
import requests
from bs4 import BeautifulSoup
from unidecode import unidecode
from urllib.request import urlopen
from urllib.request import Request
from urllib.request import urlretrieve

# Base link to all breeds listed alphabetically
BREEDS_URL = 'http://dogtime.com/dog-breeds'

# Scrapes main page
r = requests.get(BREEDS_URL)
breeds_soup = BeautifulSoup(r.text, 'html.parser')

# Build a list of all breeds in the form of <a href>dog breed</a>
breed_blocks = breeds_soup.find_all('a', class_=['post-title'])
breed_total = len(breed_blocks)

print('Gathering doggos... This will take a while!')
with open('doggo-pictures.csv', 'w') as csvfile:
    filewriter = csv.writer(csvfile, delimiter=',')
    for breed in breed_blocks:
        breed_name = breed.get_text()

        # Make BeautifulSoup Object for this breed
        s = requests.get(breed.get('href'))
        breed_soup = BeautifulSoup(s.text, 'html.parser')

        # Get the image source
        parent = breed_soup.find('div', class_='article-content')
        img_url = parent.find('img').get('src')
        print(img_url)

        # Write to the csv
        filewriter.writerow([breed_name, img_url])

print('DONE', end='\n\n')
