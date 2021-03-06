%% Konfiguracja - Opis sieci:
%(Ilosc stacji, Ilosc klas, Typ sieci (open/close))
siec = Network_nClass(3, 2, 'close');

%% Opis Stacji:
%Typy stacji (1/2/3/4)
siec.stations_types = [1; 1; 3];
%Ilosc kanalow obslugi
siec.stations_m = [3; 4; 1];
%Wspolczynnik obslugi zgloszen w stacjach dla ka�dej z klas
siec.stations_Mi{1} = [1/0.2; 1/4; 1];
siec.stations_Mi{2} = [1/3; 1/3; 1/22];
siec.stations_Mi{3} = [1/3; 1/66; 1/22];

%% Opis przejsc pomiedzy stacjami:
%Macierz prawdopodobienstw przejsc z jednej stacji do drugiej
%Przej�cie z Pij -> prawdopodobie�stwo przej�cia z i-tej stacji do j-tej.
siec.P{1} = [0, .5, .5;
            0, 0,  1;
            1, 0,  0];
        
siec.P{2} = [0, 1, 0;
            0, 0, 1;
            1, 0 , 0];
        
siec.P{3} = [0, 1, 0;
            0, 0, 1;
            1, 0 , 0];

%% Wspolczynnik przychodzenia zgloszen danej klasy
siec.lambda_in{1} = 4;
siec.lambda_in{2} = 3;
siec.lambda_in{3} = 4;

%% Ilosc zgloszen danej klasy w systemie
siec.K_initial{1} = 10;
siec.K_initial{2} = 20;
siec.K_initial{3} = 15;