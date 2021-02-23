################################################
Rozwiązanie zadania pierwszego z listy pierwszej.
################################################


Sposób uruchomienia programów:

- automat skończony

python3 FA <wzorzec> <nazwa pliku>


- automat Knutha-Morrisa-Pratta

python3 KMP <wzorzec> <nazwa pliku>



Gdzie nazwa pliku to plik, w którym będzie szukany podany wzorzec. 

######
UWAGA!
######

- przy każdym uruchomieniu programu, jako parametr, może zostać podany tylko jeden wzorzec
- w przypadku pliku składającego się z więcej niż 1 linii, wyszukiwanie wzorca będzie wykonywane linijka po linijce.
  Zakładam, że znaki nowej linii oddzielają tekst, jednak nie należą do alfabetu, więc w przypadku gdy wzorzec 
  będzie się składał z końca i początku nowej linii, nie zostanie wówczas wykryty.
  Przykład:

	Dane w pliku: 

	aaaaaaaaaaaaaab
	aaaaaaaaaaaaaaa

	Wzorzec: ba

	Dla takich danych, wzorzec nie istnieje w podanym tekście.

- zakładam również, że plik o rozmiarze ~ 2GB nie będzie pojedynczą linijką tekstu :) 



