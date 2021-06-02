function [a_max] = actionProgWiden(obj, v_b)
%NOTE(jared): The belief stored in the vertices after applying an action
%             is equivalent to the belief in the vertices before applying
%             an action. The belief is updated in the following vertex
%             when the observation is acquired.

if(obj.pomdp_.is_act_cont_)
    %expand action using progressive widening
    if(length(v_b.c) <= obj.k_a*v_b.n^obj.alpha_a)
        a = obj.pomdp_.get_action();

        %add vertex to tree
        vnew.i = length(obj.T_) + 1;
        vnew.p = v_b.i;
        vnew.b = v_b.b;
        vnew.r = v_b.r;
        vnew.c = [];
        vnew.n = 0;
        vnew.a = a;
        vnew.q = 0;
%         v.o = [];
        obj.T_ = [obj.T_ vnew];

        %add child to parent
        obj.T_(vnew.p).c = [obj.T_(vnew.p).c vnew.i];
    end
else
    %expand all possible actions
    if(isempty(v_b.c))
        A = obj.pomdp_.get_all_actions_bmdp();
        
        for i=1:length(A)
            a = A(:,i);
            
            %add vertex to tree
            vnew.i = length(obj.T_) + 1;
            vnew.p = v_b.i;
            vnew.b = v_b.b;
            vnew.r = v_b.r;
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
end

%select action
v_b = obj.T_(v_b.i);
a_max=[];
q_max=0;
for i=1:length(v_b.c)
    v_ba = obj.T_(v_b.c(i)); 
    if(v_ba.n==0)
        a_max = v_ba.i;
        break;
    end
    q = v_ba.q + obj.c_*sqrt(log(v_b.n)/v_ba.n); %UCB1
    if(q_max < q)
        a_max = v_ba.i;
        q_max = q;
    end
end

if(isempty(a_max))
    error('Error! No action selected in actionProgWiden');
end

end

