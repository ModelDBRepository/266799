% run_phase_model.m
%
% written by Sungho Hong, Computational Neuroscience Unit, Okinawa Institute of Science and Technology
% July 5, 2020

rate = [10, 40, 70, 93, 116];
amp = famp(rate);

n_ave = 30;
mu_pxx = [];
sd_pxx = [];
for i = 1:numel(rate)
    fprintf('Started running r=%g Hz case...', rate(i));
    tic;
    spike_data = phase_model(rate(i), 12, amp(i), 20, 0.2, 3);
    n = hist(spike_data(:,1), 0:10000); % make a spike time histogram
    n = n(2001:end);  % cut out the beginning part
    [pxx, f] = pmtm(n-mean(n), [], 50:425, 1e3);
    z = movmean(pxx, n_ave);
    zc = movstd(pxx, n_ave);
    mu_pxx = [mu_pxx; z];
    sd_pxx = [sd_pxx; zc];
    fprintf('   Finished.   ', rate(i));
    toc;
end

clear sem_pxx
sem_pxx(:,1,:) = sd_pxx'./sqrt(n_ave);
