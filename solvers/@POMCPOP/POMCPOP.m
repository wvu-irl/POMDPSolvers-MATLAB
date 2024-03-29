classdef POMCPOP < POMDPSolver
    properties
        T_=[];
        T_size_=0;
        debug_=false;
        
        %% user-defined parameters (REQUIRED)
        %number of iterations of tree search
        iterations_=[];
        
        %maximum depth of tree search
        depth_max_=[];
        
        %discount factor
        gamma_=[];
        
        %parameter for exploration/exploration
        c_=[];
        
        %% ONLY REQUIRED FOR CONTINUOUS ACTIONS
        %action widening parameters
        k_a_=[];
        alpha_a_=[];
        
        %% optional
        %is_terminal_ is a function that takes a belief as input and
        %returns a bool, which identifies if the belief is terminal.
        is_terminal_=[];
    end
    
     %% Public
    methods (Access = public)
        % Constructor
        function obj = POMCPOP(pomdp, params)    
            obj@POMDPSolver(pomdp);
            obj.debug_ = params.debug;
            obj.iterations_ = params.iterations;
            obj.depth_max_ = params.depth_max;
            
            if(pomdp.is_act_cont_)
                obj.k_a_ = params.k_a;
                obj.alpha_a_ = params.alpha_a;
            end
            
            obj.gamma_ = params.gamma;
            obj.c_ = params.c;
        end
    end
    
    %% Private
    methods (Access = private)

    end
    
end