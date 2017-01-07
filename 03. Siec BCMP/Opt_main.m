%% Funkcje do optymalizacji
%Funkcja celu:
classdef Opt_main<handle
    %% Parametry stacji
    properties ( Access = public )
        network %Network_nClass
    end
    
    properties ( Access = private )
        stationForOptymalization
        functionType
        
        %Parametry dla funkcji oceny:
        par1
        par2
    end
    
    %% Konstruktor
    methods ( Access = public )
        function obj = Opt_main(networkIn)
          if nargin >= 1
                obj.network = networkIn;
          else
            error('Need connected network as input')
          end
        end
    end
    
    %% Funkcje pomocnicze
    methods ( Access = public )
        
        function SetOptymalization(obj, Station, functionT, par1, par2)
           obj.stationForOptymalization = Station;
           obj.functionType = functionT;
           obj.par1 = par1;
           obj.par2 = par2;
        end
        
    end
    
    %% funkcja celu
    methods ( Access = public )
       
        function r = utilityFunction(obj)
            if(strcmp(obj.functionType, 'funkcja1') > 0)
                C1 = obj.par1;
                C2 = obj.par2;
                par_sum = 0;
                for iKlasa = 1:obj.network.R
                    for jStacja =1:obj.network.N
                        if C1{iKlasa}(jStacja) ~= 0 
                            par_sum = par_sum + C1{iKlasa}(jStacja) * obj.network.Q(iKlasa,jStacja);
                        end
                    end
                end
                for jStacja =1:obj.network.N
                    if C2(jStacja) ~= 0 
                        par_sum = par_sum + C2(jStacja) * obj.network.m0(iKlasa,jStacja);
                    end
                end
                r = par_sum;
            elseif (strcmp(obj.functionType, 'funkcja2') > 0)
                r = 2+rand(1)*5;
            else
                r = inf;
                error('Utility function not defined.');
            end
        end

    end
    
    %% Procedura optymalizacji
    methods ( Access = public )
        
        function r = FindBest(obj)
            
            n = 0;
            prev = Inf;
            now = obj.utilityFunction();
            disp([n, now]);
            
            while obj.stopCondition(n, prev, now) == false
                %do karaluch magic:
                
                %na podstawie stationForOptymalization
                new_m = obj.network.stations_m;
                % wybierz, ktore stacje maja byc zmieniane:
                for i = 1:size(obj.stationForOptymalization(:), 1)
                    tmp = obj.stationForOptymalization{i};
                    %tmp = [numer stacji, wartoœæ od, wartoœæ do];
                    new_m(tmp(1))= n+1; %hardcode -> do zmiany
                end
                
                %ustaw nowe wartosci dla sieci:
                %na podstawie alg. karalucah
                disp(new_m');
                obj.network.stations_m = new_m;
                obj.network.calculateLambdas();
                
                %odswiez funkcje celu:
                
                
                prev = now;
                now = obj.utilityFunction();
                n = n+1;
                disp([n, now]);
            end
            
            %return final web:
            r = obj.network;
        end
        
        function r = stopCondition(obj, n, prev, now)
           delta = 10^-2;
           if n > 3 || abs(prev-now) < delta 
              r = true;
           else
              r = false;
           end
           
        end
    end
    
end