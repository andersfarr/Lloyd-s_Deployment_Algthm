function [ agentPositions, distance_travelled, E ] = move_agents( agentPositions, centroids, distance_travelled, Velocity_Type, velocity,max_velocity,MOVEMENTSCALE,algorithm_type,E )
% Moves each agent towards its assigned centroid.
% 
% Centroids is a nx2 matrix, where (i,1) and (i,2) represent the ith
% agent's centroid's x and y value, respectively.
% agentPositions is nx2 matrix, where (i,1) and (i,2) is the ith's 
% agent's x and y position, respectively.
% 
% MOVEMENTSCALE must be greater than 0 and should be less than 2. It is
% the fraction of the distance that an agent will travel in the x and y
% direction. For example, if it is 1 then the agent will move to its 
% desired point in one iteration. If it is 0.5 the agent will be halfway 
% there. 

% Velocity is the constant velocity at which the user wishes the agent to
% travel. 

% Using a MOVEMENTSCALE of around 1.8 will usually cause the algorithm to 
% converge the fastest, but for the purposes of this project having a 
% MOVEMENTSCALE greater than 1 may be unrealistic. 
%
% E: energy content of agents in percentage

%% Used for Energy example
% The energy will be decreased using the energy after one iteration being
% E_(i+1) = E_i - (1/2)*m*v^2
m = 0.5; % Physical mass of agents
time_unit = 30; %30 seconds per iteration
space_unit = 0.1; % 10 cm per space unit
energy_of_agents = 19940; % Total energy in Joules of a 9V battery

n = size(agentPositions,1); % Find number of agents
total_distance = distance_travelled(end); % Track the sum of the total distance travelled by each of the robots

for i = 1 : n
    if (i<(n/2))
        agent_blowerX = 0;
        agent_blowerY = (2*i)/n; % Make sure you re-edit this with real value
    else
        agent_blowerX = 1;
        agent_blowerY = (2*i)/n - n/2+4; % Make sure you re-edit this with real value
    end
    direction = [centroids(i,1) - agentPositions(i,1), centroids(i,2) - agentPositions(i,2)];
    [delta_x, delta_y] = velocity_fun(Velocity_Type,direction,velocity,max_velocity,MOVEMENTSCALE,algorithm_type, agentPositions, i, agent_blowerX, agent_blowerY);
    total_distance = total_distance + sqrt(delta_x^2 + delta_y^2);
    agentPositions(i,1) = agentPositions(i,1) + delta_x;
    agentPositions(i,2) = agentPositions(i,2) + delta_y;
    while(18.96 < sqrt((agentPositions(i,1) - agent_blowerX)^2+(agentPositions(i,2) - agent_blowerY)^2))
        agentPositions(i,1) = agentPositions(i,1) - 9*((agentPositions(i,1) - agent_blowerX))/10;
        agentPositions(i,2) = agentPositions(i,2) - 9*((agentPositions(i,2) - agent_blowerY))/10;
    end
    if (agentPositions(i,1) < 0)
        agentPositions(i,1) = -1*agentPositions(i,1);
    end
    if (agentPositions(i,2) < 0)
        agentPositions(i,2) = -1*agentPositions(i,2);
    end
    E(i) = E(i) - ((1/2)*m*(delta_x^2+delta_y^2)*(1/time_unit^2)*space_unit)/energy_of_agents; % Decreasing energy of agents after they move
end
distance_travelled = horzcat(distance_travelled, total_distance);
end