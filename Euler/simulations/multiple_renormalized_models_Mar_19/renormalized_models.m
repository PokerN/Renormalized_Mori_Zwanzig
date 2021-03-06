function renormalized_models(N,end_time,filetype)

format long

addpath ../../simulation_functions
addpath ../../nonlinear
addpath ../../analysis

M = 3*N;

% uniform grid
x = linspace(0,2*pi*(2*M-1)/(2*M),2*M).';
y = x;
z = x;

% 3D array of data points
[X,Y,Z] = ndgrid(x,y,z);

% create initial condition
eval = taylor_green(X,Y,Z);
u_full = fftn_norm(eval);
u = u_squishify(u_full,N);

% make k array
k_vec = [0:M-1,-M:1:-1];
[kx,ky,kz] = ndgrid(k_vec,k_vec,k_vec);
k = zeros(2*M,2*M,2*M,3);
k(:,:,:,1) = kx;
k(:,:,:,2) = ky;
k(:,:,:,3) = kz;

params.k = k;
params.N = N;
params.M = M;
params.a = 2:M;
params.b = 2*M:-1:M+2;
params.a_tilde = N+1:M;
params.a_tilde2 = 2*N+1:M;
params.print_time = 1;
params.no_time = 1;

params1 = params;
params1.func = @(x) tmodel_RHS(x);
params1.coeff = scaling_law(N,1);

if exist(sprintf('u_array1_%i_%i.mat',N,end_time),'file') == 2
    
    load(sprintf('u_array1_%i_%i.mat',N,end_time))
    load(sprintf('t1_%i_%i',N,end_time))
    
else
    
    
    % run the simulation
    options = odeset('RelTol',1e-10,'Stats','on','InitialStep',1e-3);
    [t1,u_raw1] = ode45(@(t,u) RHS(u,t,params1),[0,end_time],u(:),options);
    
    
    
    
    % reshape the output array into an intelligible shape (should make this a
    % separate function later)
    u_array1 = zeros([size(u) length(t1)]);
    for i = 1:length(t1)
        u_array1(:,:,:,:,:,i) = reshape(u_raw1(i,:),[N,N,N,3,4]);
    end
    
    save(sprintf('t1_%i_%i',N,end_time),'t1');
    save(sprintf('u_array1_%i_%i',N,end_time),'u_array1');
    
end

if exist(sprintf('u_array2_%i_%i.mat',N,end_time),'file') == 2
    
    load(sprintf('u_array2_%i_%i.mat',N,end_time))
    load(sprintf('t2_%i_%i',N,end_time))
    
else
    
    
    params2 = params;
    params2.func = @(x) t2model_RHS(x);
    params2.coeff = scaling_law(N,2);
    
    % run the simulation
    options = odeset('RelTol',1e-10,'Stats','on','InitialStep',1e-3);
    [t2,u_raw2] = ode45(@(t,u) RHS(u,t,params2),[0,end_time],u(:),options);
    
    
    % reshape the output array into an intelligible shape (should make this a
    % separate function later)
    u_array2 = zeros([size(u) length(t2)]);
    for i = 1:length(t2)
        u_array2(:,:,:,:,:,i) = reshape(u_raw2(i,:),[N,N,N,3,4]);
    end
    
    save(sprintf('t2_%i_%i',N,end_time),'t2');
    save(sprintf('u_array2_%i_%i',N,end_time),'u_array2');
    
end

if exist(sprintf('u_array3_%i_%i.mat',N,end_time),'file') == 2
    
    load(sprintf('u_array3_%i_%i.mat',N,end_time))
    load(sprintf('t3_%i_%i',N,end_time))
    
else
    
    
    
    params3 = params;
    params3.func = @(x) t3model_RHS(x);
    params3.coeff = scaling_law(N,3);
    
    % run the simulation
    options = odeset('RelTol',1e-10,'Stats','on','InitialStep',1e-3);
    [t3,u_raw3] = ode45(@(t,u) RHS(u,t,params3),[0,end_time],u(:),options);
    
    
    % reshape the output array into an intelligible shape (should make this a
    % separate function later)
    u_array3 = zeros([size(u) length(t3)]);
    for i = 1:length(t3)
        u_array3(:,:,:,:,:,i) = reshape(u_raw3(i,:),[N,N,N,3,4]);
    end
    
    save(sprintf('t3_%i_%i',N,end_time),'t3');
    save(sprintf('u_array3_%i_%i',N,end_time),'u_array3');
    
end

if exist(sprintf('u_array4_%i_%i.mat',N,end_time),'file') == 2
    
    load(sprintf('u_array4_%i_%i.mat',N,end_time))
    load(sprintf('t4_%i_%i',N,end_time))
    
else
    
    params4 = params;
    params4.func = @(x) t4model_RHS(x);
    params4.coeff = scaling_law(N,4);
    
    % run the simulation
    options = odeset('RelTol',1e-10,'Stats','on','InitialStep',1e-3);
    [t4,u_raw4] = ode45(@(t,u) RHS(u,t,params4),[0,end_time],u(:),options);
    
    
    % reshape the output array into an intelligible shape (should make this a
    % separate function later)
    u_array4 = zeros([size(u) length(t4)]);
    for i = 1:length(t4)
        u_array4(:,:,:,:,:,i) = reshape(u_raw4(i,:),[N,N,N,3,4]);
    end
    
    save(sprintf('t4_%i_%i',N,end_time),'t4');
    save(sprintf('u_array4_%i_%i',N,end_time),'u_array4');
    
end

