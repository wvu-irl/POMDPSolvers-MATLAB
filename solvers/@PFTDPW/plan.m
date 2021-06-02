function [a] = plan(obj, b)

%root
obj.T_(1).i=1;     %index of vertex
obj.T_(1).p=nan;   %index of parent
obj.T_(1).b=b;     %belief
obj.T_(1).r=0;     %reward
obj.T_(1).c=[];    %children
obj.T_(1).n=0;     %number of times visited
obj.T_(1).a=[];    %action (i.e., action taken to reach vertex)
obj.T_(1).q=0;     %state-action value
% obj.T_(1).o=[];  %observation

%iteratively build tree
for i=1:obj.iterations_
    disp(['Iteration ', num2str(i)]);
    v_b = obj.T_(1);
    obj.simulate(v_b, obj.depth_max_);
end

%return argmax_a Q(ba)
a_max=[];
q_max=0;
for i=1:length(obj.T_(1).c)
    v_ba = obj.T_(obj.T_(1).c(i));
    if(q_max < v_ba.q)
        a_max = v_ba.a;
        q_max = v_ba.q;
    end
end
a=a_max;

end

