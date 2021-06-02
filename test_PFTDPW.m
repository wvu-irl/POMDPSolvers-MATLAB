clear all; close all;
clc;

%pomdp
pomdp_params.is_act_cont=false;
pomdp_params.is_obs_cont=true;
pomdp = POMDP_LightDark1D(pomdp_params);

%solver
solver_params.iterations=100;
solver_params.depth_max=20;
solver_params.gamma=0.95;
solver_params.c=100;
solver_params.k_o = 4.0;
solver_params.alpha_o = 1.0/10.0;

pftdpw = PFTDPW(pomdp, solver_params);

%plan
b.s = -30:30;
b.w = 1/length(b.s)*ones(1,length(b.s));
a = pftdpw.plan(b);

disp('Complete.');

