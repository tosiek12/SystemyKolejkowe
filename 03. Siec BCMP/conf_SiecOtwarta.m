%% Konfiguracja - example 7.7
siecOtwarta = Network_nClass(1, 'open'); %Typ sieci - open/close
siecOtwarta.N = 3; %Ilosc stacji
siecOtwarta.R = 2; %Ilosc klas

%Macierz prawdopodobienstw przejsc z jednej stacji do drugiej
siecOtwarta.P = {};
siecOtwarta.P{1} = [0, .4, .3;
                    .6, 0, .4;
                    .5, .5, 0];
siecOtwarta.P{2} = [0, .3, .6;
                    .7, 0, .3;
                    .4, .6, 0];
                
%Prawdopodobienstwa wejœcia zgloszenia z zewnatrz do danej stacji
siecOtwarta.P_in = {};
siecOtwarta.P_in{1} = [1, 0, 0]; 
siecOtwarta.P_in{2} = [1, 0, 0]; 

%Prawdopodobienstwa wyjœcia zgloszenia na zewnatrz z danej stacji
siecOtwarta.P_out = {};
siecOtwarta.P_out{1} = [.3, 0, 0]; 
siecOtwarta.P_out{2} = [.1, 0, 0]; 

%Wspolczynnik przychodzenia zgloszen danej klasy
siecOtwarta.lambdas = zeros(siecOtwarta.R,1); 
siecOtwarta.lambdas(1) = 1; 
siecOtwarta.lambdas(2) = 1; 

%Typy stacji 
siecOtwarta.stations_types = [2, 4, 4];  

%Wspolczynnik obslugi zgloszen w stacjach
siecOtwarta.stations_Mi = {[1/6, 1/25] 
                            [1/12, 1/32]
                            [1/16, 1/36]};    

%Ilosc kanalow obslugi na stacji
siecOtwarta.stations_m = [1, 1, 1];  

