function [p_o_given_s_and_xi] = query_observation_likelihood_given_partition(obj, s, o, xi)

o_sigma = abs(s - obj.ll_) + 1e-4;
p_o_given_s_and_xi = normpdf(s-o, 0, o_sigma);

end

