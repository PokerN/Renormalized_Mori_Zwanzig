%a function to compute the real space solutions at a variety of times
%according to several models

addpath ../simulation_functions
addpath ../nonlinear
addpath ../analysis

clear all;close all;
N = 20;
epsilon = 0.1;
endtime = 10;
howoften = 10;

simulation_params.epsilon = epsilon;  %coefficient on linear term in KdV
simulation_params.alpha = 1;      %coefficient on nonlinear term in KdV
simulation_params.dt = 1e-4;      %timestep
simulation_params.endtime = 100;   %end of simulation
simulation_params.howoften = 100;   %how often to save state vector
simulation_params.blowup = 1;     %if 1, instabilities cause simulation to end, but not give error
simulation_params.tol = inf;    %tolerance for identifying instabilities
simulation_params.N = 256;          %number of positive modes to simulate
simulation_params.initial_condition = @(x) sin(x);
simulation_params.initialization = @(x) full_init_KdV(x);  %full simulation

[t_list,u_list] = PDE_solve(simulation_params);
save t_list t_list
save u_list u_list

if length(t_list) ~= length(0:simulation_params.dt*simulation_params.howoften:simulation_params.endtime)
    return
end


simulation_params.initialization = @(x) complete_init_KdV(x);
simulation_params.order = 4;
simulation_params.N = N;

[t_ROM,u_ROM] = PDE_solve(simulation_params);
save t_ROM t_ROM
save u_ROM u_ROM

simulation_params.initialization = @(x) full_init_KdV(x);
simulation_params.N = N;
[t_markov,u_markov] = PDE_solve(simulation_params);
save t_markov t_markov
save u_markov u_markov




[x,u_real] = make_real_space(u_list(1:N,:),N);
[~,u_markov_real] = make_real_space(u_markov,N);
[~,u_ROM_real] = make_real_space(u_ROM,N);




real_space = figure(1);

leg{1} = 'Exact';
leg{2} = 'Markov';
leg{3} = '4th Order ROM';
leg{4} = 'location';
leg{5} = 'northwest';

leg2 = leg;
leg2{5} = 'northeast';


t1 = 1;
t2 = find(t_list == 1);
t3 = find(t_list == 10);
t4 = find(t_list == 80);

subplot(2,2,1)
plot(x,u_real(:,t1),'k','linewidth',2)
hold on
plot(x,u_markov_real(:,t1),'k-s')
plot(x,u_ROM_real(:,t1),'k-o')
title(sprintf('t = %i',t_list(t1)))
xlabel('x')
ylabel(sprintf('u(x,%i)',t_list(t1)))
legend(leg{:})
axis([0,2*pi,-1,3])

subplot(2,2,2)
plot(x,u_real(:,t2),'k','linewidth',2)
hold on
plot(x,u_markov_real(:,t2),'k-s')
plot(x,u_ROM_real(:,t2),'k-o')
title(sprintf('t = %i',t_list(t2)))
xlabel('x')
ylabel(sprintf('u(x,%i)',t_list(t2)))
legend(leg{:})
axis([0,2*pi,-1,3])


subplot(2,2,3)
plot(x,u_real(:,t3),'k','linewidth',2)
hold on
plot(x,u_markov_real(:,t3),'k-s')
plot(x,u_ROM_real(:,t3),'k-o')
title(sprintf('t = %i',t_list(t3)))
xlabel('x')
ylabel(sprintf('u(x,%i)',t_list(t3)))
legend(leg{:})
axis([0,2*pi,-1,3])


subplot(2,2,4)
plot(x,u_real(:,t4),'k','linewidth',2)
hold on
plot(x,u_markov_real(:,t4),'k-s')
plot(x,u_ROM_real(:,t4),'k-o')
title(sprintf('t = %i',t_list(t4)))
xlabel('x')
ylabel(sprintf('u(x,%i)',t_list(t4)))
legend(leg2{:})
axis([0,2*pi,-1,3])

saveas(real_space,sprintf('real_space%i',N),'png')
close all
