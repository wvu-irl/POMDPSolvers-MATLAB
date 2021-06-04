function [a_max] = actionProgWiden(obj, v_b)
%NOTE(jared): The belief stored in the vertices after applying an action
%             is equivalent to the belief in the vertices before applying
%             an action. The belief is updated in the following vertex
%             when the observation is acquired.

n_added=0; %only for debugging
if(obj.pomdp_.is_act_cont_)
    temp_n = length(v_b.c);
    temp_nmax = obj.k_a_*v_b.n^obj.alpha_a_;
    if(obj.debug_)
        disp(['actionProgWiden: if(',num2str(temp_n),' <= ',num2str(temp_nmax),')']);
    end
    %expand action using progressive widening
    if(temp_n <= temp_nmax)
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
        obj.T_ = [obj.T_ vnew];

        %add child to parent
        obj.T_(vnew.p).c = [obj.T_(vnew.p).c vnew.i];
        
        n_added=n_added+1;%only for debugging
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
            obj.T_ = [obj.T_ vnew];

            %add child to parent
            obj.T_(vnew.p).c = [obj.T_(vnew.p).c vnew.i];
            
            n_added=n_added+1;%only for debugging
        end
    end
end
if(obj.debug_)
    disp(['actionProgWiden: n_added = ', num2str(n_added)]);
end

%select action
v_b = obj.T_(v_b.i);
a_max=[];
q_max=-inf;
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

