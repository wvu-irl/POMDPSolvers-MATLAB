function [total] = rollout(obj, b, d)

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
    is_term = obj.is_terminal_(b);
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
a = obj.pomdp_.rollout_policy_b(b);

%propagate belief
[bp,r] = obj.pomdp_.gen_br_pf(b, a);

%total reward
total = r + obj.gamma_*obj.rollout(bp, d-1);

end

