#!usr/bin/python3
import sys

def KMP_matcher(text, pattern):
    """ Automat Knutha-Morrisa-Pratta """

    results = []
    pattern_length = len(pattern)
    pi = prefix_function(pattern)

    # liczba dopasowanych znakow
    q = 0
    for i in range(len(text)):
        while q > 0 and pattern[q] != text[i]:
            # nastepny znak nie pasuje
            q = pi[q - 1] + 1

        if pattern[q] == text[i]:
            # nastepny znak pasuje
            q = q + 1

        if q == pattern_length:
            # znaleziono wzorzec
            results.append(i - pattern_length + 1)
            # kontynuacja poszukiwan
            q = pi[q - 1] + 1

    return results


def prefix_function(pattern):

    pattern_length = len(pattern)
    pi = [None for i in range(0, pattern_length)]
    pi[0] = -1
    k = -1

    for q in range(1, pattern_length):
        while k > -1 and pattern[k + 1] != pattern[q]:
            k = pi[k]
        if pattern[k + 1] == pattern[q]:
            k = k + 1

        pi[q] = k

    return pi

def run_app(pattern, filename):
    """ Wczytanie pliku oraz uruchomienie automatu.
        Zakladam, ze kazda linia tekstu moze byc czytana oddzielnie. """


    # dlugosc sprawdzanej linii
    line_length = 0
    # dlugosc poprzedniej linii
    prev_line = 0

    print("Pattern occurs with shift/s: ")

    with open(filename, "r", encoding="utf-8-sig") as f:
        # wczytywanie danych z pliku, linijka, po linijce
        for line in f:
            # obcinanie znakow konca linii, zakladam ze nie naleza alfabetu
            stripped_line = line.strip()
            result = KMP_matcher(stripped_line, pattern)

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
        print("Use: python3 KMP <pattern> <filename>")