t1_include = 0;
t2_include = 0;
t3_include = 0;
t4_include = 0;
i = 1;

if t1(end) == end_time
    t1_include = 1;
    little_legend{i} = sprintf('ROM order 1, N = %i',N);
    i = i+1;
end

if t2(end) == end_time
    t2_include = 1;
    little_legend{i} = sprintf('ROM order 2, N = %i',N);
    i = i+1;
end

if t3(end) == end_time
    t3_include = 1;
    little_legend{i} = sprintf('ROM order 3, N = %i',N);
    i = i+1;
end

if t4(end) == end_time
    t4_include = 1;
    little_legend{i} = sprintf('ROM order 4, N = %i',N);
    i = i+1;
end

little_legend_sw = little_legend;
little_legend_sw{i} = 'location';
little_legend_sw{i+1} = 'southwest';

little_legend_se = little_legend;
little_legend_se{i} = 'location';
little_legend_se{i+1} = 'southeast';



% plot the energy in some modes
energy1 = get_3D_energy(u_array1,N);
energy2 = get_3D_energy(u_array2,N);
energy3 = get_3D_energy(u_array3,N);
energy4 = get_3D_energy(u_array4,N);
figure(1)
hold off
plot(log(t1),log(energy1),'linewidth',2)
hold on
plot(log(t2),log(energy2),'r','linewidth',2)
plot(log(t3),log(energy3),'k','linewidth',2)
plot(log(t4),log(energy4),'c','linewidth',2)
legend(sprintf('ROM order 1, N = %i',N),sprintf('ROM order 2, N = %i',N),sprintf('ROM order 3, N = %i',N),sprintf('ROM order 4, N = %i',N),'location','southwest')
title('Energy in resolved modes','fontsize',16)
xlabel('log(time)','fontsize',16)
ylabel('log(energy)','fontsize',16)
saveas(gcf,sprintf('energy%i_%i',N,end_time),filetype)




% plot the helicity
w1 = helicity(u_array1);
w2 = helicity(u_array2);
w3 = helicity(u_array3);
w4 = helicity(u_array4);
figure(2)
hold off
if t1_include
    plot(t1,w1,'linewidth',2)
    hold on
end
if t2_include
    plot(t2,w2,'r','linewidth',2)
    hold on
end
if t3_include
    plot(t3,w3,'k','linewidth',2)
    hold on
end
if t4_include
    plot(t4,w4,'c','linewidth',2)
    hold on
end
legend(little_legend_sw{:})
title('Helicity','fontsize',16)
xlabel('time','fontsize',16)
ylabel('w','fontsize',16)
saveas(gcf,sprintf('helicity%i_%i',N,end_time),filetype)



% if t1_include
%     
%     if exist(sprintf('d1_%i_%i.mat',N,end_time),'file') == 2
%         
%         load(sprintf('d1_%i_%i.mat',N,end_time))
%         
%     else
%         d1 = energy_derivative(u_array1,t1,params1);
%         save(sprintf('d1_%i_%i',N,end_time),'d1');
%     end
% end
% if t2_include
%     if exist(sprintf('d2_%i_%i.mat',N,end_time),'file') == 2
%         
%         load(sprintf('d2_%i_%i.mat',N,end_time))
%     else
%         d2 = energy_derivative(u_array2,t2,params2);
%         save(sprintf('d2_%i_%i',N,end_time),'d2');
%     end
% end
% if t3_include
%     if exist(sprintf('d3_%i_%i.mat',N,end_time),'file') == 2
%         
%         load(sprintf('d3_%i_%i.mat',N,end_time))
%     else
%         d3 = energy_derivative(u_array3,t3,params3);
%         save(sprintf('d3_%i_%i',N,end_time),'d3');
%     end
% end
% if t4_include
%     if exist(sprintf('d4_%i_%i.mat',N,end_time),'file') == 2
%         
%         load(sprintf('d4_%i_%i.mat',N,end_time))
%     else
%         d4 = energy_derivative(u_array4,t4,params4);
%         save(sprintf('d4_%i_%i',N,end_time),'d4');
%     end
% end




% figure(3)
% hold off
% if t1_include
%     plot(t1,d1,'linewidth',2)
%     hold on
% end
% if t2_include
%     plot(t2,d2,'r','linewidth',2)
%     hold on
% end
% if t3_include
%     plot(t3,d3,'k','linewidth',2)
%     hold on
% end
% if t4_include
%     plot(t4,d4,'c','linewidth',2)
%     hold on
% end
% legend(little_legend_se{:})
% title('Energy Derivative','fontsize',16)
% xlabel('time','fontsize',16)
% ylabel('w','fontsize',16)
% saveas(gcf,sprintf('energy_deriv%i_%i',N,end_time),filetype)


if t1_include
    ens1 = enstrophy(u_array1);
end
if t2_include
    ens2 = enstrophy(u_array2);
end
if t3_include
    ens3 = enstrophy(u_array3);
end
if t4_include
    ens4 = enstrophy(u_array4);
end

figure(4)
hold off
if t1_include
    plot(t1,ens1,'linewidth',2)
    hold on
end
if t2_include
    plot(t2,ens2,'r','linewidth',2)
    hold on
end
if t3_include
    plot(t3,ens3,'k','linewidth',2)
    hold on
end
if t4_include
    plot(t4,ens4,'c','linewidth',2)
    hold on
end
legend(little_legend_se{:})
title('Enstrophy','fontsize',16)
xlabel('time','fontsize',16)
ylabel('enstrophy','fontsize',16)
saveas(gcf,sprintf('enstrophy%i_%i',N,end_time),filetype)