classdef Network_nClass
    properties ( Access = public )
        N,
        R,
        
        lambdas,
        
        stations_types,
        stations_Mi,
        stations_m,
        stations_,
        
        P,
        P_in,
        P_out
    end
    properties ( Access = private )
        Id,
        Type
    end
    
    methods ( Access = private )
        
    end
    methods ( Access = public )
        function obj = Network_nClass(id, type)
          if nargin >= 2
             if isnumeric(id)
                obj.Type = type;
                obj.Id = id;
             else
                error('Value must be numeric')
             end
          end
        end
        
        %Step1: Compute visit ratios:
        function v = visitRatios(obj)
            v = {};
            for i = 1:obj.R
                v{i} = obj.P_in{1};
            end
        end
        
    end
    
end

