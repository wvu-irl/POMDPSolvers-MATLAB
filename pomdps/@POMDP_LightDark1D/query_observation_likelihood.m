function [p_o_given_s] = query_observation_likelihood(obj, s, o)

o_sigma = abs(s - obj.ll_) + 1e-4;
p_o_given_s = normpdf(s-o, 0, o_sigma);

end

