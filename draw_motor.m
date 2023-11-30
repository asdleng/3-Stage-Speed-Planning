function p = draw_motor(par,mot_spd,mot_tqr,num,color)
if ~ishandle (num)
    figure(num)
    par.Mot_map(par.Mot_map==0) = NaN;
    contour(par.Mot_Sindx,par.Mot_Tindx,par.Mot_map,'LineWidth',1.5,'Fill','off');
    hold on;
    contour(par.Mot_Sindx,-par.Mot_Tindx,par.Mot_map,'LineWidth',1.5,'Fill','off');
    plot(par.Mot_Sindx,par.Mot_maxtq,'-k','LineWidth',1.5);hold on;
    plot(par.Mot_Sindx,-par.Mot_maxtq,'-k','LineWidth',1.5);hold on;
end
figure(num)
p = plot(mot_spd,mot_tqr,'.','Markersize',5,'Color',color);
hold on;
xlabel('Motor Speed (rad/s)');
ylabel('Motor Torque (Nm)');
set(gca,'FontSize',9,'FontWeight','bold',...     %18字体缩小1/2比较哒5号字
    'fontname','Times New Roman','LineWidth',1,'gridalpha',0.20,...
    'gridlinestyle','--');
set(gcf,'unit','centimeters', 'position',[12,5,14,8.6]); % positon(1)(2)绘图窗口显示位置;pos(3)(4),窗口长宽值
end

