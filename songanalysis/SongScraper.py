import re
import csv
import requests
from PyLyrics import *
from bs4 import BeautifulSoup
from unidecode import unidecode
from urllib.request import urlopen
from urllib.request import Request
from urllib.request import urlretrieve

DOWNLOAD_LYRICS = False # Set to false if you already have lyrics saved

# Billboard Top 100 Songs base link
# Follows pattern of SONGS_URL/year-2
SONGS_URL = 'http://billboardtop100of.com/'
song_dataset = {} # Dict for top 100 songs for each year; format {year: dict with top 100}
song_errors = {} # Dict to keep count of songs that did not have lyrics

# Scrape HTML
r = requests.get(SONGS_URL)

# Process content into Bewautiful Soup Object
song_soup = BeautifulSoup(r.text, 'lxml')

# Extract years
years = song_soup.find_all('li', class_=['menu-item', 'menu-item-type-post_type', 'menu-item-object-page'])
year_list = []

# The first 5 are just page navigators
for year in years[5:]:
    year_list.append(year.a.text.strip()) # Appends each year thats avaliable

# Goes through each year
for year in year_list:
    print(year)
    song_errors[year] = 0 # Intializes error count
    year_url = SONGS_URL + year + '-2'
    r = requests.get(year_url)
    year_soup = BeautifulSoup(r.text, 'lxml') # New BS object for each year's html page
    year_top_hundo = {} # Dict for the top 100 songs; format {composer: song name}

    # Check the html page to see if it is formatted properly
    # Some years have raw text rather than data
    try:
        songs = year_soup.find('table').find_all('tr')
    except:
        print("Year: " + year + " is not formatted properly.")
        continue

    for song in songs:
        song_vals = song.find_all('td') # position, singer/band, song name
        # replace cleans up the data for certain years that have &nbsp, LYRCS, and new line characters
        song_name = song_vals[2].text.replace('LYRICS', '')
        song_composer = song_vals[1].text

        composer = unidecode(song_composer).strip()
        name = unidecode(song_name).strip()

        if (DOWNLOAD_LYRICS):
            # Extracts main artist and removes any features
            # I know this is bad code but its just to make it work for the pilot study (Also its 2am)
            if (' and ' in composer.lower()):
                composer = re.split(' and ', composer, flags=re.IGNORECASE)[0]

            if (' with ' in composer.lower()):
                composer = re.split(' with ', composer, flags=re.IGNORECASE)[0]

            if (', ' in composer.lower()):
                composer = re.split(', ', composer, flags=re.IGNORECASE)[0]

            if (' feat' in composer.lower()):
                composer = re.split(' feat.', composer, flags=re.IGNORECASE)[0]

            if ('/' in name.lower()):
                name = re.split('/', name, flags=re.IGNORECASE)[0]
                name = re.split(' / ', name, flags=re.IGNORECASE)[0]

            try:
                # Only enters in top hundo list if it gets the lyrics
                year_top_hundo[song_composer] = name
                lyrics_file = open("assets/" + name.translate(name.maketrans(' ', '_','()')) + ".txt", 'w')
                lyrics_file.write(PyLyrics.getLyrics(composer, name))
            except:
                print("Trouble finding lyrics for " + song_name + " by " + song_composer)
                song_errors[year] += 1

    song_dataset[year] = year_top_hundo

if (DOWNLOAD_LYRICS):
    with open('assets/song_dataset.csv', 'w') as csvfile:
        filewriter = csv.writer(csvfile, delimiter=',')
        filewriter.writerow(['Year', 'Composer', 'Song Name'])
        for year, top_hundo in song_dataset.items():
            for composer, song_name in top_hundo.items():
                filewriter.writerow([year, composer, song_name])

print(song_dataset)
print(song_errors)
