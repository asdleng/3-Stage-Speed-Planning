close all;clc;clear;
%load('fittedmodel.mat');
load('motorfit.mat');
load('ele_para.mat');

traneff=0.95;
mf = motorfit;
%gg = interp1(1:length(g),g,x.x);
gg=0;
veh_trans = par.fdg;
v=0:30;
Fr = (par.Cr1+par.Cr2.*v).* par.mas .* par.gav .* cos(gg);
Fa = 0.5 .* par.ACd .* par.rho .* v.^2;
Fg = par.mas .* par.gav .* sin(gg);
T = (Fr+Fa+Fg)/traneff.*par.wlr/veh_trans;
mot_spd = v / par.wlr .* veh_trans;
 eff = (mf.p00 + mf.p10.*mot_spd + mf.p01.*T + mf.p20.*mot_spd.^2 + mf.p11.*mot_spd.*T + mf.p02.*T.^2 + mf.p30.*mot_spd.^3 + mf.p21.*mot_spd.^2.*T + mf.p12.*mot_spd.*T.^2 + mf.p03.*T.^3);
cost = (Fr+Fa+Fg)./eff./par.Discharge_eff;
plot(cost,'-r','LineWidth',1.5);
xlabel('Cruise Speed (m/s)','FontSize',9,'FontName','Times New Roman');
ylabel('Energy Cost per meter(J/m)','FontSize',9,'FontName','Times New Roman');
grid on;
set(gca,'FontSize',9,'FontWeight','bold',...     %18字体缩小1/2比较哒5号字
    'fontname','Times New Roman','LineWidth',1,'gridalpha',0.50,...
    'gridlinestyle','--');
set(gcf,'unit','centimeters', 'position',[12,5,14,8.6]); % positon(1)(2)绘图窗口显示位置;pos(3)(4),窗口长宽值
save cost cost;