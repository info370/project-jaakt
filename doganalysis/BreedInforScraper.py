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

# Base link to all breeds listed alphabetically
# /?letter=
BREEDS_URL = 'http://www.akc.org'
breed_data = {}

# Loop through each letter of the alphabet
for letter in ascii_lowercase:
    letter_url = BREEDS_URL + '/dog-breeds/?letter=' + letter.upper()

    # Scrape HTML
    r = requests.get(letter_url)

    # Process content into Bewautiful Soup Object
    breeds_soup = BeautifulSoup(r.text, 'lxml')

    # Extract years
    breed_blocks = breeds_soup.find_all('div', class_=['scale-contents'])

    # Loop through all the breeds article tags on the current letter
    for breed in breed_blocks:
        breed_info = {}

        breed_info['name'] = breed.find('h2').find('a').text
        breed_extension = breed.find('h2').find('a').get('href')

        print(breed_info['name'])
        # Goes to specific breed page
        s = requests.get(BREEDS_URL + breed_extension)
        breed_soup = BeautifulSoup(s.text, 'lxml')

        # Get type of breed (Ex. Toy Group)
        try:
            breed_info['type'] = breed_soup.find_all('div', class_=['type'])[0].find('span').text
        except:
            breed_info['type'] = "Not found!"

        # Parse all the details listed
        try:
            breed_details = breed_soup.find('div', class_=['breed-details__main']).find_all('li')
        except:
            breed_info["details"] = "Not found!"

        # Case where they follow a different format (text in p tag rather than list)
        if not breed_details:
            try:
                raw_sauce = breed_soup.find('div', class_=['breed-details__main']).find('p').get_text().split('\n')
            except:
                breed_info["details"] = "Not found!"

            try:
                for sauce in raw_sauce:
                    # Extrct type of detail
                    detail_type = sauce.split(':')[0].strip()
                    # Extract value of detail
                    detail_value = sauce.split(':')[1].strip()

                    breed_info[detail_type] = detail_value
            except:
                # When there is a paragraph of text and no aggregated data
                breed_info["unfiltered-data"] = raw_sauce[0]
        else:
            for detail in breed_details:
                    # Extrct type of detail
                    detail_type = detail.get_text().split(':')[0].strip()
                    # Extract value of detail
                    detail_value = detail.get_text().split(':')[1].strip()

                    breed_info[detail_type] = detail_value

        # Gets the summary energy and size from the website with some hacky python space removal methods
        try:
            breed_info['summary-energy'] = ' '.join(breed_soup.find('span', class_='energy_levels').get_text().lower().split())
            breed_info['summary-size'] = ' '.join(breed_soup.find('span', class_='size').get_text().lower().split())
        except:
            breed_info["summary-details"] = "Not found!"

        breed_data[breed_info['name']] = breed_info

messy_breeds = []

with open('assets/Breed_Information_AKC.csv', 'w') as csvfile:
    filewriter = csv.writer(csvfile, delimiter=',')
    filewriter.writerow(['Name', 'Type', 'Personality', 'Energy-Level', 'Good-With-Children', 'Good-With-Other-Dogs', 'Shedding', ' Grooming', 'Tranability', 'Height', 'Weight', 'Life-Expectancy', 'Barking-Level', 'Summary-Energy', 'Summary-Size'])
    for breed_name, data in breed_data.items():
        try:
            filewriter.writerow([breed_name, data['type'], data['Personality'], data['Energy Level'], data['Good with Children'], data['Good with other Dogs'], data['Shedding'], data['Grooming'], data['Trainability'], data['Height'], data['Weight'], data['Life Expectancy'], data['Barking Level'], data['summary-energy'], data['summary-size']])
        except Exception as e:
            messy_breeds.append(str(breed_name) + " missing " + str(e))

print("Breeds with messy data: ")
print(*messy_breeds, sep=', ')
print("Total breed count: " + str(len(breed_data)))
print("Total messy breed count: " + str(len(messy_breeds)))
print("Usable breed count: " + str(len(breed_data) - len(messy_breeds)))
