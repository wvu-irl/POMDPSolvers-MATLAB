function [b, r] = gen_bmdp(obj, b, a)

%% particle filter
s_km1 = b.s;
w_km1 = b.w;
s_k=[];
w_k=[];

%sample observation (do not delete/comment, used to make consistent rng)
rand_temp=rand;
randn_temp=randn;

%update (method 1 - sample observation for each particle)
for i=1:length(w_km1)
    s_k(i) = s_km1(i) + a;
    
    o_sigma = obj.get_obs_sig(s_k(i));
    o_sampled = s_k(i) + o_sigma*randn;
    
    res = s_k(i) - o_sampled;
    pdf_o_given_s = normpdf(res, 0, o_sigma);
    w_k(i) = w_km1(i)*pdf_o_given_s;
end

%update (method 2 - sample observation for entire particle set)
%NOTE(jared): This is experimental, method 1 is what was used in the
%             code from the paper
% temp_idx = find(rand_temp <= cumsum(w_km1), 1);
% s_sampled = s_km1(temp_idx) + a;
% sigma_sampled = obj.get_obs_sig(s_sampled);
% o_sampled = s_sampled + sigma_sampled*randn_temp;
% for i=1:length(w_km1)
%     s_k(i) = s_km1(i) + a;
%     res = s_k(i) - o_sampled;
%     pdf_o_given_s = normpdf(res, 0, sigma_sampled);
%     w_k(i) = w_km1(i)*pdf_o_given_s;
% end

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

