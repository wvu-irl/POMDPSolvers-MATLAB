classdef POMDP_LightDark1D < POMDP
    properties
        A_=[-10,-1,0,1,10]; %action space
        ll_ = 10; %light location
    end
    
     %% Public
    methods (Access = public)
        % Constructor
        function obj = POMDP_LightDark1D(params)   
            obj@POMDP(params);
        end
    end
end