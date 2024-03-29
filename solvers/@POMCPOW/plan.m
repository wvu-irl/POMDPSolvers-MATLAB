function [a] = plan(obj, b)

%preallocate tree struct
alloc_size = obj.iterations_;
obj.T_=[];                   %ensure tree is empty
obj.T_(alloc_size).i=[];     %index of vertex
obj.T_(alloc_size).p=[];     %index of parent
obj.T_(alloc_size).b=[];     %belief
obj.T_(alloc_size).r=[];     %reward
obj.T_(alloc_size).c=[];     %children
obj.T_(alloc_size).n=[];     %number of times visited
obj.T_(alloc_size).m=[];     %number of times observation sampled
obj.T_(alloc_size).a=[];     %action (i.e., action taken to reach vertex)
obj.T_(alloc_size).o=[];     %observation value
obj.T_(alloc_size).q=[];     %state-action value

%root
obj.T_(1).i=1;
obj.T_(1).p=nan;
obj.T_(1).b=b;
obj.T_(1).r=0;
obj.T_(1).c=[];
obj.T_(1).n=0;
obj.T_(1).m=0;
obj.T_(1).a=[];
obj.T_(1).o=[];
obj.T_(1).q=0;
obj.T_size_ = 1;

%iteratively build tree
for i=1:obj.iterations_
%     disp(['Iteration ', num2str(i)]);
    s = obj.sample(obj.T_(1).b);
    obj.simulate(s, obj.T_(1), obj.depth_max_);
    if(obj.debug_)
        disp(['length(T_)=',num2str(length(obj.T_))]);
        disp(' ');
    end
end

%return argmax_a Q(ba)
a_max=[];
q_max=-inf;
for i=1:length(obj.T_(1).c)
    v_ba = obj.T_(obj.T_(1).c(i));
    if(q_max < v_ba.q)
        a_max = v_ba.a;
        q_max = v_ba.q;
    end
end
a=a_max;

if(isempty(a))
    error('plan: No action selected! q_max < v_ba.q is never true.');
end

end

