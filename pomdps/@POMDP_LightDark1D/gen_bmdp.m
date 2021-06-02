function [b, r] = gen_bmdp(obj, b, a)

%% particle filter
s_km1 = b.s;
w_km1 = b.w;
s_k=s_km1;
w_k=w_km1;

%update
for i=1:length(w_k)
    s_k(i) = s_km1(i) + a;
    o_sigma = abs(s_k(i) - obj.ll_)+1e-6;
    o_k = s_k(i) + o_sigma*randn;
    w_k(i) = w_km1(i)*normpdf(s_k(i) - o_k, 0, o_sigma);
    if(isnan(w_k(i)))
        i
    end
end

%normalize
w_k = w_k./sum(w_k);

%resample
s_resampled=s_k;
w_resampled=w_k;
for i=1:length(w_k)
    idx = find(rand <= cumsum(w_k), 1);
    s_resampled(idx) = s_k(idx);
    w_resampled(idx) = 1/length(w_k);
end

b.s=s_resampled;
b.w=w_resampled;

%% reward
r=0;
for i=1:length(b.w)
    if(a==0)
        if(s_km1(i)==0)
            r = r + b.w(i)*100;
        else
            r = r + b.w(i)*-100;
        end
    else
        r = r + b.w(i)*-1;
    end
end

end

