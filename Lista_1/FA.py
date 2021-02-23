#!usr/bin/python3

import sys

from collections import Counter

def finite_automaton(text, alphabet, pattern):
    """ Automat skonczony """

    results = []
    pattern_length = len(pattern)
    delta = transition_function(pattern, alphabet)
    q = 0

    # poszukiwanie przejsc zgodnych ze wzorcem
    for i in range(0, len(text)):
        q = delta[(q, text[i])]
        if q == pattern_length:
            results.append(i - pattern_length + 1)

    return results


def transition_function(pattern, alphabet):
    """ Funkcja przejscia """
    result = {}
    pattern_length = len(pattern)
    for q in range(0, pattern_length + 1):
        for character in alphabet:
            k = min(pattern_length + 1, q + 2) - 1

            # sprawdzenie czy pattern[:k] jest suffixem pattern[:q] + character
            while not (pattern[:q] + character).endswith(pattern[:k]):
                k = k - 1

            # najwieksze mozliwe k
            result[(q, character)] = k

    return result

def run_app(pattern, filename):
    """ Wczytanie pliku oraz uruchomienie automatu.
        Zakladam, ze kazda linia tekstu moze byc czytana oddzielnie. """

    alphabet = []
    # dlugosc sprawdzanej linii
    line_length = 0

    # dlugosc poprzedniej linii
    prev_line = 0

    print("Pattern occurs with shift/s: ")
    with open(filename, "r", encoding="utf-8-sig") as f:
        # wczytywanie danych z pliku, linijka, po linijce
        for line in f:
            # obcinanie znakow konca linii, zakladam ze nie naleza do alfabetu
            stripped_line = line.strip()
            # alfabet jest tworzony na podstawie konkretnej linijki
            alphabet.clear()
            # tworzenie alfabetu
            wordcount = Counter(stripped_line)
            for key in wordcount:
                alphabet.append(key)

            result = finite_automaton(stripped_line, alphabet, pattern)
            # przesuniecie indeksowania

            prev_line += line_length
            line_length = len(stripped_line) + 1
            for el in result:
                # wypisanie wyniku zwracanego przez automat + przesuniecie
                print(prev_line + el, end=' ')

    print()

if __name__ == "__main__":

    try:
        pattern = sys.argv[1]
        filename = sys.argv[2]
        run_app(pattern, filename)
    except IndexError:
        print("Bad arguments!")
        print("Remember to use ' ' with special characters")
        print("Use: python3 FA <pattern> <filename>")
