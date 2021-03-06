clear all; close all

N_list = 4:4:24;
filetype = 'eps';
end_time = 1000;

style{1} = '-o';
style{2} = '-*';
style{3} = '-+';
style{4} = '-s';
style{5} = '-x';
style{6} = '-^';



% create the legends
for i = 1:length(N_list)
    
    N = N_list(i);
    full_legend{i} = sprintf('Fourth order N = %i ROM',N);
    
end

for i = 1:length(N_list)
    
    N = N_list(i);
    
    for j = 1:i
        leg_sw{j} = full_legend{j};
        leg_se{j} = full_legend{j};
        leg_ne{j} = full_legend{j};
        leg_nw{j} = full_legend{j};
    end
    
    leg_sw{i+1} = 'location';
    leg_sw{i+2} = 'southwest';
    leg_se{i+1} = 'location';
    leg_se{i+2} = 'southeast';
    leg_ne{i+1} = 'location';
    leg_ne{i+2} = 'northeast';
    leg_nw{i+1} = 'location';
    leg_nw{i+2} = 'northwest';
    
    
    
    % plot the energy in some modes
    if exist(sprintf('energy_%i_%i.mat',N,end_time),'file') == 2
        load(sprintf('energy_%i_%i.mat',N,end_time))
        load(sprintf('t4_%i_%i',N,end_time))
    else
        energy = get_3D_energy(u_array4,N);
        save(sprintf('energy_%i_%i.mat',N,end_time),'energy');
    end
    
    even_log_space = exp(linspace(-2,log(t4(end)),50));
    indexes = zeros(50,1);
    for j = 1:length(even_log_space)
        [~,min_loc] = min(abs(t4 - even_log_space(j)));
        indexes(j) = min_loc;
    end
    
    t4_e = t4(indexes);
    energy = energy(indexes);
    
    
    
    
    energy_plot = figure(1);
    hold on
    plot(log(t4_e),log(energy),style{i})
    legend(leg_sw{:})
    title('Energy in resolved modes','fontsize',16)
    xlabel('log(time)','fontsize',16)
    ylabel('log(energy)','fontsize',16)
    axis([min(log(t4_e)),max(log(t4_e)),-10,0])
    
    
    
    
    % plot the enstrophy
    if exist(sprintf('enstrophy_%i_%i.mat',N,end_time),'file') == 2
        load(sprintf('enstrophy_%i_%i.mat',N,end_time))
    else
        ens = enstrophy(u_array4);
        save(sprintf('enstrophy_%i_%i.mat',N,end_time),'ens');
    end
    
    [~,loc] = min(abs(t4-50));
    
    
    % plot the enstrophy on a smaller domain
    enstrophy_plot = figure(4);
    hold on
    plot(t4(1:10:loc),ens(1:10:loc),style{i})
    legend(leg_ne{:})
    title('Enstrophy','fontsize',16)
    xlabel('time','fontsize',16)
    ylabel('enstrophy','fontsize',16)
    
    
    % plot the vorticity
    if exist(sprintf('vorticity_%i_%i.mat',N,end_time),'file') == 2
        load(sprintf('vorticity_%i_%i.mat',N,end_time))
    else
        [~,vort2] = vorticity(u_array4);
        save(sprintf('vorticity_%i_%i.mat',N,end_time),'vort2');
    end
    
    
    % plot the vorticity on a smaller domain
    vort_plot = figure(6);
    hold on
    plot(t4(1:10:loc),vort2(1:10:loc),style{i})
    legend(leg_ne{:})
    title('Maximum of vorticity','fontsize',16)
    xlabel('time','fontsize',16)
    ylabel('maximal vorticity','fontsize',16)
    
    vort_int = zeros(length(t4)-1,1);
    for j = 2:length(t4)
        vort_int(j-1) = trapz(t4(1:j),vort2(1:j).');
    end
    
end



    saveas(energy_plot,sprintf('energy_mult_%i',N),filetype)
    saveas(enstrophy_plot,sprintf('enstrophy_mult_trim%i',N),filetype)
saveas(vort_plot,sprintf('vorticity_mult_trim%i',N),filetype)