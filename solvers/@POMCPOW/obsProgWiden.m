function [idx, do_rollout] = obsProgWiden(obj, s, v_ba)

%generative model
[sp,o,r] = obj.pomdp_.gen_pomdp(s, v_ba.a);

%do progressive widening
idx=[];
do_rollout=false;
n_added=0; %only for debugging
if(obj.pomdp_.is_obs_cont_)
    %expand observation using progressive widening
    temp_n = length(v_ba.c);
    temp_nmax = obj.k_o_*v_ba.n^obj.alpha_o_;
    if(obj.debug_)
        disp(['obsProgWiden: if(',num2str(temp_n),' <= ',num2str(temp_nmax),')']);
    end
    if(temp_n <= temp_nmax)
        %add vertex to tree
        vnew.i = length(obj.T_) + 1;
        vnew.p = v_ba.i;
        vnew.b = [];
        vnew.r = r;
        vnew.c = [];
        vnew.n = 0;
        vnew.m = 1;
        vnew.a = [];
        vnew.o = o;
        vnew.q = 0;
        obj.T_ = [obj.T_ vnew];

        %add child to parent
        obj.T_(vnew.p).c = [obj.T_(vnew.p).c vnew.i];
        
        %index of added vertex
        idx = vnew.i;
        
        %do rollout when adding observation vertex to tree
        do_rollout=true;
        
        n_added=n_added+1;%only for debugging
    else
        %NOTE(jared): the psuedo code in the paper samples the observation
        %             proportional to the number of times the observation
        %             has been visited, but based on the code, the count
        %             is only incremented when adding a vertex, so the
        %             result is simply sampling the observation uniformly
        %             However, I am not sure if that is a mistake or
        %             intended. PFT-DPW samples uniformaly, so this seems
        %             intended and not a mistake. So, we sample uniformly.
        idx = v_ba.c(randi([1,length(v_ba.c)]));
    end
else
    %expand all possible observations
    %NOTE(jared): currently all observations are expanded here, but the
    %             rollouts are not handled. Likely, the simulate function
    %             will need to be modified to handle the rollout for
    %             the discrete observation case.
    error('Error! Need to update case for discrete observation to properly handle rollouts.');
    if(isempty(v_ba.c))
        O = obj.pomdp_.get_all_observations(v_ba.b);
        
        for i=1:length(O)
            o = O(i);
            
            %add vertex to tree
            vnew.i = length(obj.T_) + 1;
            vnew.p = v_ba.i;
            vnew.b = [];
            vnew.r = r;
            vnew.c = [];
            vnew.n = 0;
            vnew.m = 1;
            vnew.a = a;
            vnew.o = o;
            vnew.q = 0;
            obj.T_ = [obj.T_ vnew];

            %add child to parent
            obj.T_(vnew.p).c = [obj.T_(vnew.p).c vnew.i];
            
            n_added=n_added+1;%only for debugging
        end
    end
    
    %sample uniformaly from children
    %NOTE(jared): same as above. why not sample propertional to 
    %             observation likelihood?
    idx = v_ba.c(randi([1,length(v_ba.c)]));
end

if(obj.debug_)
    disp(['obsProgWiden: n_added = ', num2str(n_added)]);
end

if(isempty(idx))
    error('Error! No observation selected in obsProgWiden');
end

%append s' to belief
obj.T_(idx).b.s = [obj.T_(idx).b.s, sp];

%assign weight to particle
w = obj.pomdp_.query_observation_likelihood(sp);
obj.T_(idx).b.w = [obj.T_(idx).b.w, w];

end

