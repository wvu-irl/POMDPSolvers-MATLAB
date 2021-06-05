function [total] = simulate(obj, s, v_b, d)

%terminate if depth exceeded
if(d==0)
    %TODO(jared): assign reward for depth exceeded
    total=0;
    return;
end

%user-defined terminal conditions
%NOTE(jared): necessary for terminating simulation before depth is 
%             exceeded and assigning reward for such scenarios
if(~isempty(obj.is_terminal_))
    is_term = obj.is_terminal_(s);
    if(is_term)
        %TODO(jared): assign reward for terminal condition
        total=0;
        return;
    end
else
    if(d>1e9)
        error('Error! Must define finite depth if terminal condition is not defined!');
    end
end

%expand action (adds vertex to tree or selects vertex from tree)
%NOTE(jared): action index is simply integer representing the ith child
%             of the jth vertex in the tree. For example, consider
%             a_idx = obj.T_(j).c(i), then obj.T_(a_idx) is the ith child
%             of obj.T_(j).
a_idx = obj.actionProgWiden(v_b);
if(obj.debug_)
    disp(['simulate: a_idx = ', num2str(a_idx)]);
end
v_ba = obj.T_(a_idx);

%CHECK THE BELOW UNCOMMENTED LINES ARE CORRECT BEFORE PROCEEDING.
%expand observation (adds vertex to tree or selects vertex from tree)
%NOTE(jared): observation index works similar as the action vertex where
%             the index is an integer representing the ith child of the
%             jth vertex n the tree.
[o_idx, do_rollout] = obj.obsProgWiden(s, v_ba);
if(obj.debug_)
    disp(['simulate: o_idx = ', num2str(o_idx)]);
end
v_bao = obj.T_(o_idx);

%rollout/simulate
if(do_rollout)
    if(obj.debug_)
        disp('simulate: running rollout');
    end
    total = v_bao.r + obj.gamma_*obj.rollout(s, d-1);
else
    if(obj.debug_)
        disp('simulate: running simulate');
    end
    sp = obj.sample(v_bao.b);
    r = obj.pomdp_.reward(s,v_ba.a,sp);
    total = r + obj.gamma_*obj.simulate(sp, v_bao, d-1);
end

%increment visitation counter
obj.T_(v_b.i).n = obj.T_(v_b.i).n + 1;
obj.T_(v_ba.i).n = obj.T_(v_ba.i).n + 1;

%update state-action value
tempQ = obj.T_(v_ba.i).q;
tempN = obj.T_(v_ba.i).n;
obj.T_(v_ba.i).q = tempQ + (total - tempQ)/tempN;

end

