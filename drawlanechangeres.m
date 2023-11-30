clc;clear;close all;
density = 1.4;

if density == 1.0
rlmpc = [74.2755,78.5448,79.5654,82.6765,73.6526,84.2024,77.81953;
    2.49,2.59,2.77,2.35,3.23,1.57,2.5;
    0.85,0.82,1.1,0.7,1.18,0.69,0.89;
    1,2,1,2,2,2,1.66666666666667];
mobilidm = [89.4744,91.882,93.7635,102.5686,96.0783,103.5251,96.2153166666667;
    3.37,2.85,3.06,3,3.27,2.71,3.04333333333333;
    1.08,0.94,1.07,0.99,1.21,2.71,1.33333333333333;
    7,7,6,7,6,6,6.5];
elseif density == 1.2
rlmpc = [63.3919,80.4599,73.6337,80.6356,78.1747,87.8737,77.3615833333333;
    3.59,3.02,3.36,2.51,3.76,2.43,3.11166666666667;
    1.1,0.99,1.31,0.83,1.39,1.07,1.115;
    1,2,1,2,1,2,1.5];
mobilidm = [87.5305,95.5022,85.5097,101.5455,98.5442,107.5754,96.0345833333333;
    4.24,3.69,3.3,3.36,4.09,3.38,3.67666666666667;
    1.29,1.23,1.36,1.15,1.51,1.44,1.33;
    4,6,5,4,4,4,4.5;
    ];
elseif density == 1.4
rlmpc = [76.1452,82.239,77.0972,94.3482,73.7653,80.2348,80.6382833333333;
    5.23,3.69,5.1,4,5.29,3.98,4.54833333333333;
    1.53,1.22,1.62,1.38,1.75,1.47,1.495;
    1,2,1,1,1,1,1.16666666666667];
mobilidm = [80.7134,93.7344,83.8139,99.7448,94.8612,106.5702,93.23965;
    5.6,5.16,4.64,4.31,5.21,5.15,5.01166666666667;
    1.61,1.51,1.8,1.39,1.82,1.93,1.67666666666667;
    5,5,4,6,6,7,5.5];
end
planned = [59.2213,72.6467,74.1778,79.8593,76.997,89.4475,75.3916];
figure
b = bar(1:6,10*[planned(1,1:6);rlmpc(1,1:6);mobilidm(1,1:6)],'FaceColor','flat');
b(1).CData = [0,0,1];
b(2).CData = [0,1,0];
b(3).CData = [1,0,0];
hold on;
for i = 1:3
xtips2 = b(i).XEndPoints;
ytips2 = b(i).YEndPoints;
labels2 = string(round(b(i).YData,0));
text(xtips2,ytips2,labels2,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom','Fontname', 'Times New Roman','FontSize',9)
end
hl = legend('Planned','RL+MPC','MOBIL+IDM','location','NorthWest');
set(hl,'box','off');
ylabel('Energy Cost (KJ)','Fontname', 'Times New Roman','FontSize',12);
xlabel('Scenario','Fontname', 'Times New Roman','FontSize',12);
grid on;
set(gca,'FontSize',9,'FontWeight','bold',...     %18字体缩小1/2比较哒5号字
    'fontname','Times New Roman','LineWidth',1,'gridalpha',0.20,...
    'gridlinestyle','--');
set(gcf,'unit','centimeters', 'position',[12,5,20,8.6]); % positon(1)(2)绘图窗口显示位置;pos(3)(4),窗口长宽值

figure
b2 = bar(1:6,1*[rlmpc(2,1:6);mobilidm(2,1:6)],'FaceColor','flat');
ylim([0,10])
b2(1).CData = [0,1,0];
b2(2).CData = [1,0,0];
hold on;
for i = 1:3
xtips2 = b(i).XEndPoints;
ytips2 = b(i).YEndPoints;
labels2 = string(round(b(i).YData,0));
text(xtips2,ytips2,labels2,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom','Fontname', 'Times New Roman','FontSize',9)
end
h2 = legend('RL+MPC','MOBIL+IDM','location','NorthWest');
set(h2,'box','off');
ylabel('Time Delay (s)','Fontname', 'Times New Roman','FontSize',12);
xlabel('Scenario','Fontname', 'Times New Roman','FontSize',12);
grid on;
set(gca,'FontSize',9,'FontWeight','bold',...     %18字体缩小1/2比较哒5号字
    'fontname','Times New Roman','LineWidth',1,'gridalpha',0.20,...
    'gridlinestyle','--');
set(gcf,'unit','centimeters', 'position',[12,5,20,8.6]); % positon(1)(2)绘图窗口显示位置;pos(3)(4),窗口长宽值

% figure
% b = bar(1:6,[rlmpc(2,1:6);mobilidm(2,1:6)],'FaceColor','flat');