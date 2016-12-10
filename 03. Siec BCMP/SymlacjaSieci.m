%% Sieæ BCMP
% Projekt wykonany na zajecia. 
%% Konfiguracja:
clc; close; clear;
cd('C:\Users\Antonio-laptop\Documents\Studia\SystemyKolejkowe\03. Siec BCMP\')
%run('conf_SiecOtwarta');
%run('conf_SiecZamknieta');

run('conf_SiecZamknieta_fix');
%% Finalna siec:
siec

%% Oblicz parametry:
lambdas = siec.calculateLambdas();

disp('Wyniki - porownanie do przykladu z 445strony i 391(obliczenia dokladne):')

disp('Lambda ca³osc:')
disp([siec.stations_lambda, 1.193]);    %wynik doklady 1.217

disp('Lambda per stacja:')
disp([siec.getStation(1, 1).lambda, 1.193;
    siec.getStation(1, 2).lambda, 0.596;
    siec.getStation(1, 3).lambda, 0.596;
    siec.getStation(1, 4).lambda, 1.193]);

disp('Rho - na podstawie 391:')
disp([siec.getStation(1, 1).rho, 2*0.304;
    siec.getStation(1, 2).rho, 1*0.365;
    siec.getStation(1, 3).rho, 1*0.487]);

disp('K:')
disp([siec.getStation(1, 1).K, 0.637;
    siec.getStation(1, 2).K, 0.470;
    siec.getStation(1, 3).K, 0.700;
    siec.getStation(1, 4).K, 1.193]);

%% Oblicz parametry - siec zamknieta
%3. Perf measures:
%4. Marginal probabilities:
%5. State probabilities:

