classdef POMDPSolver < handle
    properties
        pomdp_;
    end
    
     %% Public
    methods (Access = public)
        % Constructor
        function obj = POMDPSolver(pomdp)    
            obj.pomdp_ = pomdp;
        end

    end
end