#!/usr/bin/env python

import os
import csv
import nltk
import string
import matplotlib.pyplot as plt

from os import path
from wordcloud import WordCloud
from nltk import word_tokenize
from nltk.corpus import stopwords

d = path.dirname(__file__) if "__file__" in locals() else os.getcwd()
dataset = path.join(d, 'osu!nichat24092019-aggregate.csv')

# nltk.download('punkt')
# nltk.download('stopwords')


def read_dataset(filename):
    with open(filename) as csv_file:
        reader = csv.reader(csv_file, delimiter=',')
        return {rows[1]: rows[2] for rows in reader}


def clean_dataset(dataset):
    for user, message in dataset.items():
        tempMsg = message.lower()  # Make text lowercase
        # Remove numbers
        tempMsg = ''.join([i for i in tempMsg if not i.isdigit()])
        # Remove stop words
        stop = set(stopwords.words('spanish'))
        words = [i for i in word_tokenize(tempMsg) if i not in stop]
        tempMsg = ' '.join(words)
        # Remove punctuation
        tempMsg = tempMsg.translate(str.maketrans('', '', string.punctuation))
        dataset[user] = tempMsg


df = read_dataset(dataset)
clean_dataset(df)

# wordcloud = WordCloud().generate(df["User"])

for user, message in df.items():
    if len(message) <= 0:
        continue
    try:
        wc = WordCloud(background_color="white", max_words=2000, max_font_size=100,
                    random_state=42, width=1000, height=860, margin=2,)
        wc.generate(message)
        plt.imshow(wc, interpolation='bilinear')
        plt.axis("off")
        plt.title(user)
        # plt.show()
        wc.to_file(path.join(d, "WcByUser", user + ".png"))
    except ValueError:
        continue
