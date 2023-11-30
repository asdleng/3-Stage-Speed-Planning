clc;clear;close all;
load('ele_para.mat')
load('motorfit.mat')
load('cost.mat')
%maxspeed = ones(1,length(ST{1}))*100/3.6;
scenario = 1;
ST = scenario_generator(scenario);
ar_t = ST{1}(end)/10; % 到达时间
figure(1)
%% 随机撒点
[t0,s0,p0,v0] = random_scat(ST,ar_t,cost,true);
s0_1 = interp1(t0,s0,0:ar_t);
[e0,valid] = energy_eval(s0_1',false);
if(valid)
    disp("1阶段能耗为 "+num2str(e0/1000)+"kJ")
else
    disp("1阶段违反约束")
end

%% 轨迹平滑
disp("2阶段耗时")
tic;
[s1,p1,v1] = Bspline_smooth(t0,s0,ar_t,true);
toc;
[e1,valid] = energy_eval(s1',false);
if(valid)
    disp("2阶段能耗为 "+num2str(e1/1000)+"kJ")
else
    disp("2阶段违反约束")
end
%% 内点法优化
tic;
[opt_s,opt_v,opt_a,opt_mot_spd,opt_T,opti_energy,p2,v2] = optimize_trajectory(s1',ST,par,true);
t = toc;
[e2,valid] = energy_eval(opt_s',true);
e2 = e2/1000;
if(valid)
    disp("3阶段能耗为 "+num2str(e2)+"kJ")
else
    disp("3阶段违反约束")
end
write2csv('D:\3stageworkspace\3stage\3stage_res.csv',scenario,e2);
write2csv('D:\3stageworkspace\3stage\3stage_time.csv',scenario,t);
%% IDM baseline
[amax,dmax,pre_see_distance,vmax] = IDM_para_ger(scenario);
tic;
[yIDM,p3,v3] = IDM(ST,amax,dmax,vmax,pre_see_distance,true);
toc;
[e3,valid] = energy_eval(yIDM(2,:)',false);
if(valid)
    disp("IDM能耗为 "+num2str(e3/1000)+"kJ")
else
    disp("IDM违反约束")
end

%% DP Baseline
dp_file = "DP_res_"+num2str(scenario);
load(dp_file)
figure(1)
p4 = plot(res.X{2},0:length(res.X{2})-1,'Color',[0.00,0.63,0.95],'LineWidth',1.0);
figure(4)
v4 = plot(0:length(res.X{2})-1,res.X{1},'Color',[0.00,0.63,0.95],'LineWidth',1.5);
%% 增加图例
figure(1)
legend([p0,p1,p2,p3,p4],'1-Random Scattering','2-Bspline Smoothing','3-Optimization','IDM','DP','location','northwest','box','on');
grid on;
set(gca,'FontSize',9,'FontWeight','bold',...     %18字体缩小1/2比较哒5号字
    'fontname','Times New Roman','LineWidth',1,'gridalpha',0.20,...
    'gridlinestyle','--');
set(gcf,'unit','centimeters', 'position',[12,5,14,8.6]); % positon(1)(2)绘图窗口显示位置;pos(3)(4),窗口长宽值
figure(4)
legend([v0,v1,v2,v3,v4],'1-Random Scattering','2-Bspline Smoothing','3-Optimization','IDM','DP','location','northwest','box','on');
grid on;
set(gca,'FontSize',9,'FontWeight','bold',...     %18字体缩小1/2比较哒5号字
    'fontname','Times New Roman','LineWidth',1,'gridalpha',0.20,...
    'gridlinestyle','--');
set(gcf,'unit','centimeters', 'position',[12,5,14,8.6]); % positon(1)(2)绘图窗口显示位置;pos(3)(4),窗口长宽值
%%
csvwrite(['D:\3stageworkspace\3stage\dataforlanechange\distance',num2str(scenario),'.csv'],opt_s');
csvwrite(['D:\3stageworkspace\3stage\dataforlanechange\speed',num2str(scenario),'.csv'],[diff(opt_s');0]);
csvwrite(['D:\3stageworkspace\3stage\dataforlanechange\idm_distance',num2str(scenario),'.csv'],yIDM(2,:)');
csvwrite(['D:\3stageworkspace\3stage\dataforlanechange\idm_speed',num2str(scenario),'.csv'],[yIDM(1,2:end)';0]);
csvwrite(['D:\3stageworkspace\3stage\dataforlanechange\intersections',num2str(scenario),'.csv'],ST{1}');