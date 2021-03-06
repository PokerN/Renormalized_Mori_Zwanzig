%clear all;close all;

addpath ../../simulation_functions
addpath ../../nonlinear
addpath ../../analysis

N_list = 12:4:40;

simulation_params.epsilon = 0.1;  %coefficient on linear term in KdV
simulation_params.alpha = 1;      %coefficient on nonlinear term in KdV
simulation_params.dt = 1e-3;      %timestep
simulation_params.endtime = 100;   %end of simulation
simulation_params.howoften = 1;   %how often to save state vector
simulation_params.blowup = 1;     %if 1, instabilities cause simulation to end, but not give error
simulation_params.tol = inf;    %tolerance for identifying instabilities
simulation_params.N = 256;          %number of positive modes to simulate
simulation_params.initial_condition = @(x) sin(x);


%full model with no approximations
simulation_params.name = 'full';

[t_list,u_list] = KdV_solve(simulation_params);




for i = 1:length(N_list)
    
    N = N_list(i);
    simulation_params.N = N;
    
    simulation_params.name = 'full';
    [t_markov,u_markov] = KdV_solve(simulation_params);
    
    simulation_params.name = 'complete';
    simulation_params.order = 4;
    [t_4,u_4] = KdV_solve(simulation_params);
    
    simulation_params.name = 'complete';
    simulation_params.order = 2;
    [t_2,u_2] = KdV_solve(simulation_params);
    
    simulation_params.name = 'BCH';
    simulation_params.order = 2;
    [t_BCH,u_BCH] = KdV_solve(simulation_params);
    
    energy = figure(1);
    set(gca,'FontSize',16)
    hold off
    plot(t_list,get_energy(u_list,N),'b')
    hold on
    plot(t_markov,get_energy(u_markov,N),'r')
    plot(t_2,get_energy(u_2,N),'g')
    plot(t_4,get_energy(u_4,N),'k')
    plot(t_BCH,get_energy(u_BCH,N),'y')
    title(sprintf('Mass in first N = %i modes',N))
    xlabel('time')
    ylabel('mass')
    legend('Exact','Markov','Order 2 ROM','Order 4 ROM','BCH ROM','location','southwest')
    saveas(energy,sprintf('energy%i',N),'png')
    
    
    
    [x,u_real] = make_real_space(u_list(1:N,:),N);
    [~,u_markov_real] = make_real_space(u_markov,N);
    [~,u_4_real] = make_real_space(u_4,N);
    [~,u_2_real] = make_real_space(u_2,N);
    [~,u_BCH_real] = make_real_space(u_BCH,N);
    
    err_markov = sum((u_real(:,1:length(t_markov))-u_markov_real).^2,1)./sum(u_real(:,1:length(t_markov)).^2,1);
    err_4 = sum((u_real(:,1:length(t_4))-u_4_real).^2,1)./sum(u_real(:,1:length(t_4)).^2,1);
    err_2 = sum((u_real(:,1:length(t_2))-u_2_real).^2,1)./sum(u_real(:,1:length(t_2)).^2,1);
    err_BCH = sum((u_real(:,1:length(t_BCH))-u_BCH_real).^2,1)./sum(u_real(:,1:length(t_BCH)).^2,1);
    
    
    error = figure(2);
    set(gca,'FontSize',16)
    
    hold off
    plot(t_markov,err_markov,'r')
    hold on
    plot(t_2,err_2,'g')
    plot(t_4,err_4,'k')
    plot(t_BCH,err_BCH,'y')
    title(sprintf('Relative error of size N = %i models',N))
    xlabel('time')
    ylabel('relative global error')
    legend('Markov','Order 2 ROM','Order 4 ROM','BCH ROM','location','northwest')
    saveas(error,sprintf('err%i',N),'png')
    
    
    
end