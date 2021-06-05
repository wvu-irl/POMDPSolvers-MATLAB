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
    methods (Abstract)
        %Must define these methods in inherited class
        s = gen_s(obj, s, a);
        o = gen_o(obj, s, a, sp);
        r = gen_r(obj, s, a, sp);
        
        p_o_given_s =  query_observation_likelihood(obj, s, a, sp);
        
        sp_actual = gen_s_wout_noise(obj, s_actual, a_actual);
        o_actual = gen_o_wout_noise(obj, s_actual, a_actual, sp_actual);

        %Must override the below methods depending on if the actions are
        %dependent on the states or the beliefs
        %belief dependent actions
%         a = next_action_bmdp(b);
%         A = get_all_actions_b(b);
%         a = rollout_policy_b(b);

        %state dependent actions
%         a = next_action_pomdp(s);
%         A = get_all_actions_s(s);
%         a = rollout_policy_s(s);

        %Not required by solver, but used to simulating the policy
        %for analyzing the policy via simulations


    end
    
end