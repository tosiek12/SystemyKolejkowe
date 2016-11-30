%% Definicja problemu:
%Przej�cie z Pij -> prawdopodobie�stwo przej�cia z i-tej stacji do j-tej.
P = [0, .5, .5, 0;
    1, 0, 0, 0;
    .6, 0, 0, 0;
    1, 0 , 0, 0];
%Stacja na ktora i z jaka wartoscia przychodza zgloszenia.
n = 4;
lam = 4;

%% Rozwiazanie:
%Obliczenia:
lambda = zeros(4,1);
lambda(n) = lam;
A = (eye(size(P,1))-P');
lambda_rozw = lsqlin(A, lambda);

%Finalny wsp�czynnik przychodzenia zgloszen do danych stacji:
lambda_rozw