function [o] = gen_o(obj, s, a, sp)

o_sigma = abs(sp - obj.ll_) + 1e-4;
o = sp + o_sigma*randn;

end

