classdef CSO<handle
    properties (Access = public)    
        population_size = 0;
        visual = 0;
        population = [];
        population_values = [];
        pg = [];
        network;
        utility_function;
        par1;
        par2;
        step_no = 0;
        l = 1;
    end
    
    methods (Access = public)
        function obj = CSO(network, functionT, C1, C2, initial_stations_m, population_size, visual)
            obj.pg = initial_stations_m;
            obj.population = randi(1000, size(initial_stations_m, 1), population_size);
%             disp(obj.population)
            obj.population_values = -inf*ones(1, size(obj.population, 2));
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
            obj.calculate_utility_values();
            display 'Initialized CSO!'
        end
        
%         function initialize_population(obj, 

        function best = step(obj)
           % perform swarm-chasing
           obj.swarm_chase();
           % perform dispersing
           obj.disperse();           
           % perform ruthless behaviour
           obj.ruthless_behaviour();
           
           obj.step_no = obj.step_no + 1;
           obj.calculate_utility_values();
%            disp(obj.population)
%            disp(obj.find_pg())
           best = obj.current_pg_value();
        end
        
        function pg = current_pg_value(obj)
            pg = obj.utility_function(obj.find_pg());
        end
        
        function best_network = get_best_network(obj)
            obj.network.stations_m = obj.find_pg();
            obj.network.calculateLambdas();
            best_network = obj.network;
        end
    end
    
    methods (Access = private)
        function pi_index = find_pi_index(obj, ci)
            swarm = inf*ones(1, size(obj.population, 2));
            for i = 1:size(obj.population, 2)
                dist = norm(obj.population(:, ci) - obj.population(:,i));
                if dist < obj.visual
                    swarm(i) = obj.population_values(i);
                end
            end
%             disp(swarm)
            [~, indices] = sort(swarm, 'ascend');
            pi_index = indices(1);
        end
        
        function pg_index = find_pg_index(obj)
            swarm = inf*ones(1, size(obj.population, 2));
            for i = 1:size(obj.population, 2)
                swarm(i) = obj.population_values(i);
            end
%             disp(swarm)
            [~, indices] = sort(swarm, 'ascend');
            pg_index = indices(1);
        end
        
        function pg = find_pg(obj)
            pg = obj.population(:,obj.find_pg_index());
        end
        
        function swarm_chase(obj)
            new_population = obj.population;
            pg_index = obj.find_pg_index();
            for i=1:size(obj.population, 2)
%               strcat( 'Moving cockroach no: ', num2str(i), ' -> ')
                pi_index = obj.find_pi_index(i);
                if pi_index == i
                    new_cockroach = round(obj.population(:,i) + obj.l * rand() * (obj.population(:,pg_index) - obj.population(:,i)));
                else 
                    new_cockroach = round(obj.population(:,i) + obj.l * rand() * (obj.population(:,pg_index) - obj.population(:,i)));
                end
                new_population(:,i) = new_cockroach;
            end
%             display [old, new]
%             [obj.population, new_population]
            obj.population = new_population;
        end
        
        function calculate_utility_values(obj)
            for i=1:size(obj.population, 2)
                obj.population_values(i) = obj.utility_function(obj.population(:,i));
            end
%             display 'New utility values'
%             obj.population_values
        end
        
        function disperse(obj)
            if mod(obj.step_no, 5) ~= 0
                return
            end
            for i=1:size(obj.population, 2)
                obj.population(:,i) = round(obj.population(:,i) + randi(2, size(obj.population, 1), 1) - 1);
            end
        end
        
        function ruthless_behaviour(obj)
            if mod(obj.step_no, 10) ~= 0
                return
            end
            disp('RUTHLESS COCKROACH');
            ci = randi(size(obj.population, 2));
            obj.population(:, ci) = obj.find_pg();
        end
        

    end
    
    %% funkcja celu
    methods ( Access = public )

        function r = utilityFunction1(obj, stations_m)
            if min(stations_m) < 0
                r = abs(min(stations_m) * 10000);
                return
            end
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


