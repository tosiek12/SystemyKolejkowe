classdef Network_nClass<handle
    properties ( Access = public )
        stations_lambda,
        stations_visitRatio,
        
        stations_types,
        stations_Mi,
        stations_m,
        
        P,
        
        P_out,
        
        P_in,
        lambda_in
    end
    properties ( Access = private )
        % Wartosc przydatna do obliczania rho w sieci zamknietej:
        stations_LambdaInversed,
        
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
                stations_visitRatio = {};
                obj.P_out = {};
                obj.stations_Mi = {};
            else
                error('Must be 4 arguments!')
            end
        end
    end
    
    %% Common functions:
    methods ( Access = public )
        function lambda_final = calculateLambdas(obj)
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
        %Step1: Compute visit ratios:
        function v = visitRatios(obj)
            for i = 1:size(obj.P, 2)
                %Obliczenia:
                A = eye(obj.N) - obj.P{i}';
                obj.stations_visitRatio{i} = lsqlin(A, obj.P_in{i});
            end
            v = obj.stations_visitRatio;
        end
        %Step2:Fixed Point Iteration:
        function lambda_final = calculateLambdas_close(obj)
            obj.visitRatios()
            obj.stations_lambda = diag(inv(diag(obj.stations_lambda)))';
            
            %Init lambda:
            lambda_current = {};
            for i = 1:obj.R
                lambda_current{i} = ones(obj.N, 1).*10^-5;
            end
            
            lambda_final = obj.stations_visitRatio;
            %lambda_final = obj.stations_lambda;
        end
        
        function res = fix(obj, lambda_current)
            %visitRatio.*1/wartosciMi
            res = {};
            
            for j = 1:obj.N
                for i = 1:obj.R
                    perStacja = [];
                        if obj.stations_types(j) == 1
                            
                        elseif obj.stations_types(j) == 2
                            
                        elseif obj.stations_types(j) == 3
                        
                        elseif obj.stations_types(j) == 4
                            perStacja(j) = obj.visitRatios{iKlasa}.*obj.stations_LambdaInversed;
                        end
                    res{i} = perStacja;
                end
            end
        end
    end
    
    %% Open network:
    methods ( Access = private )    
        %Wypadkowy wspó³czynnik przychodzenia zgloszen do danych stacji:
        function lambda_final = calculateLambdas_open(obj)
            obj.stations_lambda = {};
            for i = 1:size(obj.P, 2)
                %Obliczenia:
                A = eye(obj.N) - obj.P{i}';
                obj.stations_lambda{i} = lsqlin(A, obj.P_in{i} * obj.lambda_in{i});
            end
            lambda_final = obj.stations_lambda;
        end
    end
    
end

