%% Konfiguracja - Opis sieci:
%example 7.7
%(Ilosc stacji, Ilosc klas, Typ sieci (open/close))
siec = Network_nClass(4, 2, 'close');

%% Opis Stacji:
%Typy stacji (1/2/3/4)
siec.stations_types = [1, 1, 1, 1];
%Ilosc kanalow obslugi
siec.stations_m = [5, 1, 1, 1];
%Wspolczynnik obslugi zgloszen w stacjach dla ka¿dej z klas
siec.stations_Mi{1} = [1/6; 1/12; 1/16];
siec.stations_Mi{2} = [100/22; 100/22; 100/22];

%% Opis przejsc pomiedzy stacjami:
%Macierz prawdopodobienstw przejsc z jednej stacji do drugiej
%Przejœcie z Pij -> prawdopodobieñstwo przejœcia z i-tej stacji do j-tej.
siec.P{1} = [0, .5, .5, 0;
            1, 0, 0, 0;
            .6, 0, 0, 0;
            1, 0 , 0, 0];
        
siec.P{2} = [0, .5, .5, 0;
            0, 0, 0, 1;
            0, 0, 0, 1;
            1, 0 , 0, 0];

%% Wspolczynnik przychodzenia zgloszen danej klasy
siec.lambda_in{1} = 4;
siec.lambda_in{2} = 4;

%% Ilosc zgloszen danej klasy w systemie
siec.K_initial{1} = 10;
siec.K_initial{2} = 5;
