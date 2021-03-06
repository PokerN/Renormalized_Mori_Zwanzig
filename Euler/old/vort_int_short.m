% produces abridged plot of vorticity integral for dissertation

clear all;close all;

format long
close all

addpath ../simulation_functions
addpath ../nonlinear
addpath ../analysis

N_list = 4:2:24;
colors = linspecer(length(N_list),'qualitative');

for i = 1:length(N_list)
    
    N = N_list(i);
    full_legend{i} = sprintf('Fourth order N = %i ROM',N);
    
end

for i = 1:length(N_list)
    load(sprintf('t4_%i_1000.mat',N_list(i)));
    load(sprintf('vorticity_%i_1000.mat',N_list(i)));
    
    for j = 1:i
        leg_nw{j} = full_legend{j};
    end
    
    leg_nw{i+1} = 'location';
    leg_nw{i+2} = 'northwest';
    
    window = t4 < 10;
    t4 = t4(window);
    vort2 = vort2(window);
    
    vort_int = zeros(length(t4)-1,1);
    for j = 2:length(t4)
        vort_int(j-1) = trapz(t4(1:j),vort2(1:j).');
    end
    
    t42 = t4(2:end);
    
    
    
    
    
    n = 200;
    m = length(t42);
    
    z = ((t42-min(t42))-(max(t42)-t42))/(max(t42)-min(t42));
    
    A = zeros(m,n+1);
    A_p = zeros(m,n+1);
    A_pp = zeros(m,n+1);
    
    A(:,1) = ones(m,1);
    A_p(:,1) = zeros(m,1);
    A_pp(:,1) = zeros(m,1);
    if n > 1
        A(:,2) = z;
        A_p(:,2) = ones(m,1);
        A_pp(:,2) = zeros(m,1);
    end
    if n > 2
        for k = 3:n+1
            A(:,k) = 2*z.*A(:,k-1) - A(:,k-2);  %% recurrence relation
            A_p(:,k) = 2*A(:,k-1) + 2*z.*A_p(:,k-1) - A_p(:,k-2);
            A_pp(:,k) = 4*A_p(:,k-1) + 2*z.*A_pp(:,k-1) - A_pp(:,k-2);
        end
    end
    
    cheb_coeff = A\vort_int;
    cheb_approx = A*cheb_coeff;
    
    figure(2)
    hold on
    plot(t42,vort_int,'color',colors(i,:))
    plot(t42,cheb_approx,'--','linewidth',2,'color',colors(i,:))
    legend(leg_nw{:})
    title('Integral of maximum of vorticity','fontsize',16)
    xlabel('time','fontsize',16)
    ylabel('Integral of max vorticity','fontsize',16)
    saveas(gcf,'vorticity_int_fit','png')
    
    
    cheb_second_deriv = A_pp*cheb_coeff;
    
    figure(3)
    hold on
    plot(t42(t42 < 6 & t42 > 4),cheb_second_deriv(t42 < 6 & t42 > 4),'linewidth',2,'color',colors(i,:))
    title('Derivative of maximum of vorticity','fontsize',16)
    xlabel('time','fontsize',16)
    ylabel('Derivative of max vorticity','fontsize',16)
    saveas(gcf,'vorticity_deriv','png')
    
    
    cheb_first_deriv = A_p*cheb_coeff;
    
    figure(4)
    plot(t42,vort2(2:end),'linewidth',2,'color',colors(i,:))
    hold on
    plot(t42,cheb_first_deriv,'--','linewidth',2,'color',colors(i,:))
    title('Maximum of vorticity','fontsize',16)
    xlabel('time','fontsize',16)
    ylabel('Derivative of max vorticity','fontsize',16)
    saveas(gcf,'vorticity','png')
    
    
end