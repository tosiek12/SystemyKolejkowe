%% Funkcje do optymalizacji
%Funkcja celu:
classdef Opt_main<handle
    %% Parametry stacji
    properties ( Access = public )
        network %Network_nClass
        cso
    end
    
    properties ( Access = private )
        stationForOptymalization
        utilityFunction
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
           
           addpath('..\04. Algorytm karalucha\');
           obj.cso = CSO(obj.network, functionT, par1, par2, obj.network.stations_m, 50, 50);
        end
        
    end
    

    
    %% Procedura optymalizacji
    methods ( Access = public )
        
        function r = FindBest(obj)
            n = 0;
            prev = obj.cso.current_pg_value();
            now = obj.cso.step();
            
            while obj.stopCondition(n, prev, now) == false
                prev = now;
                now = obj.cso.step();
                disp(strcat('N = ', num2str(n)));
                n = n + 1;
            end
            
            r = obj.cso.get_best_network();
%             n = 0;
%             prev = Inf;
%             now = obj.utilityFunction();
%             disp('[n,now]');
%             disp([n, now]);
%             
%             while obj.stopCondition(n, prev, now) == false
%                 %do karaluch magic:
%                 
%                 %na podstawie stationForOptymalization
%                 new_m = obj.network.stations_m;
%                 % wybierz, ktore stacje maja byc zmieniane:
%                 for i = 1:size(obj.stationForOptymalization(:), 1)
%                     tmp = obj.stationForOptymalization{i};
%                     %tmp = [numer stacji, wartoœæ od, wartoœæ do];
%                     new_m(tmp(1))= n+1; %hardcode -> do zmiany
%                 end
%                 
%                 %ustaw nowe wartosci dla sieci:
%                 %na podstawie alg. karalucah
%                 
%                 disp('new_m');
%                 disp(new_m');
%                 obj.network.stations_m = new_m;
%                 obj.network.calculateLambdas();
%                 
%                 %odswiez funkcje celu:
%                 
%                 
%                 prev = now;
%                 now = obj.utilityFunction();
%                 n = n+1;
%                 disp('[n,now]');
%                 disp([n, now]);
%             end
%             
%             %return final web:
%             r = obj.network;
        end
        
        
        function r = stopCondition(obj, n, prev, now)
           disp('[prev,now]')
           disp([prev,now])   
           
%            delta = 10^-2;
%            if n > 3 || abs(prev-now) < delta 
%               r = true;
%            else
%               r = false;
%            end

           if n > 10
              r = true;
           else
              r = false;
           end

        end

    end
    
end