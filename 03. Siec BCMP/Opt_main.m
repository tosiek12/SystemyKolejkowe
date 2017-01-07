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
        function r = utilityFunction(obj , functionType, par1, par2)
            if(strcmp(functionType, 'funkcja1') > 0)
                C1 = par1;
                C2 = par2;
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
            elseif (strcmp(functionType, 'funkcja2') > 0)
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