function [o] = gen_o(s,a,sp)

o_sigma = abs(sp - obj.ll_) + 1e-6;
o = sp + o_sigma*randn;

end

