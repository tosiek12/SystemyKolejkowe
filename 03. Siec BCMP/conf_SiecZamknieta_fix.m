%% Konfiguracja - Opis sieci:
%example 7.7
%(Ilosc stacji, Ilosc klas, Typ sieci (open/close))
siec = Network_nClass(4, 1, 'close');

%% Opis Stacji:
%Typy stacji (1/2/3/4)
siec.stations_types = [1; 1; 1; 3];
%Ilosc kanalow obslugi
siec.stations_m = [2; 1; 1; 1];
%Wspolczynnik obslugi zgloszen w stacjach dla ka¿dej z klas
siec.stations_Mi{1} = [1/0.5; 1/0.6; 1/0.8; 1/1];

%% Opis przejsc pomiedzy stacjami:
%Macierz prawdopodobienstw przejsc z jednej stacji do drugiej
%Przejœcie z Pij -> prawdopodobieñstwo przejœcia z i-tej stacji do j-tej.
siec.P{1} = [0, .5, .5, 0;
            0, 0, 0, 1;
            0, 0, 0, 1;
            1, 0 , 0, 0];

%% Ilosc zgloszen danej klasy w systemie
siec.K_initial{1} = 3;

