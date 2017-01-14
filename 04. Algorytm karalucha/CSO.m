classdef CSO<handle
    properties (Access = public)    
        population_size = 0;
        visual = 0;
        population = [];
        pg = [];
        network;
        utility_function;
        par1;
        par2;
    end
    
    methods (Access = public)
        function obj = CSO(network, functionT, C1, C2, initial_stations_m, population_size, visual)
            obj.pg = initial_stations_m;
            obj.population = randi(100, size(initial_stations_m), population_size);
            obj.visual = visual;
            obj.network = network;
            obj.par1 = C1;
            obj.par2 = C2;
            
            if(strcmp(functionT, 'funkcja1') > 0)
                obj.utility_function = @obj.utilityFunction1;
            elseif (strcmp(functionT, 'funkcja2') > 0)
                obj.utility_function = @obj.utilityFunction2;
            else
                error('Utility function not defined.');
            end
        end
        
%         function initialize_population(obj, 

        function best = step(obj)
           % perform swarm-chasing
           
           % perform dispersing
           
           % perform ruthless behaviour
           
           best = obj.find_pg();
        end
        
        function pg = current_pg(obj)
            pg = obj.population(obj.find_pg());
        end
    end
    
    methods (Access = private)
        function pi_index = find_pi_index(obj, ci)
            swarm = -inf*ones(1, obj.population);
            for i = 1:size(obj.population)
                if i == ci 
                    continue
                end
                dist = norm(obj.population(ci,:) - obj.population(i,:));
                if dist < obj.visual
                    swarm(i) = obj.utility_function(obj.population(i,:));
                end
            end
            [~, indices] = sort(swarm, 'descend');
            pi_index = indices(1);
        end
        
        function pg_index = find_pg_index(obj)
            swarm = -inf*ones(1, obj.population);
            for i = 1:size(obj.population)
                swarm(i) = [obj.utility_function(obj.population(i,:)); i];
            end
            [~, indices] = sort(swarm, 'descend');
            pg_index = indices(1);
        end
        
        function pg = find_pg(obj)
            pg = obj.population(obj.find_pg_index());
        end
        
        function swarm_chase(obj)
            new_population = obj.population
            for i=1:size(obj.population, 2)
                
            end
        end
        
        function disperse(obj)
        end
        
        function ruthless_behaviour(obj)
        end
        
        function best_network = get_best_network(obj)
            obj.network.stations_m = find_pg();
            obj.network.calculateLambdas();
            best_network = obj.network;
        end
    end
    
    %% funkcja celu
    methods ( Access = public )

        function r = utilityFunction1(obj, stations_m)
            obj.network.stations_m = stations_m;
            obj.network.calculateLambdas();
            
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
        end


        function r = utilityFunction2(obj) 
            r = 2+rand(1)*5;
        end

    end
    % initialize swarm


    % find local best cockroach


    % find global best cockroach   
end


