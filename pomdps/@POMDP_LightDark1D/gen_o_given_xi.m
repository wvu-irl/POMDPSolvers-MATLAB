function [o] = gen_o_given_xi(obj, s, a, sp, xi)

% if(xi==0)
% elseif(xi==1)
% else(xi==2)
% end

%in this case, the function generating the observation account for the
%different partitions. however, in different problems, the partition
%may need to be checked to generate the observation
o_sigma = abs(sp - obj.ll_) + 1e-6;
o = sp + o_sigma*randn;

end

