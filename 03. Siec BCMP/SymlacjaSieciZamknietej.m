%% Sieæ BCMP
% Projekt wykonany na zajecia. 
%% Konfiguracja:
clc; close; clear;
cd('C:\Users\Antonio-laptop\Documents\Studia\SystemyKolejkowe\03. Siec BCMP\')
run('conf_SiecZamknieta');
%% Oblicz parametry:
siec.calculateLambdas();

%% Oblicz ocenê rozwiazania:
%Inicjalizacja klasy optymalizowanej obiektem sieci.
%Siec posiada obliczone wartosci startowe.
opt = Opt_main(siec); 

%Okreslenie, ktore systemy maj¹ byc zmieniane:
% Konwencja: [numer stacji, wartoœæ od, wartoœæ do];
stationForOptymalization = {};
stationForOptymalization{1} = [1, 10, 50];
%stationForOptymalization{2} = [3, 2, 20];

%Okreslenie funkcji oceny. Funkcja jest minimalizowana.
%Wspolczynnikow dla funkcji oceny rozwiazania:
%Funkcja 1 - minimalizacja kosztu utrzymania kazdej ze stacji i wielkosci
%kolejki:
%Koszt kolejki:
C1 = {};
%Konwencja: [wsp. ceny dla stacji 1, wsp. ceny dla stacji 2, ..]
C1{1} = [1, 12, 12]; %1 klasa
C1{2} = [2, 12, 12]; %2 klasa
C1{3} = [1, 12, 12];

%Koszt utrzymania stacji:
%Konwencja: [wsp. ceny dla stacji 1, wsp. ceny dla stacji 2, ..]
C2 = [1, 4, 2];

%Funkcja 2 - aby czas obslugi w jednej ze stacji mia³ okreslon¹ wartoœæ:
%opt.SetOptymalization(stationForOptymalization, 'funkcja2', C1, C2);
%TODO:  zdefiniowaæ drug¹ funkcê oceny.

%Ustaw parametry:
opt.SetOptymalization(stationForOptymalization, 'funkcja1', C1, C2);
%res = opt.utilityFunction(); %testowe obliczenie funkcji oceny.

%Wykonaj optymalizacje
siec = opt.FindBest(); %do magic!

%% Pokaz wyniki
disp('Wyniki - porownanie do przykladu z 395 (8.6):');
disp('tylko wziete 3,4 klasy');

disp('Lambda per stacja:')
disp('Klasa 1:')
disp([siec.lambda(1, 1), 3.333;
    siec.lambda(1, 2), 2.292;
    siec.lambda(1, 3), 1.917]);
disp('Klasa 2:')
disp([siec.lambda(2, 1), 10;
    siec.lambda(2, 2), 8.049;
    siec.lambda(2, 3), 8.415]);

disp('Rho:')
rho1 = [siec.rho(1, 1);
    siec.rho(1, 2);
    siec.rho(1, 3)];
rho2 = [siec.rho(2, 1);
    siec.rho(2, 2);
    siec.rho(2, 3)];
rho_result = [.833;.443;.354];
disp([rho1 + rho2, rho_result]);

disp('K:')
disp('Klasa 1:')
disp([siec.K(1, 1), 2.5;
    siec.K(1, 2), .342;
    siec.K(1, 3), .186]);
disp('Klasa 2:')
disp([siec.K(2, 1), 2.5;
    siec.K(2, 2), .5;
    siec.K(2, 3), .362]);

disp('Q:')
disp('Klasa 1:')
disp([siec.Q(1, 1), 2.5;
    siec.Q(1, 2), .342;
    siec.Q(1, 3), .186]);
disp('Klasa 2:')
disp([siec.Q(2, 1), 2.5;
    siec.Q(2, 2), .5;
    siec.Q(2, 3), .362]);
