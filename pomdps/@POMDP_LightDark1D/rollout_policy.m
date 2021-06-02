function [a] = rollout_policy(obj, b)

s = b.s;
w = b.w;

mu=0;
for i=1:length(w)
    mu = mu + w(i)*s(i);
end
mu = floor(mu/sum(w));

%heuristic copied from https://github.com/zsunberg/ContinuousPOMDPTreeSearchExperiments.jl/blob/master/src/simple_lightdark.jl
if(mu==obj.ll_)
    a = -1*sign(obj.ll_);
elseif(abs(mu-obj.ll_) >= 10)
    a = -10*sign(mu-obj.ll_);
else
    a = -sign(mu-obj.ll_);
end

end

