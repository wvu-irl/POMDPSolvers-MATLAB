function [a] = rollout_policy_pomdp(obj, s)

%heuristic for action selection
if(s==obj.ll_)
    a = -1*sign(obj.ll_);
elseif(abs(s-obj.ll_) >= 10)
    a = -10*sign(s-obj.ll_);
else
    a = -sign(s-obj.ll_);
end

end

