%% Sieæ BCMP
% Projekt wykonany na zajecia. 
%% Konfiguracja:
clc; close; clear;
cd('C:\Users\Antonio-laptop\Documents\Studia\SystemyKolejkowe\03. Siec BCMP\')
%run('conf_SiecOtwarta');
%run('conf_SiecZamknieta');
run('conf_SiecZamknieta_fix');
%% Oblicz parametry:
siec.calculateLambdas();

%% Pokaz wyniki

disp('Wyniki - porownanie do przykladu  z stron 445() (fix) i 391(8.4) (obliczenia dokladne):')

disp('Lambda ca³osc:')
disp([siec.stations_lambda, 1.193]);    %wynik doklady 1.217

disp('Lambda per stacja:')
%siec.lambda(1, '*')
disp([siec.lambda(1, 1), 1.193;
    siec.lambda(1, 2), 0.596;
    siec.lambda(1, 3), 0.596;
    siec.lambda(1, 4), 1.193]);

disp('Rho - na podstawie 391:')
disp([siec.rho(1, 1), 0.304;
    siec.rho(1, 2), 0.365;
    siec.rho(1, 3), 0.487;
    siec.rho(1, 4), 0]);

disp('K:')
disp([siec.K(1, 1), 0.637;
    siec.K(1, 2), 0.470;
    siec.K(1, 3), 0.700;
    siec.K(1, 4), 1.193]);

%% Oblicz parametry - siec zamknieta
%3. Perf measures:
%5. State probabilities:

