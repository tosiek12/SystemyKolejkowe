classdef Station_1Class
    %STATION Summary of this class goes here
    %   Detailed explanation goes here
    properties ( Access = public )
        Mi,
        m,
        lambda
    end
    properties ( Access = private )
        Id,
        Type
    end
    
    methods ( Access = private )
        %funkcje dla typ 1 - M/M/m/FIFO/inf
        function r = p0_1(obj)
            res_sum = 0;
            for i = 0:(obj.m-1)
                res_sum = res_sum + obj.p0_1_el(i);
            end
            r = inv(res_sum + power((obj.lambda/obj.Mi),obj.m)/(factorial(obj.m - 1)*(obj.m-obj.lambda/obj.Mi)));
        end
        function r = p0_1_el(obj, k)
            r = power(obj.lambda/obj.Mi, k)/factorial(k);
        end
        function r = p_1_upToM(obj, k) 
            r = obj.p0_1()*power(obj.lambda/obj.Mi, k)/factorial(k);
        end
        function r = p_1_overM(obj, k) 
            r = obj.p0_1()*power(obj.lambda/obj.Mi, k)/(factorial(obj.m)*power(obj.m,k-obj.m));
        end
        
        
        %funkcje dla typ 2
        
        %funkcje dla typ 3
        function r = p0_3(obj)
            r = e^-obj.rho;
        end
        %funkcje dla typ 4
        
    end
    methods ( Access = public )
        function obj = Station_1Class(id, type)
          if nargin >= 2
             if isnumeric(type) && isnumeric(id)
                obj.Type = type;
                obj.Id = id;
             else
                error('Value must be numeric')
             end
          end
        end
        
        function r = p(obj, k)
            if(obj.Type == 1)
                if(k>=0 && k<=obj.m-1)
                    r = obj.p_1_upToM(k);
                else 
                    r = obj.p_1_overM(k);
                end
            elseif(obj.Type == 2)
                r = 2*K;
            elseif(obj.Type == 3)
                r = obj.p0_3*(obj.rho^k)/factorial(k);
            elseif(obj.Type == 4)
                r = 2*K;
            end
        end
        function r = K(obj)
            if(obj.Type == 1)
                r = obj.rho + obj.p(0)*(power(obj.rho, obj.m+1))/((obj.m-obj.rho)^2*factorial(obj.m-1));
            elseif(obj.Type == 2)
                r = 0;
            elseif(obj.Type == 3)
                r = obj.rho;
            elseif(obj.Type == 4)
                r = 0;
            end
        end
        function r = Q(obj)
            if(obj.Type == 1)
                r = obj.K-obj.m0;
            elseif(obj.Type == 2)
                r = 0;
            elseif(obj.Type == 3)
                r = 0;
            elseif(obj.Type == 4)
                r = 0;
            end
        end
        function r = m0(obj)
            if(obj.Type == 1)
                r = obj.rho;
            elseif(obj.Type == 2)
                r = 0;
            elseif(obj.Type == 3)
                r = obj.K;
            elseif(obj.Type == 4)
                r = 0;
            end
        end
        
        %Regula littla:
        function r = W(obj)
           r = obj.Q/obj.lambda; 
        end
        function r = T(obj)
            r = obj.K/obj.lambda;
        end
        
        %Inne parametry:
        function rho = rho(obj)
           rho = obj.lambda/obj.Mi; 
        end
    end
    
end
