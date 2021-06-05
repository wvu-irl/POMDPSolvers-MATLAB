function [sp, o, r] = gen_pomdp(obj, s, a)

sp = s + a;

o_sigma = obj.get_obs_sig(sp);
o = sp + o_sigma*randn;

r = obj.reward(s,a,sp);

end

