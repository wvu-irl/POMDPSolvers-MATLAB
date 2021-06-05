function [a] = plan(obj, b)

%root
obj.T_=[];         %ensure tree is empty
obj.T_(1).i=1;     %index of vertex
obj.T_(1).p=nan;   %index of parent
obj.T_(1).b=b;     %belief
obj.T_(1).r=0;     %reward
obj.T_(1).c=[];    %children
obj.T_(1).n=0;     %number of times visited
obj.T_(1).m=0;
obj.T_(1).a=[];    %action (i.e., action taken to reach vertex)
obj.T_(1).o=[];
obj.T_(1).q=0;     %state-action value

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

end

