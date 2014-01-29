#!/usr/bin/python -tt

## Summary: count words in a text file


import sys
import re  # for normalizing words


def normalize_word(word):
    word_normalized = word.strip().lower()
    match = re.search(r'\W*(\w+|\w\W+\w)\W*', word_normalized)
    if match:
        return match.group(1)
    else:
        return word_normalized


def count_word_in_file(filename):
    #my_file = open(filename, 'rU', 'utf-8')
    my_file = open(filename, 'rU')
    word_dict = {}
    for line in my_file:
        words = line.split()
        for w in words:
            # mengToDo: improve word normalization logic
            # What Google's n-gram data set uses?
            w_normalized = normalize_word(w)
            if w_normalized in word_dict:
                word_dict[w_normalized] += 1
            else:
                word_dict[w_normalized] = 1
    return word_dict


def print_word_count(filename):
    """counts how often each word appears in the text and prints:
word1 count1
word2 count2
...

in order sorted by word. 'Foo' and 'foo' count as the same word
"""
    word_count_dict = sorted(count_word_in_file(filename).items())
    for word, count in word_count_dict:
        print word, count
    return word_count_dict


def get_count(word_count_tup):
    return word_count_tup[1]


def print_top_words(filename, size=50):
    """prints just the top 20 most common words sorted by sizeber of occurrences of each word such
that the most common word is first."""
    word_count_dict = count_word_in_file(filename)

    sorted_word_count_dict = sorted(word_count_dict.items(), key=get_count, reverse=True)

    for word, count in sorted_word_count_dict[:size]:
        print word, count

###


def main():
    if len(sys.argv) != 3:
        print 'usage: ./wordcount.py {--count | --topwords} file'
        sys.exit(1)

    option = sys.argv[1]
    filename = sys.argv[2]
    if option == '--count':
        print_word_count(filename)
    elif option == '--topwords':
        print_top_words(filename)
    else:
        print 'unknown option: ' + option
        sys.exit(1)


if __name__ == '__main__':
    main()

# END