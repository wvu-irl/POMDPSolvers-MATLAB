function [total] = rollout(obj, s, d)

%terminate if depth exceeded
if(d==0)
    %TODO(jared): assign reward for depth exceeded
    total=0;
    return;
end

%user-defined terminal conditions
%NOTE(jared): necessary for terminating simulation before depth is 
%             exceeded and assigning reward for such scenarios
if(~isempty(obj.is_terminal_))
    is_term = obj.is_terminal_(s);
    if(is_term)
        %TODO(jared): assign reward for terminal condition
        total=0;
        return;
    end
else
    if(d>1e9)
        error('Error! Must define finite depth if terminal condition is not defined!');
    end
end

%user-defined heuristic
a = obj.pomdp_.rollout_policy_pomdp(s);

%propagate belief
[s,~,r] = obj.pomdp_.gen_pomdp(s, a);

%total reward
total = r + obj.gamma_*obj.rollout(s, d-1);

end

