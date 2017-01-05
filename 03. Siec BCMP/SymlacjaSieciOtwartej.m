%% Sieæ BCMP
% Projekt wykonany na zajecia. 
%% Konfiguracja:
clc; close; clear;
cd('C:\Users\Antonio-laptop\Documents\Studia\SystemyKolejkowe\03. Siec BCMP\')
run('conf_SiecOtwarta');
%run('conf_SiecZamknieta');
%%run('conf_SiecZamknieta_fix');

%% Oblicz parametry:
siec.calculateLambdas();

%% Pokaz wyniki
disp('Wyniki - porownanie do przykladu 7.7 z 362 strony:')

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
disp([rho1 + rho2,rho_result]);

disp('K:')
disp('Klasa 1:')
disp([siec.K(1, 1), 2.5;
    siec.K(1, 2), .342;
    siec.K(1, 3), .186]);
disp('Klasa 2:')
disp([siec.K(2, 1), 2.5;
    siec.K(2, 2), .5;
    siec.K(2, 3), .362]);
