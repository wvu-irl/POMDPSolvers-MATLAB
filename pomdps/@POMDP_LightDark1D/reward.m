function [r] = reward(obj, s, a, sp)

if(a==0)
    if(s==0)
        r = 100;
    else
        r = -100;
    end
else
    r = -1;
end

end

