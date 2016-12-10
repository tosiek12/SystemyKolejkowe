%% Sieæ BCMP
% Projekt wykonany na zajecia. 
%% Konfiguracja:
clc; close; clear;
cd('C:\Users\Antonio-laptop\Documents\Studia\SystemyKolejkowe\03. Siec BCMP\')
%run('conf_SiecOtwarta');

run('conf_SiecZamknieta');
%% Finalna siec:
siec

%% Oblicz parametry:
lambdas = siec.calculateLambdas()
siec.K(2, 1)


%% Oblicz parametry - siec zamknieta
%1. Visit ratio [eq. 7.71]:
    %vr = siecOtwarta.visitRatios();
    %vr{1}
%2. Utylization rho of each node [eq. 7.86]:
%3. Perf measures:
%4. Marginal probabilities:
%5. State probabilities:

