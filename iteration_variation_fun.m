function Density = iteration_variation_fun(Density,iteration_number,...
    delay,Partition_Number,Agent_Positions,r_o)
% This function will run through your Density matrix every
% iteration. Since the Density matrix is discretized depending on the
% Partition Number chosen, the (x,y) values of the (i,j) entry of the
% Density matrix are: x = i/Partition_Number, and y = j/Partition_Number.
% Hence, to change a density value at position (x,y) we calculate first the
% (x,y) position as above, then change the Density value according to some
% function which takes in position and iteration number, for example;
% Density(x,y,iteration_number) = (x+iteration_number)^2 +
% (y-iteration_number)^2. Keep in mind that the density must always be
% greater than or equal to 0. If you want the density only to change after
% a certain number of iterations (you may want to for example change the
% density every 5 iterations), then this number is the delay value, and
% this function will only change the density if delay divides the iteration
% number.
% NOTE 1: Another idea for using variable density is to change the density
% if, when the agents pass over some area, they lower the density (this
% highly depends on your application). To do this, you would have to use
% the current positions of the agents, stored in Agent_Positions, 
% which is an n x 2 matrix with the indices of the agents as rows,
% x-position for the first column, and y-position for the second column. 
% NOTE 2: Density is being constantly updated every iteration, therefore
% the value of Density at iteration k is Density(x,y,k), in this function
% you would want to generate Density(x,y,k+1).

change = mod(iteration_number,delay); %Checks if iteration_number divides delay.
if change == 0
    for i = 1:size(Density,1)
        for j = 1:size(Density,1)
            x = i/Partition_Number;
            y = j/Partition_Number;
            %%%%% This is where you put your custom function!%%%%
            t = int8(5);
            %% Internal Density change due to agents
            for k = 1:size(Agent_Positions,1)
                if (Agent_Positions(k,1) == x && Agent_Positions(k,2) == y)
                    x = abs(cast(x, 'like', t))
                    y = abs(cast(y, 'like', t))
                    %disp(iteration_number);
                    if (Density(x,y) > 18.1)% (Density(x,y,iteration_number) >3)
                        Density(x,y) = Density(x,y)-18.1;%Density(x,y,iteration_number+1) = Density(x,y,iteration_number)-3;
                    elseif(Density(x,y) >0)%(Density(x,y,iteration_number) > 0)
                        Density(x,y) = 0 ;%Density(x,y,iteration_number+1) = 0;
                    end
                end
            end
            %% External Density change due to nature (example)
            %{
            if i > 1
                Density(i,j) = Density(i-1,j);
            elseif i == 1
                Density(i,j) = 0;
            end
            %}
        end
    end
end