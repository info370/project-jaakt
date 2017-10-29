import sys
import csv
import plotly.plotly
import plotly.graph_objs

# Get word for analysis from system arguments
word = sys.argv[1]

# Constant that defines the least amount of valid songs to help even out the songs checked
# Derived from song_errors in SongScraper.py; 1941 had 53 missing songs so 43 valid songs
MAX_ERROR = 43

freq_word_by_year = {}
# Keeps track of the song with the most occurrences of the word
# Format; {year: song_name|occurrences} kinda hacky but needed to keep track of name and count
song_with_most_occ = {}
songs_dataset = {}


# Create dataset from csv file
with open('assets/song_dataset.csv', 'r') as f:
    reader = csv.reader(f)
    rowNr = 0

    for row in reader:
        # Skips the first row since it is the titles
        if rowNr >= 1:
            if (row[0] in songs_dataset):
                songs_dataset[row[0]].update({row[1]: row[2]})
            else:
                songs_dataset[row[0]] = {row[1]: row[2]}

        rowNr += 1

# Loop through each song in each year checking for occurrence of the word
for year, song_list in songs_dataset.items():
    # Sets
    song_with_most_occ[year] = 'No song had the word ' + word + '|0'
    # Starts with one valid song
    error_adjuster = 1
    for composer, song in song_list.items():
        # Only checks for the first MAX_ERROR songs
        if (error_adjuster >= 43):
            break
        else:
            error_adjuster += 1
        song_file = song.translate(song.maketrans(' ', '_','()'))
        lyric = open('assets/' + song_file + '.txt', 'r').read()

        # Count of occurences with both lyrics and word lowercassed and spaces on left side
        # to ensure that it is not a substring
        word_occ = lyric.lower().count(' ' + word.lower())

        if (year in freq_word_by_year):
            # Gets current max occurences with the delimiter
            max_occ = int(song_with_most_occ[year].split('|')[1])

            # If the current count is greater than max it replaces the max
            if (word_occ > max_occ):
                song_with_most_occ[year] = song + ' by ' + composer +  ' uses ' + word + ' ' + str(word_occ) + ' time(s)|' + str(word_occ)
            freq_word_by_year[year] += word_occ
        else:
            freq_word_by_year[year] = word_occ

# Graphs x as years and y as frequency of word used
plotly.offline.plot({
"data": [
    plotly.graph_objs.Bar(
        x=list(freq_word_by_year.keys()),
        y=list(freq_word_by_year.values()),
        text=[i.split('|')[0] for i in list(song_with_most_occ.values())] # Extracts list of song names with max occ
    )
],
"layout":
    plotly.graph_objs.Layout(
        title='Frequency of The Word \'' + word.title() + '\' In Top ' + str(MAX_ERROR) + ' Songs From 1949-2016',
        xaxis=dict(
            title='Year'
        ),
        yaxis=dict(
            title='Frequency of ' + word.title()
        )
    )
})

# py.offline.plot(data, filename='Frequency of the word \'' + word + '\' in top ' + str(MAX_ERROR) + 'songs from 1949-2016')


print(freq_word_by_year)
