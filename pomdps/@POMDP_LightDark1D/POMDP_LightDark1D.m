% Author: Jared Strader
%
% Description: This POMDP model was created based on [1], and the 
% parameters where the code provided in [2] was used as an additional 
% reference.
%
% [1] Sunberg, Z. N., & Kochenderfer, M. J. (2018). Online algorithms for 
%     POMDPs with continuous state, action, and observation spaces. 
%     Proceedings International Conference on Automated Planning and 
%     Scheduling, ICAPS, 2018-June(Icaps), 259–263.
%
% [2] https://github.com/zsunberg/ContinuousPOMDPTreeSearchExperiments.jl/
%     blob/master/src/simple_lightdark.jl

classdef POMDP_LightDark1D < POMDP
    properties
        A_=[-10,-1,0,1,10]; %action space
        ll_ = 10; %light location
        r_ = [];
    end
    
     %% Public
    methods (Access = public)
        % Constructor
        function obj = POMDP_LightDark1D(params, radius)   
            obj@POMDP(params);
            obj.r_ = radius;
        end
    end
end