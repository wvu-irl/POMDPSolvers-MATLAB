function [xi] = gen_xi(obj, s, a, sp)

%partitioning is arbitrary and user-defined, here partition the 
%observation space where s is at ll_, s is one off from ll_, and s is
%more than 1 off from ll_
d = abs(sp - obj.ll_);
if(d == 0)
    xi=1;
elseif(d == 1)
    xi=2;
elseif(d < 5)
    xi=3;
else
    xi=4;
end

end

