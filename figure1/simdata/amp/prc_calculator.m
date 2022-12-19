
close all;
clear all;
clc;
basal = dlmread('../basal_condition.dat');
P   = dir ('prc_*.dat');
phase = [];
prc = [];
prc_pb = [];
rpa = load (P(1).name, '-ascii');

dt = [0.5
    0.5
    0.2
    0.2
    0.1
    0.1
    0.1
    0.1
    0.1
    0.1
    0.1
    0.1
    0.1
    ]/2;
width = 4; height = 6;
h =figure('Units','inches',...
'Position',[10 5 width height],...
'PaperPositionMode','auto');

 for ilk = 1 : max(rpa(:,1))            %the number of firing rates
     rp0  = [];
     rp_a = rpa(rpa(:,1)==ilk,2);
     rp_b = rpa(rpa(:,1)==ilk,3);
     rp_c = rpa(rpa(:,1)==ilk,4);
     rp0 = [rp_a rp_b rp_c];

    mx  = max (rp0(:,1));   % the number of stimulus condition
    for i = 1 : mx              % the number of stimulus 
        prc = [];
        phase = [];
        ward  = rp0 (rp0 (:, 1) == i, 2);    % spike timing, every ward correspond to all the spike timings
        spk = rp0 (rp0 (:, 1) == i, 3);
        Tstim_base = basal(basal(:,1)==ilk,3);
        isi = basal(basal(:,1)==ilk,2);
        for j = 1:2:max(ward)         % let's see whether we need a +1
            ward_single = ward(ward==j);
            spk_single = spk(ward==j);
            spk_single =sort(spk_single);
            phase_single = dt(ilk)*j/isi;
            b = spk_single(spk_single>Tstim_base);
            b =sort(b);
            prc_single = 1-(b(1)-Tstim_base)/isi;
            phase = [phase;phase_single];
            prc = [prc;prc_single];
        end
        prc_pb = [prc_pb; 1000/isi max(prc(1:ceil(0.5*length(phase)))) max(prc)];
        plot(phase,prc+ilk*0.01,'Color','k','LineWidth',2);
        hold on
       
    end
        
 end
 
