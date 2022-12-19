close all;clear all;clc;

P   = dir ('prc_inj*');
v_thre_a = {};
v_thre_av = [];
v_inter = {};
fr = [];
v_ms = [];
v_m = [];
dis = [];
pha_na_av = [];

width = 4; height = 2;
h =figure('Units','inches',...
'Position',[10 5 width height],...
'PaperPositionMode','auto');

h2 =figure('Units','inches',...
'Position',[20 4 2 2],...
'PaperPositionMode','auto');

load prc_th;
load v_th;
v_spk = [];
phase_f = [];

for i =1:length(P)-1
    d = dlmread(P(i).name);
    t = 0:0.02:1000;      %0-900ms
    t =t';
    v = d(2:end,1);
    dv = diff(v)./diff(t);
    dv = [0;dv];
    tf = t(t<700&t>200);
    vf = v(t<700&t>200);
    [pksf,locsf] = findpeaks(vf,'MinPeakHeight',-12);
    fr = [fr;length(locsf)*2];
    tn = t(t<700&t>400);
    vn = v(t<700&t>400);
    dvn = dv(t<700&t>400);
    [pks,locs] = findpeaks(vn,'MinPeakHeight',-12);
    v_thre = [];
    v_ms = [];
    pha_na = [];
    for j =2:length(locs)
        isi = tn(locs(j))-tn(locs(j-1));
        isi_num = isi/0.02-50;
        tn1 = tn(locs(j)-isi_num:locs(j)-1);
        dvn1 = dvn(locs(j)-isi_num:locs(j)-1);
        vn1 = vn(locs(j)-isi_num:locs(j)-1);
         tn2 = tn(locs(j)-20:locs(j)-1);
        dvn2 = dvn(locs(j)-20:locs(j)-1);
        vn2 = vn(locs(j)-20:locs(j)-1);
        tn3 = tn(locs(j)-isi_num:locs(j)-20);
        vn3 = vn(locs(j)-isi_num:locs(j)-20);
        [b,n] = min(abs(dvn2-40));
        v_thre = [v_thre; vn2(n)];
        [tna,nna] = min(abs(vn1+55));
        pha_na = [pha_na;(tn1(nna)-tn(locs(j-1)))/isi];
        figure(h)
        scatter((tn2(n)-tn(locs(j-1)))/isi+(i-1),vn2(n),75,'MarkerEdgeColor','k');
        hold on
        plot((tn1-tn(locs(j-1)))/isi+(i-1),vn1,'Color','k','Linewidth',1);
        v_ms = [v_ms;mean(vn3)];
    end
    pha_na_av = [pha_na_av; mean(pha_na)];
    v_inter{i}=[(tn1-tn(locs(j-1)))/isi+(i-1) vn1];

    phase_f = [phase_f;phase_threshold((i-1)*2+1)+(i-1)];
    
    v_m = [v_m;mean(v_ms)];
    
    plot([i-0.2,i+0.2],[mean(v_thre) mean(v_thre)],'Color','k','Linewidth',1);
    text(i+0.1,mean(v_thre)+4,num2str(round(mean(v_thre),1)),'Color','k','FontSize',10);
    text(0.2,-50+(i-1)*6,num2str(ceil(fr(i))),'Color','k','FontSize',10);

    dis = [dis;[fr(i) mean(v_thre)-mean(v_ms)]];
    v_thre_av = [v_thre_av;mean(v_thre)];
    v_thre_a{i,1} = v_thre;
    v_spk = [v_spk;mean(v_thre)];
end
figure(h);
plot([0.5 6.5],[-55 -55],'k:','Linewidth',1);

ssa = dlmread('ssa_soma_h.dat');
ssi = dlmread('ssi_soma_h.dat');
figure(h);
v_range = [];


for i =1:length(P)-1
    ss_dat = v_inter{1,i}(:,2);
    v_dat = v_inter{1,i}(:,1);
    ind = (ss_dat<v_th(1+2*(i-1)));
    vq1 = interp1(ssa(:,1),ssa(:,2),ss_dat(ind));
    v_range = [v_range;min(ss_dat(ind)) max(ss_dat(ind))];
    v_p = min(ss_dat(ind)):0.1: max(ss_dat(ind));
    ss_p = interp1(ssa(:,1),ssa(:,2),v_p);


end

%%
fr = ceil(fr);
fr_lab = num2str(fr);
set(gca,...
'Units','normalized',...
'FontUnits','points',...
'FontWeight','normal',...
'FontSize',12,...
'FontName','Helvetica',...
'xtick',[],...
'ytick',-60:20:0,...
'Linewidth',1);
xlim([0 7]);
ylim([-70 0]);
ylabel('Vm (mV)','FontSize',10);

legend('off');
ax.XRuler.Axle.LineWidth = 2;
hAxes = gca;
hAxes.XRuler.Axle.LineStyle = 'none';

figure(h2);
bar(pha_na_av);
