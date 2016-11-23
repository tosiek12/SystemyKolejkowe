%% Konfiguracja:
N = 3;
typ = 'open'; %open/close
Station_types = [1, 1, 1];
Station_lamda = [4, 1/48, .1];
Station_Mi = [100/22, 1/30 .1];
Station_m = [1, 1, .1];


P = zeros(N, N);
P(1,2) = 1;
P(2,3) = 1;