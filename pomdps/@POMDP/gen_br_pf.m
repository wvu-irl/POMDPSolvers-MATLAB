function [bp, r] = gen_br_pf(obj, b, a)

%% particle filter
s = b.s;
w = b.w;
sp=[];
wp=[];

%update
for i=1:length(w)
    sp(i) = obj.gen_s(s(i), a);
    o = obj.gen_o(s(i), a, sp(i));
    p_o_given_s = obj.query_observation_likelihood(sp(i), o);
    wp(i) = w(i)*p_o_given_s;
end

%normalize
wp_norm = wp./sum(wp);

%resample
%TODO: add effective number of particles as optional parameters
n_eff = 0.2;
if(1/sum(wp_norm.^2) < n_eff*length(wp_norm))
    s_resampled=[];
    w_resampled=[];
    for i=1:length(wp_norm)
        idx = find(rand <= cumsum(wp_norm), 1); %equivalent to randsample(1:length(w), 1, true, w)
        s_resampled(i) = sp(idx);
        w_resampled(i) = 1/length(wp_norm);
    end
    sp = s_resampled;
    wp = w_resampled;
else
    sp = sp;
    wp = wp_norm;
end

bp.s = sp;
bp.w = wp;

%% expected reward 
r=0;
for i=1:length(bp.w)
    r = r + bp.w(i)*obj.gen_r(b.s(i), a, bp.s(i));
end

end

