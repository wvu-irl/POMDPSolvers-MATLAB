function [a,q] = plan(obj, b)

alloc_size = obj.iterations_;
obj.T_=[];                   %ensure tree is empty
obj.T_(alloc_size).i=[];     %index of vertex
obj.T_(alloc_size).p=[];     %index of parent
obj.T_(alloc_size).b=[];     %belief
obj.T_(alloc_size).r=[];     %reward
obj.T_(alloc_size).c=[];     %children
obj.T_(alloc_size).n=[];     %number of times visited
obj.T_(alloc_size).a=[];     %action (i.e., action taken to reach vertex)
obj.T_(alloc_size).q=[];     %state-action value

%root
obj.T_=[];         %ensure tree is empty
obj.T_(1).i=1;     %index of vertex
obj.T_(1).p=nan;   %index of parent
obj.T_(1).b=b;     %belief
obj.T_(1).r=0;     %reward
obj.T_(1).c=[];    %children
obj.T_(1).n=0;     %number of times visited
obj.T_(1).a=[];    %action (i.e., action taken to reach vertex)
obj.T_(1).q=0;     %state-action value
obj.T_size_ = 1;

%iteratively build tree
for i=1:obj.iterations_
%     disp(['Iteration ', num2str(i)]);
    v_b = obj.T_(1);
    
    obj.simulate(v_b, obj.depth_max_);
    if(obj.debug_)
        disp(['length(T_)=',num2str(length(obj.T_))]);
        disp(' ');
    end
end

%return argmax_a Q(ba)
a=[];
q=-inf;
for i=1:length(obj.T_(1).c)
    v_ba = obj.T_(obj.T_(1).c(i));
    if(q < v_ba.q)
        a = v_ba.a;
        q = v_ba.q;
    end
end

end

