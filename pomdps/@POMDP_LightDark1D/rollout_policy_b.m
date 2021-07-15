function [a] = rollout_policy_b(obj, b)

%weighted mean of particles
s = b.s;
w = b.w;
mu=0;
for i=1:length(w)
    mu = mu + w(i)*s(i);
end
mu = round(mu/sum(w));

%heuristic for action selection (as in sunberg paper)
if(mu==obj.ll_)
    a = -1*sign(obj.ll_);
elseif(abs(mu-obj.ll_) >= 10)
    a = -10*sign(mu-obj.ll_);
else
    a = -sign(mu-obj.ll_);
end

%heuristic for action selection (modified)
% if(mu==obj.ll_)
%     a = -1*sign(obj.ll_);
% else
%     a = -sign(mu-obj.ll_);
% end

end