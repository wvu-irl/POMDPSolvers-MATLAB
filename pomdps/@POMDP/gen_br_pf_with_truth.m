function [bp, sp_actual, o_actual, r_actual] = gen_br_pf_with_truth(obj, b, a, s_actual)

%% actual state and observation
sp_actual = obj.gen_s_wout_noise(s_actual, a);
o_actual = obj.gen_o(s_actual, a, sp_actual);

%% particle filter
s = b.s;
w = b.w;
sp=[];
wp=[];

%update
for i=1:length(w)
    sp(i) = obj.gen_s(s(i), a);
    pdf_o_given_s = obj.query_observation_likelihood(sp(i), o_actual);
    wp(i) = w(i)*pdf_o_given_s;
end

%normalize
w_k_norm = wp./sum(wp);

%resample
%TODO: add effective number of particles as optional parameters
n_eff = 0.2;
if(1/sum(w_k_norm.^2) < n_eff*length(w_k_norm))
    s_resampled=[];
    w_resampled=[];
    for i=1:length(w_k_norm)
        idx = find(rand <= cumsum(w_k_norm), 1); %equivalent to randsample(1:length(w), 1, true, w)
        s_resampled(i) = sp(idx);
        w_resampled(i) = 1/length(w_k_norm);
    end
    sp = s_resampled;
    wp = w_resampled;
else
    sp = sp;
    wp = w_k_norm;
end

if(sum(wp) < 1 - 1e-6)
    error('gen_br_pf_with_truth: Weights are not normalized!');
end

bp.s = sp;
bp.w = wp;

%% reward
r_actual = obj.gen_r(s_actual, a, sp_actual);

end

