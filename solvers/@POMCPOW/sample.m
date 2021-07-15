function [s] = sample(obj, b)

idx = find(rand <= cumsum(b.w), 1);
s = b.s(idx);

if(isempty(s))
    error('sample: s is empty');
end

end

