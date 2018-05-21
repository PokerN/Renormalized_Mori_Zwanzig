addpath ../simulation_functions
addpath ../nonlinear
addpath ../analysis

endtime = 10;
N = 20;
alpha = 1;

% load the exact solution if it exists, otherwise make it
if ~(exist(sprintf('u_list%i.mat',endtime),'file') == 2)
    
    [t_list,u_list] = upwind_burgers(1,10000,endtime,1e-4,1000);
    save(sprintf('u_list%i',endtime),'u_list');
    save(sprintf('t_list%i',endtime),'t_list');
    
else
    load(sprintf('u_list%i',endtime));
    load(sprintf('t_list%i',endtime));
end

[x_e,u_e] = make_real_space(u_list,N);

% save shared parameters
simulation_params.N = N;
simulation_params.alpha = alpha;
simulation_params.endtime = endtime;
simulation_params.print_time = 1;
simulation_params.time_range = t_list;

% Burgers-style 1 ROM
type = 'c1B';
simulation_params.time_dependence = 1;
simulation_params.degree = 4;
simulation_params.coeffs = scaling_law(N,type);
simulation_params.initialization = @(x) ROM_init_Burgers(x);
simulation_params.time_dependence = 1;
[tc1B,uc1B] = PDE_solve(simulation_params);
[x_c1B,u_c1B] = make_real_space(uc1B,N);

% Burgers-style 1+2 ROM
type = 'c2B';
simulation_params.time_dependence = 1;
simulation_params.degree = 4;
simulation_params.coeffs = scaling_law(N,type);
simulation_params.initialization = @(x) ROM_init_Burgers(x);
simulation_params.time_dependence = 1;
[tc2B,uc2B] = PDE_solve(simulation_params);
[x_c2B,u_c2B] = make_real_space(uc2B,N);

% Burgers-style 1+2+3 ROM
type = 'c3B';
simulation_params.time_dependence = 1;
simulation_params.degree = 4;
simulation_params.coeffs = scaling_law(N,type);
simulation_params.initialization = @(x) ROM_init_Burgers(x);
simulation_params.time_dependence = 1;
[tc3B,uc3B] = PDE_solve(simulation_params);
[x_c3B,u_c3B] = make_real_space(uc3B,N);

% Burgers-style 1+2+3+4 ROM
type = 'c4B';
simulation_params.time_dependence = 1;
simulation_params.degree = 4;
simulation_params.coeffs = scaling_law(N,type);
simulation_params.initialization = @(x) ROM_init_Burgers(x);
simulation_params.time_dependence = 1;
[tc4B,uc4B] = PDE_solve(simulation_params);
[x_c4B,u_c4B] = make_real_space(uc4B,N);

% KdV-style 1 ROM
type = 'c1KdV';
simulation_params.time_dependence = 1;
simulation_params.degree = 4;
simulation_params.coeffs = scaling_law(N,type);
simulation_params.initialization = @(x) ROM_init_Burgers(x);
simulation_params.time_dependence = 0;
[tc1KdV,uc1KdV] = PDE_solve(simulation_params);
[x_c1KdV,u_c1KdV] = make_real_space(uc1KdV,N);

% KdV-style 1+2 ROM
type = 'c2KdV';
simulation_params.time_dependence = 1;
simulation_params.degree = 4;
simulation_params.coeffs = scaling_law(N,type);
simulation_params.initialization = @(x) ROM_init_Burgers(x);
simulation_params.time_dependence = 0;
[tc2KdV,uc2KdV] = PDE_solve(simulation_params);
[x_c2KdV,u_c2KdV] = make_real_space(uc2KdV,N);

% KdV-style 1+2+3 ROM
type = 'c3KdV';
simulation_params.time_dependence = 1;
simulation_params.degree = 4;
simulation_params.coeffs = scaling_law(N,type);
simulation_params.initialization = @(x) ROM_init_Burgers(x);
simulation_params.time_dependence = 0;
[tc3KdV,uc3KdV] = PDE_solve(simulation_params);
[x_c3KdV,u_c3KdV] = make_real_space(uc3KdV,N);

% KdV-style 1+2+3+4 ROM
type = 'c4KdV';
simulation_params.time_dependence = 1;
simulation_params.degree = 4;
simulation_params.coeffs = scaling_law(N,type);
simulation_params.initialization = @(x) ROM_init_Burgers(x);
simulation_params.time_dependence = 0;
[tc4KdV,uc4KdV] = PDE_solve(simulation_params);
[x_c4KdV,u_c4KdV] = make_real_space(uc4KdV,N);


x1{1} = x_e;
u1{1} = u_e;
leg1{1} = 'Exact';
make_plots(t_list,x1,u1,leg1);
pause

x2{1} = x_e;
x2{2} = x_c1B;
x2{3} = x_c2B;
x2{4} = x_c3B;
x2{5} = x_c4B;
u2{1} = u_e;
u2{2} = u_c1B;
u2{3} = u_c2B;
u2{4} = u_c3B;
u2{5} = u_c4B;
leg2 = {'Exact','First order constant','Second order constant','Third order constant','Fourth order constant'};
make_plots(t_list,x2,u2,leg2);
pause

x3{1} = x_e;
x3{2} = x_c1KdV;
x3{3} = x_c2KdV;
x3{4} = x_c3KdV;
x3{5} = x_c4KdV;
u3{1} = u_e;
u3{2} = u_c1KdV;
u3{3} = u_c2KdV;
u3{4} = u_c3KdV;
u3{5} = u_c4KdV;
leg3 = {'Exact','First order decaying','Second order decaying','Third order decaying','Fourth order decaying'};
make_plots(t_list,x3,u3,leg3);