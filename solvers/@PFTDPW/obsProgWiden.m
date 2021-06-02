function [idx] = obsProgWiden(obj, v_ba)

idx=[];
if(obj.pomdp_.is_obs_cont_)
    %expand observation using progressive widening
    if(length(v_ba.c) <= obj.k_o_*v_ba.n^obj.alpha_o_)
        %NOTE(jared): The generative model for a belief mdp return a
        %             belief and reward in contrast to a state, 
        %             observation, and reward. 
        [b,r] = obj.pomdp_.gen_bmdp(v_ba.b, v_ba.a);

        %add vertex to tree
        vnew.i = length(obj.T_) + 1;
        vnew.p = v_ba.i;
        vnew.b = b;
        vnew.r = r;
        vnew.c = [];
        vnew.n = 0;
        vnew.a = [];
        vnew.q = 0;
%         v.o = [];
        obj.T_ = [obj.T_ vnew];

        %add child to parent
        obj.T_(vnew.p).c = [obj.T_(vnew.p).c vnew.i];
        
        %index of added vertex
        idx = vnew.i;
    else
        %sample uniformaly from children
        %NOTE(jared): why not sample propertional to observation
        %             likelihood?
        idx = v_ba.c(randi([1,length(v_ba.c)]));
    end
else
    %expand all possible observations
    if(isempty(v_ba.c))
        O = obj.pomdp_.get_all_observations(v_ba.b);
        
        for i=1:length(O)
            o = O(i);
            [b,r] = obj.pomdp_.gen_bmdp(v_ba.b, v_ba.a, o);
            
            %add vertex to tree
            vnew.i = length(obj.T_) + 1;
            vnew.p = v_ba.i;
            vnew.b = b;
            vnew.r = r;
            vnew.c = [];
            vnew.n = 0;
            vnew.a = a;
            vnew.q = 0;
%             v.o = [];
            obj.T_ = [obj.T_ vnew];

            %add child to parent
            obj.T_(vnew.p).c = [obj.T_(vnew.p).c vnew.i];
        end
    end
    
    %sample uniformaly from children
    %NOTE(jared): same as above. why not sample propertional to 
    %             observation likelihood?
    idx = v_ba.c(randi([1,length(v_ba.c)]));
end

if(isempty(idx))
    error('Error! No action selected in obsProgWiden');
end

end

