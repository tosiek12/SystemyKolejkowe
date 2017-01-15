%% Konfiguracja - Opis sieci:
%(Ilosc stacji, Ilosc klas, Typ sieci (open/close))
siec = Network_nClass(6, 3, 'close');

%% Opis Stacji:
%Typy stacji (1/2/3/4)
siec.stations_types = [1; 1; 1; 1; 1; 3];
%Ilosc kanalow obslugi
siec.stations_m = [3; 6; 4; 4; 10; 1];
%Wspolczynnik obslugi zgloszen w stacjach dla ka¿dej z klas
siec.stations_Mi{1} = [20; 5; 8; 10; 5; 100];
siec.stations_Mi{2} = [20; 5; 8; 10; 5; 100];
siec.stations_Mi{3} = [20; 5; 8; 10; 5; 100];

%% Opis przejsc pomiedzy stacjami:
%Macierz prawdopodobienstw przejsc z jednej stacji do drugiej
%Przejœcie z Pij -> prawdopodobieñstwo przejœcia z i-tej stacji do j-tej.
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

%% Wspolczynnik przychodzenia zgloszen danej klasy
siec.lambda_in{1} = 10;
siec.lambda_in{2} = 20;
siec.lambda_in{3} = 25;

%% Ilosc zgloszen danej klasy w systemie
siec.K_initial{1} = 500;
siec.K_initial{2} = 800;
siec.K_initial{3} = 1000;