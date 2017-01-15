
classdef Network_nClass<handle
    %% Fields:
    properties ( Access = public )
        N,
        R,
        
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
        
        %dla fixa:
        stations_lambda_current,
    end
    properties ( Access = private )        
        
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
                obj.stations_lambda = {};
                
                %Set initial values as table:
                obj.stations_lambda_current = [];
            else
                error('Must be 4 arguments!')
            end
        end
    end
    
    %% Common functions:
    methods ( Access = public )
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
            
            if strcmp(obj.Type,'open') > 0 
                
                station.lambda = obj.stations_lambda{iKlasa}(iStacja);
            else 
                station.lambda = obj.stations_lambda(iKlasa)*obj.stations_visitRatio{iKlasa}(iStacja);
            end
            
            %W wzorach dla stacji mamy lambda 
            %station.lambda = station.lambda * obj.stations_m(iStacja);
        end
        
        function r = isClosed(obj)
           r = strcmp(obj.Type,'close');
        end
    end
    methods ( Access = private )
        function v = visitRatios(obj)
            for i = 1:size(obj.P, 2)
				if strcmp(obj.Type,'open') > 0 
					A = eye(obj.N) - obj.P{i}';
					obj.stations_visitRatio{i} = lsqlin(A, obj.P_in{i});
                else 
                    %za³o¿enie: e1 = 1;
                    A_cale = eye(obj.N) - obj.P{i}';
                    A = A_cale(2:obj.N, 2:obj.N);   %Odetnij pierwszy wiersz i kolumne
                    out = (-1)*A_cale(2:obj.N, 1);   %pierwsza kolumna bez pierwszego wiersza
                    res = lsqlin(A, out);
					obj.stations_visitRatio{i} = [1; res];  %Doklej e1 = 1
				end
            end
            v = obj.stations_visitRatio;
        end
        function r = stations_lambda_vector(obj) 
            r = zeros(obj.R, 1);
            for i = 1:obj.R
                r(i) = obj.stations_lambda{i};
            end
        end
        function res = inversedValueOfVector(obj, vect)
           res =  diag((inv(diag(vect))));
        end
        
    end
    
    %% Podstawowe parametry
    methods ( Access = public)
        function r = p(obj, iKlasa, jStacja, k)
            if strcmp(obj.Type,'open') > 0 
                stacja = obj.getStation(iKlasa, jStacja);
                r = stacja.p(k);
            else
                r = obj.p_mi(iKlasa, jStacja);
            end
        end
        
        function r = K(obj, iKlasa, jStacja)
            
            if strcmp(obj.Type,'open') > 0 
                fc = @obj.Kir_open;
            else
                fc = @obj.Kir_close;
            end
            if strcmp(num2str(jStacja), '*')>0 
                for i = 1 : obj.N
                    r(i) = fc(iKlasa, i);
                end
            else
                r = fc(iKlasa, jStacja);
            end
        end
        
        function r = Q(obj, iKlasa, jStacja)
            if strcmp(num2str(jStacja), '*')>0 
                for i = 1 : obj.N
                    r(i) = obj.W(iKlasa, i) * obj.lambda(iKlasa, i);
                end
            else
                r = obj.W(iKlasa, jStacja) * obj.lambda(iKlasa, jStacja);
            end
        end
        
        function r = m0(obj, iKlasa, jStacja)
            if strcmp(num2str(jStacja), '*')>0 
                for i = 1 :obj.N
                   r(i) = obj.m0(iKlasa, i); 
                end
            else
                if strcmp(obj.Type,'open') > 0 
                    stacja = obj.getStation(iKlasa, jStacja);
                    r = stacja.m0();    %TODO: sprawdz, czy poprawne dla otwartych?
                else
                    t = obj.stations_types(jStacja);
                    if((t == 1 && obj.stations_m(jStacja) == 1) || t == 2 || t == 4 )
                        r = 0;
                    elseif(t == 3)
                        r = obj.lambda(iKlasa, jStacja)/obj.stations_Mi{iKlasa}(jStacja);
                    else
                        % t==1 && mj>1
                        r = obj.rho(iKlasa, jStacja)*obj.stations_m(jStacja);
                    end
                end
            end            
        end
        
        function r = m0_nowy(obj, iKlasa, jStacja)
            r = obj.K(iKlasa, jStacja)-obj.Q(iKlasa, jStacja);
        end
        
        function r = rho(obj, iKlasa, jStacja)
            if strcmp(obj.Type,'open') > 0 
                denominator_inversed = obj.inversedValueOfVector(obj.stations_Mi{iKlasa}.*obj.stations_m);
                rho_ir = obj.stations_lambda{iKlasa} .* (denominator_inversed);                
            else
                denominator_inversed = obj.inversedValueOfVector(obj.stations_Mi{iKlasa}.*obj.stations_m);
                rho_ir = obj.stations_lambda{iKlasa} .* obj.visitRatios{iKlasa} .* (denominator_inversed);                
            end

            if strcmp(num2str(jStacja), '*')>0 
                r = transpose(rho_ir);
            else
                r = rho_ir(jStacja);
            end
        end
        
        function r = lambda(obj, iKlasa, jStacja)
            if strcmp(num2str(jStacja), '*')>0 
                if strcmp(obj.Type,'open') > 0 
                    r = transpose(obj.stations_lambda{iKlasa}); %already multiplied by visit ratio
                else
                    r = transpose(obj.stations_lambda{iKlasa}*obj.stations_visitRatio{iKlasa});
                end
            else
                if strcmp(obj.Type,'open') > 0 
                    r = obj.stations_lambda{iKlasa}(jStacja); %already multiplied by visit ratio
                else
                    r = obj.stations_lambda{iKlasa}*obj.stations_visitRatio{iKlasa}(jStacja);
                end
            end
        end
        
        function r = W(obj, iKlasa, iStacja)
           r = obj.T(iKlasa, iStacja)-1/obj.stations_Mi{iKlasa}(iStacja); 
        end
        
        function r = T(obj, iKlasa, iStacja)
            if obj.lambda(iKlasa, iStacja) == 0 
                r = 0;
            else
                r = obj.K(iKlasa, iStacja)/obj.lambda(iKlasa, iStacja);
            end
        end
        
        function r = m(obj, jStacja)
            if strcmp(num2str(jStacja), '*')>0 
                r = transpose(obj.stations_m);
            else
                r = obj.stations_m(jStacja);
            end
            
        end
        
    end
    
    %% Closed network:
    methods ( Access = private )      
        
        %Fixed Point Iteration:
        function lambda_final = calculateLambdas_close(obj)
            %Init lambda:
            lambda_current = ones(obj.R, 1).*10^-5;
            %Do fix magic
            i = 1;
            delta = 1;
            while i<100 && delta>10^-5
                lambda_prev = lambda_current;
                res = obj.fix(lambda_current);
                for iKlasa = 1:obj.R
                    lambda_current(iKlasa) = obj.K_initial{iKlasa}/sum(res{iKlasa});
                end
                delta = sqrt(sum((lambda_prev - lambda_current).*(lambda_prev - lambda_current)));
                
                %disp([i, lambda_current, delta]);
                
                i = i + 1;
            end
            
            %assign result:
            for i = 1:obj.R
                obj.stations_lambda{i} = lambda_current(i);
            end
            lambda_final = lambda_current;
        end
        
        function res = fix(obj, lambda_current)
            %dla ka¿dej klasy
            res = cell(obj.R, 1);
            for iKlasa = 1:obj.R
                %dla ka¿dej stacji
                fix_stacje = zeros(obj.N, 1);
                for jStacja = 1:obj.N
                        if (obj.stations_types(jStacja) == 1 && obj.stations_m(jStacja) == 1) || obj.stations_types(jStacja) == 2 || obj.stations_types(jStacja) == 4
                             licznik = obj.visitRatios{iKlasa}(jStacja)/obj.stations_Mi{iKlasa}(jStacja);
                             mianownik = 1-((obj.K_total-1)/obj.K_total)*obj.rhoInternal(jStacja, lambda_current);
                             fix_stacje(jStacja) = licznik/mianownik;
                        elseif obj.stations_types(jStacja) == 1 && obj.stations_m(jStacja) > 1
                            m0 = obj.visitRatios{iKlasa}(jStacja)/obj.stations_Mi{iKlasa}(jStacja);
                            
                            licznik = obj.visitRatios{iKlasa}(jStacja)/(obj.stations_Mi{iKlasa}(jStacja)*obj.stations_m(jStacja));
                            mianownik = 1-((obj.K_total-obj.stations_m(jStacja)-1)/(obj.K_total-obj.stations_m(jStacja)))*obj.rhoInternal(jStacja, lambda_current);
                            fix_stacje(jStacja) = m0 + licznik/mianownik*obj.p_mi(jStacja, lambda_current);
                            
                        elseif obj.stations_types(jStacja) == 3
                            
                            fix_stacje(jStacja) = obj.visitRatios{iKlasa}(jStacja)./obj.stations_Mi{iKlasa}(jStacja);
                        end
                end
                res{iKlasa} = fix_stacje;
            end
        end
        
        function res = Kir_close(obj, iKlasa, jStacja)
            %dla ka¿dej klasy
            lambda_ir = obj.lambda(iKlasa, jStacja);
            rho_i = 0;
            for i = 1:obj.R
                rho_i = rho_i + obj.rho(i, jStacja);
            end
            rho_ir = lambda_ir/obj.stations_Mi{iKlasa}(jStacja);
            
            if (obj.stations_types(jStacja) == 1 && obj.stations_m(jStacja) == 1) || obj.stations_types(jStacja) == 2 || obj.stations_types(jStacja) == 4
                 licznik = rho_ir;
                 mianownik = 1-((obj.K_total-1)/obj.K_total)*rho_i;
                 res = licznik/mianownik;
            elseif obj.stations_types(jStacja) == 1 && obj.stations_m(jStacja) > 1
                m0 = obj.stations_m(jStacja)*rho_ir;

                licznik = rho_ir;
                mianownik = 1-((obj.K_total-obj.stations_m(jStacja)-1)/(obj.K_total-obj.stations_m(jStacja)))*rho_i;
                res = m0 + licznik/mianownik*obj.p_mi(jStacja, obj.stations_lambda_vector);

            elseif obj.stations_types(jStacja) == 3

                res = lambda_ir./obj.stations_Mi{iKlasa}(jStacja);
            end
        end
        
        function res = p_mi(obj, jStacja, lambda_current)
            rho_i = obj.rhoInternal(jStacja, lambda_current);
            m_i = obj.stations_m(jStacja);
            first = power(m_i*rho_i, m_i)/(factorial(m_i)*(1-rho_i));
            
            den_sum = 0;
            for k = 0:m_i-1
               den_sum = den_sum + power(m_i*rho_i, k)/factorial(k) + power(m_i*rho_i, m_i)/factorial(m_i)*(1/(1-rho_i));
            end
            
            res = first/den_sum;
        end
        
        function res = K_total(obj)
            res = 0;
            for iKlasa =1:obj.R
                res =  res + obj.K_initial{iKlasa};
            end
        end
        
        function res = rhoInternal(obj, jStacja, lambda_current)
            res = 0;
            for iKlasa = 1:obj.R
                denominator_inversed = obj.inversedValueOfVector(obj.stations_Mi{iKlasa}.*obj.stations_m);
                rho_ir = lambda_current(iKlasa) .* obj.visitRatios{iKlasa} .* (denominator_inversed);
                res = res + rho_ir(jStacja);
            end
        end
    end
    
    %% Open network:
    methods ( Access = private )    
        %Wypadkowy wspó³czynnik przychodzenia zgloszen do danych stacji:
        function r = calculateLambdas_open(obj)
            obj.stations_lambda = {};
            for i = 1:obj.R
                obj.stations_lambda{i} = obj.stations_visitRatio{i} * obj.lambda_in{i};
            end
            r = obj.stations_lambda;
        end
        
        function res = Kir_open(obj, iKlasa, jStacja)
            %dla ka¿dej klasy
            lambda_ir = obj.lambda(iKlasa, jStacja);
            rho_i = 0;
            for i = 1:obj.R
                rho_i = rho_i + obj.rho(i, jStacja);
            end
            
            if (obj.stations_types(jStacja) == 1 && obj.stations_m(jStacja) == 1) || obj.stations_types(jStacja) == 2 || obj.stations_types(jStacja) == 4
                 licznik = lambda_ir/obj.stations_Mi{iKlasa}(jStacja);
                 mianownik = 1-rho_i;
                 res = licznik/mianownik;
            elseif obj.stations_types(jStacja) == 1 && obj.stations_m(jStacja) > 1
                m0 = rho_i*obj.stations_m(jStacja);

                licznik = rho_i;
                mianownik = 1-obj.rhoInternal(jStacja, obj.stations_lambda);
                res = m0 + licznik/mianownik*obj.p_mi(jStacja, obj.stations_lambda);

            elseif obj.stations_types(jStacja) == 3

                res = lambda_ir./obj.stations_Mi{iKlasa}(jStacja);
            end
        end
        
    end
end

