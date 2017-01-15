%% Sieæ BCMP
% Projekt wykonany na zajecia. 
%% Konfiguracja:
clc; close; clear;
% cd('C:\Users\Antonio-laptop\Documents\Studia\SystemyKolejkowe\03. Siec BCMP\')
run('conf_SiecZamknieta_przyklad');
siec_opt = siec;
clear ('siec')
run('conf_SiecZamknieta_przyklad');
%% Oblicz parametry:
siec.calculateLambdas();

%% Oblicz ocenê rozwiazania:
%Inicjalizacja klasy optymalizowanej obiektem sieci.
%Siec posiada obliczone wartosci startowe.
opt = Opt_main(siec_opt); 

%Okreslenie, ktore systemy maj¹ byc zmieniane:
% Konwencja: [numer stacji, wartoœæ od, wartoœæ do];
stationForOptymalization = {};
stationForOptymalization{1} = [1, 10, 50];
%stationForOptymalization{1} = [3, 2, 20];

%Okreslenie funkcji oceny. Funkcja jest minimalizowana.
%Wspolczynnikow dla funkcji oceny rozwiazania:
%Funkcja 1 - minimalizacja kosztu utrzymania kazdej ze stacji i wielkosci
%kolejki:
%Koszt kolejki:
C1 = {};
%Konwencja: [wsp. ceny dla stacji 1, wsp. ceny dla stacji 2, ..]
C1{1} = [1, 12, 12, 1, 1, 0]; %1 klasa
C1{2} = [2, 12, 12, 1, 1, 0]; %2 klasa
C1{3} = [1, 12, 12, 1, 1, 0]; %3 klasa

%Koszt utrzymania stacji:
%Konwencja: [wsp. ceny dla stacji 1, wsp. ceny dla stacji 2, ..]
C2 = [1, 4, 2, 1, 1, 0];

%Ustaw parametry:
opt.SetOptymalization(stationForOptymalization, 'funkcja1', C1, C2);

%Wykonaj optymalizacje
siec_opt = opt.FindBest(1);

%% Pokaz wyniki
disp('Wyniki - porownanie po optymalizacji');
disp('Liczba stanowisk');
disp([siec.m('*');
    siec_opt.m('*')]);

disp('Lambda per stacja:')
for i = 1: siec.R
    disp(['Klasa ', num2str(i), ':'])
    disp([siec.lambda(i, '*');
        siec_opt.lambda(i, '*')]);
end

disp('Rho:')
for i = 1: siec.R
    disp(['Klasa ', num2str(i), ':'])
    disp([siec.rho(i, '*');
        siec_opt.rho(i, '*')]);
end

disp('K:')
for i = 1: siec.R
    disp(['Klasa ', num2str(i), ':'])
    disp([siec.K(i, '*');
        siec_opt.K(i, '*')]);
end

disp('Q:')
for i = 1: siec.R
    disp(['Klasa ', num2str(i), ':'])
    disp([siec.Q(i, '*');
        siec_opt.Q(i, '*')]);
end

disp('m0:')
for i = 1: siec.R
    disp(['Klasa ', num2str(i), ':'])
    disp([siec.m0(i, '*');
        siec_opt.m0(i, '*')]);
end