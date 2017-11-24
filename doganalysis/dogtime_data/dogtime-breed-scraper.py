import re
import csv
import sys
import requests
from bs4 import BeautifulSoup
from unidecode import unidecode
from urllib.request import urlopen
from urllib.request import Request
from urllib.request import urlretrieve

# Base link to all breeds listed alphabetically
BREEDS_URL = 'http://dogtime.com/dog-breeds'
all_breed_data = {}
breed_num = 0

print('Scraping main page... ', end='')
r = requests.get(BREEDS_URL)
breeds_soup = BeautifulSoup(r.text, 'html.parser')
print('DONE', end='\n\n')

# Build a list of all breeds in the form of <a href>dog breed</a>
breed_blocks = breeds_soup.find_all('a', class_=['post-title'])
breed_total = len(breed_blocks)

print('Gathering breed information... ')
for breed in breed_blocks:
    breed_info = {}
    breed_num = breed_num + 1
    breed_name = breed.get_text()

    # Store name of breed
    breed_info['Name'] = breed_name

    # Make BeautifulSoup Object for this breed
    s = requests.get(breed.get('href'))
    breed_soup = BeautifulSoup(s.text, 'html.parser')

    # Build a list, each item contains trait name and trait rating
    trait_blocks = breed_soup.find_all('a', class_='js-list-item-trigger item-trigger more-info')

    for trait in trait_blocks:
        # Store trait name and rating in breed info
        trait_name_block = trait.find('span', class_='characteristic item-trigger-title')
        trait_rating_block = trait.find('span', class_='star')
        breed_info[trait_name_block.get_text()] = trait_rating_block.get_text()

    # Store life span in breed info
    life_span_block = breed_soup.find('span', text='Life Span:')
    breed_info['Life Span'] = life_span_block.next_sibling.lstrip()

    # Store in data dictionary
    all_breed_data[breed_name] = breed_info

    # Print progress
    sys.stdout.write("\r%i out of %i processed... " % (breed_num, breed_total))
    sys.stdout.flush()
print('DONE', end='\n\n')

# Access any element in data and grab names for column header
column_names = list(list(all_breed_data.values())[0])

messy_breeds = []

print('Writing to CSV... ', end='')
with open('Breed_Information_DogTime.csv', 'w') as csvfile:
    filewriter = csv.writer(csvfile, delimiter=',')

    # Write column header
    filewriter.writerow(column_names)

    # Write row for each breed
    for breed_name, data in all_breed_data.items():
        # Build list
        try:
            data_list = []
            for column in column_names:
                data_list.append(data[column])
            filewriter.writerow(data_list)
        except Exception as e:
            messy_breeds.append(str(breed_name) + " missing " + str(e))
print('DONE', end='\n\n')

print("Breeds with messy data: ")
print(*messy_breeds, sep=', ')
print("Total breed count: " + str(len(all_breed_data)))
print("Total messy breed count: " + str(len(messy_breeds)))
print("Usable breed count: " + str(len(all_breed_data) - len(messy_breeds)))
