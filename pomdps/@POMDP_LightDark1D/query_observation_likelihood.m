function [p] = query_observation_likelihood(obj, s, o)

o_sigma = abs(s - obj.ll_) + 1e-6;
p = normpdf(s-o, 0, o_sigma); %probability o given s

end

