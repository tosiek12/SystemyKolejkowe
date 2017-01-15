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
        
        n_max
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
           obj.cso = CSO(obj.network, functionT, par1, par2, obj.network.stations_m, 20, 120);
        end
        
    end
    
    %% Procedura optymalizacji
    methods ( Access = public )
        
        function r = FindBest(obj, maxIterations)
            obj.n_max = maxIterations;
            n = 0;
            disp(strcat('N = ', num2str(n)));
            prev = obj.cso.current_pg_value();
            now = obj.cso.step();
            while obj.stopCondition(n, prev, now) == false
                prev = now;
                now = obj.cso.step();
                disp(strcat('N = ', num2str(n)));
                n = n + 1;
            end
            
            r = obj.cso.get_best_network();
        end
        
        
        function r = stopCondition(obj, n, prev, now)
           disp('[prev, now, delta(now-prev)]')
           disp([prev, now, (now-prev)])
           
%            delta = 10^-2;
%            if n > 3 || abs(prev-now) < delta 
%               r = true;
%            else
%               r = false;
%            end

           if n > n_max
              r = true;
           else
              r = false;
           end

        end

    end
    
end