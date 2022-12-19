clc;
close all;
clear all;

basal = dlmread('./simdata/curr/basal_condition.dat');

formatSpec = '%03d';
%v, availability of Na, Na current,persistent Na, sk2,BKf,BKs,Cap, axial current 

N_dim = 1000/0.02+1;
width = 2; height = 2;

stim_step = [0.25 0.25 0.1 0.1 0.05 0.05 0.05 0.05 0.05 0.05 0.05 0.05 0.05];

t = 0:0.02:1000;
dt = 0.02;

jind_ph =[0.2 0.6 0.8;
0.2 0.6  0.8;  
0.2 0.6 0.8];

k_base = [
7.76e-3 -6.05e-3
2.3e-3 -6.41e-3
1.615e-3 -8.8e-3
];

k_base2 = [
0.052565 -0.01238
0.04207 -0.0167604
0.039485 -0.02

];
k_base2 = [
0 0
0 0
0 0
];

k_base3 = [
0.0944 -0.0121
0.0838 -0.0214
0.083 -0.0256

];

% ilk should be 1, 7 ,11
 for ilk = 7 : 7

     j_max = floor(basal(basal(:,1)==ilk,2)*1/stim_step(ilk)); % 0.5 ms 
     spike_base = basal(basal(:,1)==ilk,3);
     jind = round(jind_ph(2,:)*basal(basal(:,1)==ilk,2)/stim_step(ilk));

     str = num2str(ilk,formatSpec);
     cup = [];
     cun = [];
     k = 1;
      for j = jind
        str2 = num2str(j,formatSpec);
        fileName = ['./curr/spike_times_' str '_' str2 '.dat'];
        rec = dlmread(fileName);
        v = rec(1:N_dim);
        av = rec(N_dim*3+1:N_dim*4);
        narsg = rec(N_dim*4+1:N_dim*5);
        nap = rec(N_dim*5+1:N_dim*6);
        sk2 = rec(N_dim*6+1:N_dim*7);
        bkf = rec(N_dim*7+1:N_dim*8);
        bks = rec(N_dim*8+1:N_dim*9);
        cap = rec(N_dim*9+1:N_dim*10);
        ih = rec(N_dim*10+1:N_dim*11);
        kv3 = rec(N_dim*11+1:N_dim*12);
        
        [pks,locs] = findpeaks(v,'MinPeakHeight',-10);
        a = t(locs)<(spike_base-5);
        b = locs(a);
        isi = t(b(end))-t(b(end-1));
        cbas_na = narsg(round(b(end)+j*stim_step(ilk)/dt));
        cbas_nap = nap(round(b(end)+j*stim_step(ilk)/dt));
        cbas_cap = cap(round(b(end)+j*stim_step(ilk)/dt));
        
        cbas_kv3 = kv3(round(b(end)+j*stim_step(ilk)/dt));
        cbas_sk2 = sk2(round(b(end)+j*stim_step(ilk)/dt));
        cbas_bkf = bkf(round(b(end)+j*stim_step(ilk)/dt));
        cbas_bks = bks(round(b(end)+j*stim_step(ilk)/dt));
        
        % find the stimulus timing and end of the stimulus
        
        cup = [cup;narsg+nap+cap];
        cun = [cun;kv3+sk2+bks+bkf];
        
        figure('Units','inches',...
'Position',[10 5 width height],...
'PaperPositionMode','auto');
        plot((t-t(b(end-1))-2*isi),narsg+nap+cap - cbas_na-cbas_nap-cbas_cap,(t-t(b(end-1))-2*isi),kv3+sk2+bks+bkf- cbas_kv3-cbas_sk2-cbas_bkf-cbas_bks,'linewidth',1);
        ylim([-10e-3 5e-3])
        xlim([jind_ph(2,k)*isi-0.1 jind_ph(2,k)*isi+0.6]);

        k = k+1
        end
 end
