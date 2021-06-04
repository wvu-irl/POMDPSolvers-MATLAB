function [s] = sample(obj, b)

idx = find(rand <= cumsum(b.w), 1);
s = b(idx).s;

end

