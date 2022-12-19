% plot_power.m
%
% written by Sungho Hong, Computational Neuroscience Unit, Okinawa Institute of Science and Technology
% July 5, 2020

cols = zeros(5, 3);

cols(1,:) = [0, 0, 0];   % black
cols(2,:) = [0, 1, 0]/2; % green
cols(3,:) = [0, 0, 1];   % blue
cols(4,:) = [1, 0, 1]/2; % magenta
cols(5,:) = [1, 0, 0];   % red

hls = boundedline(f, mu_pxx, sem_pxx, 'cmap', cols, 'alpha');

legendflex(...
    hls, {'10 Hz', '40 Hz', '70 Hz', '93 Hz', '116 Hz'}, ...
    'box', 'off', 'xscale', 0.5...
)

for i=1:numel(hls)
    set(hls(i), 'linewidth', 1)
end


box off
xlim([50 425])
ylim([0 0.04])
xlabel('frequency (Hz)')
ylabel('power')
