clear all; close all;
clc;
% rng(9) %if seed is 9, the example trajectory is reproduced in the paper
%% intialize
s = -3;
b.s = -30:30; %-30:30
b.w = 1/length(b.s)*ones(1,length(b.s));

%% pomdp
pomdp_params.is_act_cont=false;
pomdp_params.is_obs_cont=true;

pomdp = POMDP_LightDark1D(pomdp_params);

%% solver
solver_params.iterations=1000; %1000
solver_params.depth_max=20; %20
solver_params.gamma=0.95; %0.95
solver_params.c=90; %90
solver_params.k_a = [];
solver_params.alpha_a = [];
solver_params.debug = false;

pomcpop = POMCPOP(pomdp, solver_params);

%% plan
data(1).b=b;
data(1).a=nan;
data(1).s=s;
data(1).xi=nan;
data(1).r=0;
disp(['step 1:',...
      's='  ,num2str(nan),...
      ', a='  ,num2str(data(1).a),...
      ', sp=' ,num2str(data(1).s),...
      ', o='  ,num2str(data(1).xi),...
      ', r='  ,num2str(data(1).r),...
      ', q='  ,num2str(nan)]);
  
figure(1);
clf;
pomdp.plot_data(data);
fn_format_fig();
pause(0.001);
  
iter=1;
total_reward=0;
while 1
    a = pomcpop.plan(b);

    [b, s, o, r] = pomdp.gen_br_pf_with_truth(b, a, s);
    
    data(iter+1).b = b;
    data(iter+1).a = a;
    data(iter+1).s = s;
    data(iter+1).o = o;
    data(iter+1).r = r;
    
    total_reward = total_reward + r;
    
    disp(['step ',num2str(iter+1),':',...
          's='   ,num2str(data(iter).s)  ,', '...
          'a='   ,num2str(data(iter+1).a),', '...
          'sp='  ,num2str(data(iter+1).s),', '...
          'o='   ,num2str(data(iter+1).o),', '...
          'r='   ,num2str(data(iter+1).r),', '...
          'q='   ,num2str(data(iter+1).o)]);
    
    if(a==0)
        break;
    end
    
    figure(1);
    clf;
    pomdp.plot_data(data);
    fn_format_fig();
    pause(0.001);
    
    iter=iter+1;
end

disp(['total reward: ', num2str(total_reward)]);

%% plot 
% disp('Plotting...');
% figure(1);
% pomdp.plot_data(data);
% fn_format_fig();

