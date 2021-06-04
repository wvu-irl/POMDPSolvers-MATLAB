function [obs_sig] = get_obs_sig(obj, s)

obs_sig = abs(s - obj.ll_) + 1e-6;

end

