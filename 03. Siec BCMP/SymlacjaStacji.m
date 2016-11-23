%% Sieæ BCMP
% Projekt wykonany na zajecia. 
%% Konfiguracja:
clc; close; clear;
cd('C:\Users\Antonio-laptop\Documents\Studia\SystemyKolejkowe\03. Siec BCMP\')
run('conf_Stacje');

%% Stworz stacje na podstawie konfiguracji:
listOfStations= Station_1Class(0,0); %initialize 
for i = 1:N
    listOfStations(i) = Station_1Class(i, Station_types(1, i));
    listOfStations(i).Mi = Station_Mi(i);
    listOfStations(i).m = Station_m(i);
    listOfStations(i).lambda = Station_lamda(i);
end

%% Oblicz parametry:
%Zadanie 1:
s1 = listOfStations(1);
s1.p(0)
s1.W
s1.T

%Zadanie 2:
s1 = listOfStations(2);
msg = sprintf('pi(0) = %.2d - %.2d',(s1.p(0)),(1-s1.rho));
msg = sprintf('pi(N>=2) = %.2d',1-(s1.p(0)+s1.p(1)));
disp(msg);
s1.W
s1.T