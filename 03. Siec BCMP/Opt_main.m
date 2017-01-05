%% Funkcje do optymalizacji
%Funkcja celu:
classdef Opt_main<handle
    %% Parametry stacji
    properties ( Access = public )
        network %Network_nClass
    end
    properties ( Access = private )
        
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
    
    %% funkcja celu
    methods ( Access = public )
        function r = utilityFunction(obj , functionType)
          if(instr(functionType,'time') >-1)
                r = rand(1)*4;
                i = 1 to obj.N
                obj.network.T(i,j)
          elif (instr(functionType,'testowaFunkcja') > -1)
                r = 2+rand(1)*5;
          else
            error('Utility function not defined.');
          end
        end
    
% odswiez wartosci w symulacji
        function r = step(obj, step)
            obj.rand(1)*4;            
            %obj.rand(1)*4;
        end
    end
    
    
    
    
end