% run_no_scaling_case.m
%
% written by Sungho Hong, Computational Neuroscience Unit, Okinawa Institute of Science and Technology
% July 5, 2020

clear all;
startup;

% Frequency to simulate
freq = 70;

afamp = 49.1;
bfamp = 26.4;
fcamp = @(r) 1./(1+exp(-(r-afamp)/bfamp));

scf = 1/(1-fcamp(0));
famp0 = @(r) scf*(fcamp(r)-fcamp(0));
famp = @(r) (r*0 + famp0(freq));

% %%
casename = sprintf('no_scaling_%dHz', freq);
figname = sprintf('power_%s', casename);

% %%
run_phase_model;

% %%
save(figname, 'mu_pxx', 'sem_pxx')

% %%
clf;
subplot(221)
plot_power;
set(gcf, 'color','w')
export_fig(figname,'-pdf','-r600','-painters')
