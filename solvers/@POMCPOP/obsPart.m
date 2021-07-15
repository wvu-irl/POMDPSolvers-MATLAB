function [idx, do_rollout] = obsPart(obj, s, v_ba)

%generative model
sp = obj.pomdp_.gen_s(s, v_ba.a);
xi = obj.pomdp_.gen_xi(s, v_ba.a, sp);
o = obj.pomdp_.gen_o_given_xi(s, v_ba.a, sp, xi);
r = obj.pomdp_.gen_r(s, v_ba.a, sp);
    
%expand all possible partitions
% idx=[];
% do_rollout=false;
% n_added=0;%only for debugging
% if(isempty(v_ba.c))
%     Xi = obj.pomdp_.get_all_partitions_s(s);
% 
%     for i=1:length(Xi)
%         tempxi = Xi(:,i);
% 
%         %add vertex to tree
%         vnew.i = length(obj.T_) + 1;
%         vnew.p = v_ba.i;
%         vnew.b.s = [];
%         vnew.b.w = [];
%         vnew.r = r;
%         vnew.c = [];
%         vnew.n = 0;
%         vnew.a = [];
%         vnew.xi = tempxi;
%         vnew.q = 0;
%         obj.T_ = [obj.T_ vnew];
% 
%         %add child to parent
%         obj.T_(vnew.p).c = [obj.T_(vnew.p).c vnew.i];
% 
%         n_added=n_added+1;%only for debugging
%     end
%     
%     idx = obj.T_(v_ba.i).c(xi);
% else
%     idx = v_ba.c(randi([1,length(v_ba.c)]));
% end
% 
% if(obj.debug_)
%     disp(['obsPart: n_added = ', num2str(n_added)]);
% end
% 
% if(isempty(obj.T_(idx).c))
%     do_rollout=true;
% end

%check if partition previously generated
does_partition_exist=false;
idx_partition = -1;
for i=1:length(v_ba.c)
    if(obj.T_(v_ba.c(i)).xi == xi)
        does_partition_exist=true;
        idx_partition = v_ba.c(i);
        break;
    end
end

%if partition exists, add particle to existing vertex in tree, if not,
%create new vertex in tree for partition
idx=[];
do_rollout=false;
if(~does_partition_exist)
    %check if more memory needs allocated for tree
    if(obj.T_size_ == length(obj.T_))
        alloc_size = length(obj.T_) + obj.iterations_;
        obj.T_(alloc_size).i=[];
        obj.T_(alloc_size).p=[];
        obj.T_(alloc_size).b=[];
        obj.T_(alloc_size).r=[];
        obj.T_(alloc_size).c=[];
        obj.T_(alloc_size).n=[];
        obj.T_(alloc_size).a=[];
        obj.T_(alloc_size).xi=[];
        obj.T_(alloc_size).q=[];
    end
    
    %add vertex to tree
    vnew.i = obj.T_size_ + 1;
%     vnew.i = length(obj.T_) + 1;
    vnew.p = v_ba.i;
    vnew.b.s = [];
    vnew.b.w = [];
    vnew.r = r;
    vnew.c = [];
    vnew.n = 0;
    vnew.a = [];
    vnew.xi = xi;
    vnew.q = 0;
    obj.T_(vnew.i) = vnew;
    obj.T_size_ = obj.T_size_ + 1;
%     obj.T_ = [obj.T_ vnew];

    %add child to parent
    obj.T_(vnew.p).c = [obj.T_(vnew.p).c vnew.i];
    
    %index of added vertex
    idx = vnew.i;
    
    %do rollout when adding partition vertex to tree
    do_rollout=true;
else
    idx = idx_partition;
end

if(obj.debug_)
    disp(['obsPart: vertex added ']);
end

if(isempty(idx))
    error('Error! No observation selected in obsPart');
end

%append s' to belief
obj.T_(idx).b.s = [obj.T_(idx).b.s, sp];

%assign weight to particle
w = obj.pomdp_.query_observation_likelihood_given_partition(sp, o, xi);
obj.T_(idx).b.w = [obj.T_(idx).b.w, w];

end

