%% Konfiguracja - Opis sieci:
%(Ilosc stacji, Ilosc klas, Typ sieci (open/close))
siec = Network_nClass(6, 3, 'close');

%% Opis Stacji:
%Typy stacji (1/2/3/4)
siec.stations_types = [1; 1; 1; 1; 1; 3];
%Ilosc kanalow obslugi
%siec.stations_m = [3; 6; 4; 4; 10; 1];
siec.stations_m = [10; 38; 40; 40; 20; 1];
%Wspolczynnik obslugi zgloszen w stacjach dla ka�dej z klas
siec.stations_Mi{1} = [20; 5; 8; 10; 5; 100];
siec.stations_Mi{2} = [20; 5; 8; 10; 5; 100];
siec.stations_Mi{3} = [20; 5; 8; 10; 5; 100];

%% Opis przejsc pomiedzy stacjami:
%Macierz prawdopodobienstw przejsc z jednej stacji do drugiej
%Przej�cie z Pij -> prawdopodobie�stwo przej�cia z i-tej stacji do j-tej.
siec.P{1} = [0, 1, 0, 0, 0, 0;
             0, 0, 0, 0, 1, 0;
             0, 0, 0, 0, 0, 0;
             0, 0, 0, 0, 0, 0;
             0, 0, 0, 0, 0, 1;
             1, 0, 0, 0, 0, 0];
        
siec.P{2} = [0, 0, 1, 0, 0, 0;
             0, 0, 0, 0, 0, 0;
             0, 0, 0, 0, 1, 0;
             0, 0, 0, 0, 0, 0;
             0, 0, 0, 0, 0, 1;
             1, 0, 0, 0, 0, 0];
        
siec.P{3} = [0, 0, 0, 1, 0, 0;
             0, 0, 0, 0, 0, 0;
             0, 0, 0, 0, 0, 0;
             0, 0, 0, 0, 1, 0;
             0, 0, 0, 0, 0, 1;
             1, 0, 0, 0, 0, 0];

%% Ilosc zgloszen danej klasy w systemie
siec.K_initial{1} = 20; %6;
siec.K_initial{2} = 10; %8;
siec.K_initial{3} = 20; %10;