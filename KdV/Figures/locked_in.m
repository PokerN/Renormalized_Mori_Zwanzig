%a script to produce plots of the "locking in" of coefficients

clear all;close all;

addpath ../simulation_functions
addpath ../nonlinear
addpath ../analysis

%use N values that will yield valid ROMs for all chosen epsilon values
N_list = 20:4:36;
epsilon = 0.1;

endtime = 10;
skip = 0.1;
t = 2:skip:endtime;

%run exact solution to time 10 and use to find t2 and t4 coefficients for
%each ROM]
simulation_params.epsilon = epsilon;  %coefficient on linear term in KdV
simulation_params.alpha = 1;      %coefficient on nonlinear term in KdV
simulation_params.dt = 1e-3;      %timestep
simulation_params.endtime = 10;   %end of simulation
simulation_params.howoften = 1;   %how often to save state vector
simulation_params.blowup = 1;     %if 1, instabilities cause simulation to end, but not give error
simulation_params.tol = inf;    %tolerance for identifying instabilities
simulation_params.N = 256;          %number of positive modes to simulate
simulation_params.initial_condition = @(x) sin(x);

%full model with no approximations
simulation_params.initialization = @(x) full_init_KdV(x);

[t_list,u_list] = PDE_solve(simulation_params);

simulation_params = full_init_KdV(simulation_params);

[u_deriv_list,energy_flow_list,nonlin0_energy_flow,nonlin1_energy_flow,nonlin2_energy_flow,nonlin3_energy_flow,nonlin4_energy_flow] = generate_deriv_data_4func(t_list,u_list,simulation_params,N_list);
coeffs_list = no_k_dependence_coeffs(t_list,energy_flow_list,nonlin0_energy_flow,nonlin1_energy_flow,nonlin2_energy_flow,nonlin3_energy_flow,nonlin4_energy_flow,N_list,0,.1,0);

c1 = squeeze(coeffs_list(:,1,:));
c2 = squeeze(coeffs_list(:,2,:));
c3 = squeeze(coeffs_list(:,3,:));
c4 = squeeze(coeffs_list(:,4,:));



for i = 1:length(N_list)
    leg{i} = sprintf('N = %i',N_list(i));
end

figure(1)
for i = 1:length(N_list)
    subplot(2,2,1)
    plot(t,squeeze(c1(i,:)))
    title('\beta_1 fit on [0,t]','fontsize',16)
    xlabel('t','fontsize',16)
    ylabel('\beta_1','fontsize',16)
    hold on
    
    subplot(2,2,2)
    plot(t,squeeze(c2(i,:)))
    title('\beta_2 fit on [0,t]','fontsize',16)
    xlabel('t','fontsize',16)
    ylabel('\beta_2','fontsize',16)
    hold on
    
    subplot(2,2,3)
    plot(t,squeeze(c3(i,:)))
    title('\beta_3 fit on [0,t]','fontsize',16)
    xlabel('t','fontsize',16)
    ylabel('\beta_3','fontsize',16)
    hold on
    
    subplot(2,2,4)
    plot(t,squeeze(c4(i,:)))
    title('\beta_4 fit on [0,t]','fontsize',16)
    legend(leg{:},'location','southeast')
    xlabel('t','fontsize',16)
    ylabel('\beta_4','fontsize',16)
    hold on
end
saveas(gcf,'coeffs_convergence','png')


figure(2)
for i = 1:length(N_list)
    subplot(2,2,1)
    plot(t,squeeze(c1(i,:)))
    title('\alpha_1 fit on [0,t]','fontsize',16)
    xlabel('t','fontsize',16)
    ylabel('\alpha_1','fontsize',16)
    hold on
    
    subplot(2,2,2)
    plot(t,squeeze(c2(i,:)))
    title('\alpha_2 fit on [0,t]','fontsize',16)
    xlabel('t','fontsize',16)
    ylabel('\alpha_2','fontsize',16)
    hold on
    
    subplot(2,2,3)
    plot(t,squeeze(c3(i,:)))
    title('\alpha_3 fit on [0,t]','fontsize',16)
    xlabel('t','fontsize',16)
    ylabel('\alpha_3','fontsize',16)
    hold on
    
    subplot(2,2,4)
    plot(t,squeeze(c4(i,:)))
    title('\alpha_4 fit on [0,t]','fontsize',16)
    legend(leg{:},'location','southeast')
    xlabel('t','fontsize',16)
    ylabel('\alpha_4','fontsize',16)
    hold on
end
saveas(gcf,'coeffs_convergence_pres','png')