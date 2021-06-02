function [] = plan(obj, b, d_max)

%initialize tree
obj.T_(1).b=b;     %belief
obj.T_(1).r=0;     %reward
obj.T_(1).c=[];    %children
obj.T_(1).n=0;     %number of times visited
obj.T_(1).d=d_max; %depth

%construct tree
for i=1:obj.iterations
    %root
    v_b=obj.T_(1);
    
    %simulate
    total=0;
    while 1
        b = v_b.b;
        d = v_b.d;
        
        %terminate if depth exceeded
        if(d==0)
            %TODO(jared): assign reward
            break;
        end
        
        %user-defined terminal conditions
        is_term = is_terminal(b);
        if(is_term)
            %TODO(jared): assign reward
            break;
        end

        %action (adds vertex to tree or selects vertex from tree)
        %NOTE: actions are simply integers that represent the ith child
        %      of the jth vertex in the tree. For example, consider
        %      k = obj.T_(j).c(i), then obj.T_(k) is the ith child of
        %      obj.T_(j).
        a = actionProgWiden(b);
        v_ba = obj.T_(v_b.c(a));
        b = v_ba.b;
        d = v_ba.d;
        
        %observation (adds vertex to tree or selects vertex from tree)
        if(length(v_ba.c) <= k_o*v_ba.n^alpha_o)
            [b,r] = generative_model(b,a);
            
            %add vertex to tree
            v.b=b;
            v.r=r;
            v.c=[];
            v.n=1;
            v.d=d-1;
                
            %accumulated reward
            total = total + r + gamma*rollout(b,d-1);
        else
            
        end
        
        %update 
    end
    
end

end

