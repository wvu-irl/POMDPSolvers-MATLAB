classdef POMDP < handle
    properties
        is_act_cont_; %bool, true if action space is continuous
        is_obs_cont_; %bool, true if observation space is continuous
    end
    
     %% Public
    methods (Access = public)
        % Constructor
        function obj = POMDP(params)
             obj.is_act_cont_ = params.is_act_cont;
             obj.is_obs_cont_ = params.is_obs_cont;
        end

    end
    
    %% Private
    %NOTE(jared): must define the below methods used in the solver
    methods (Abstract)
        s = gen_s(obj,s,a);
        o = gen_o(obj,s,a,sp);
        r = gen_r(obj,s,a,sp);
        
        p =  query_observation_likelihood(obj,s,a,sp);
        
        %methods for belief mdp
%         a = next_action_bmdp(b);
%         A = get_all_actions_bmdp(b);
%         [b,r] = gen_bmdp(b,a); %belief mdp, generative model
%         a = rollout_policy(b);

        %methods for pomdp
%         a = next_action_pomdp(s);
%         A = get_all_actions_pomdp(s);
%         [s,o,r] = gen_pomdp(s,a); %pomdp, generative model
%         a = rollout_policy(s);

    end
    
end