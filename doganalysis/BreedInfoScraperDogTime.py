import re
import csv
import requests
from PyLyrics import *
from bs4 import BeautifulSoup
from unidecode import unidecode
from urllib.request import urlopen
from urllib.request import Request
from urllib.request import urlretrieve
from string import ascii_lowercase

BREED_URL = 'http://www.dogtime.com/dog-breeds/american-pit-bull-terrier'

# Scrape HTML
r = requests.get(BREED_URL)

# Process content into Bewautiful Soup Object
breeds_soup = BeautifulSoup(r.text, 'lxml')
