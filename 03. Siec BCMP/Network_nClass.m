classdef Network_nClass<handle
    properties ( Access = public )
        stations_lambda,
        stations_visitRatio,
        
        stations_types,
        stations_Mi,
        stations_m,
        
        P,
        
        P_in
        P_out,
        lambda_in,
        
        %Ilosc zgloszen danej klasy w systemie w sieci zamknietej
        K_initial
    end
    properties ( Access = private )        
        N,
        R,
        Type
    end
    
    %% Constructor:
    methods ( Access = public )
        function obj = Network_nClass(N, R, type)
            if nargin >= 3
                obj.Type = type;
                obj.N = N;
                obj.R = R;

                %Set initial values as cells:
                obj.P = {};
                obj.P_in = {};
                obj.lambda_in = {};
                obj.stations_visitRatio = {};
                obj.P_out = {};
                obj.stations_Mi = {};
                obj.K_initial = {};
            else
                error('Must be 4 arguments!')
            end
        end
    end
    
    %% Common functions:
    methods ( Access = public )
        function v = visitRatios(obj)
            for i = 1:size(obj.P, 2)
				if strcmp(obj.Type,'open') > 0 
					A = eye(obj.N) - obj.P{i}';
					obj.stations_visitRatio{i} = lsqlin(A, obj.P_in{i});
                else 
                    %za�o�enie: e1 = 1;
                    A_cale = eye(obj.N) - obj.P{i}';
                    A = A_cale(2:obj.N, 2:obj.N);   %Odetnij pierwszy wiersz i kolumne
                    out = (-1)*A_cale(2:obj.N, 1);   %pierwsza kolumna bez pierwszego wiersza
                    res = lsqlin(A, out);
					obj.stations_visitRatio{i} = [1; res];  %Doklej e1 = 1
				end
            end
            v = obj.stations_visitRatio;
        end
		
        function lambda_final = calculateLambdas(obj)
			obj.visitRatios();
            if strcmp(obj.Type,'open') > 0 
                lambda_final = obj.calculateLambdas_open;
            else 
                lambda_final = obj.calculateLambdas_close;
            end
        end
        
        function station = getStation(obj, iKlasa, iStacja)
            station = Station_1Class(iStacja, obj.stations_types(iStacja));
            station.Mi = obj.stations_Mi{iKlasa}(iStacja);
            station.m = obj.stations_m(iStacja);
            station.lambda = obj.stations_lambda{iKlasa}(iStacja);
        end
    end
    
    %% Podstawowe parametry
    methods ( Access = public)
        function r = p(obj, iKlasa, iStacja, k)
            stacja = obj.getStation(iKlasa, iStacja);
            r = stacja.p(k);
        end
        function r = K(obj, iKlasa, iStacja)
            stacja = obj.getStation(iKlasa, iStacja);
            r = stacja.K();
        end
        function r = Q(obj, iKlasa, iStacja)
            stacja = obj.getStation(iKlasa, iStacja);
            r = stacja.Q();
        end
        function r = m0(obj, iKlasa, iStacja)
            stacja = obj.getStation(iKlasa, iStacja);
            r = stacja.m0();
        end 
    end
            
    %% Closed network:
    methods ( Access = private )      
        
        %Step2:Fixed Point Iteration:
        function lambda_final = calculateLambdas_close(obj)
            %Init lambda:
            lambda_current = {};
            for i = 1:obj.R
                lambda_current{i} = ones(obj.N, 1).*10^-5;
            end
            
            %Do fix magic
            
            %assign result:
            obj.stations_lambda{i} = ones(obj.N, 1).*10^-5;  %dummy
            
            lambda_final = obj.stations_lambda;
        end
        
        function res = fix(obj, lambda_current)
            %pomocnicze zmienne:
            stations_LambdaInversed = diag((inv(diag(lambda_current))))';
            
            %dla ka�dej klasy
            res = cells(obj.R, 1);
            for iKlasa = 1:obj.R
                %dla ka�dej stacji
                fix_stacje = zeros(obj.N, 1);
                for jStacja = 1:obj.N
                        if (obj.stations_types(jStacja) == 1 && obj.stations_m(jStacja) == 1) || obj.stations_types(jStacja) == 2 || obj.stations_types(jStacja) == 4
                             licznik = obj.visitRatios{iKlasa}(jStacja)/obj.stations_mi{iKlasa}(jStacja);
                             mianownik = 1-()*obj.rho
                             fix_stacje(jStacja)
                        elseif obj.stations_types(jStacja) == 1 && obj.stations_m(jStacja) > 1
                            
                        elseif obj.stations_types(jStacja) == 3
                            fix_stacje(jStacja) = obj.visitRatios{iKlasa}.*obj.stations_LambdaInversed;
                        end
                end
                res{iKlasa} = fix_stacje;
            end
        end
        
        function res = p_mi(obj, lambda_current)
            firsPart = '';
            factorial
        end
        
        function res = rho(obj, iStacja, lambda)
            res = lambda/(obj.stations_m(iStacja)*obj.stations_Mi(iStacja));
        end
    end
    
    %% Open network:
    methods ( Access = private )    
        %Wypadkowy wsp�czynnik przychodzenia zgloszen do danych stacji:
        function lambda_final = calculateLambdas_open(obj)
            obj.stations_lambda = {};
            for i = 1:obj.R
                obj.stations_lambda{i} = obj.stations_visitRatio{i} * obj.lambda_in{i};
            end
            lambda_final = obj.stations_lambda;
        end
    end
    
end

