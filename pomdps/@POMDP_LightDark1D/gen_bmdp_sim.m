function [b, s_actual, o_actual, r_actual] = gen_bmdp_sim(obj, b, a, s_actual)

%% actual state and observation
s_actual = s_actual + a;
o_sigma_actual = obj.get_obs_sig(s_actual);
o_actual = s_actual + o_sigma_actual*randn ;

%% particle filter
s_km1 = b.s;
w_km1 = b.w;
s_k=[];
w_k=[];

%update
for i=1:length(w_km1)
    s_k(i) = s_km1(i) + a;
    o_sigma = obj.get_obs_sig(s_k(i));
    res = s_k(i) - o_actual;
    pdf_o_given_s = normpdf(res, 0, o_sigma);
    w_k(i) = w_km1(i)*pdf_o_given_s;
end

%normalize
w_k_norm = w_k./sum(w_k);

%resample
if(1/sum(w_k_norm.^2) < 0.2*length(w_k_norm))
    s_resampled=[];
    w_resampled=[];
    for i=1:length(w_k_norm)
        idx = find(rand <= cumsum(w_k_norm), 1); %equivalent to randsample(1:length(w), 1, true, w)
        s_resampled(i) = s_k(idx);
        w_resampled(i) = 1/length(w_k_norm);
    end
    b.s = s_resampled;
    b.w = w_resampled;
else
    b.s = s_k;
    b.w = w_k_norm;
end

%% reward
if(a==0)
    if(s_actual==0)
        r_actual = 100;
    else
        r_actual = -100;
    end
else
    r_actual = -1;
end

end

