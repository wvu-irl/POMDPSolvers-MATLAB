function [ret_val] = is_terminal(obj, s)

if(s < -obj.r_ || s > obj.r_)
    ret_val = true;
else
    ret_val = false;
end

end

