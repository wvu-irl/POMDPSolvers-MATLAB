function [total] = rollout(obj, s, b, d)

%terminate if depth exceeded
if(d==0)
    %TODO(jared): assign reward for depth exceeded
    total=0;
    return;
end

%user-defined terminal conditions
%NOTE(jared): necessary for terminating simulation before depth is 
%             exceeded and assigning reward for such scenarios
% is_term = obj.pomdp_.is_terminal(s);
% if(is_term)
%     %TODO(jared): assign reward for terminal condition
%     total=0;
%     return;
% end

%user-defined heuristic
a = obj.pomdp_.rollout_policy_s(s);
% a = obj.pomdp_.rollout_policy_b(b);

%propagate belief
% [bp, ~] = obj.pomdp_.gen_br_pf(b, a);

%propagate state and get reward
sp = obj.pomdp_.gen_s(s, a);
r = obj.pomdp_.gen_r(s, a, sp);

%total reward
total = r + obj.gamma_*obj.rollout(sp, [], d-1);
% total = r + obj.gamma_*obj.rollout(sp, bp, d-1);

end

