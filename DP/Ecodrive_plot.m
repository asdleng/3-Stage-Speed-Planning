lw1 = 1.5;  lw2 = 1.5;

figure(1)
subplot(321)
plot(0:length(res.X{1})-1,res.X{1},'b-','linewidth',1); grid on
%axis([0 prb.N 0 max(res.X{1})+2])
xlabel('Distance (m)'); ylabel('Speed (m/s)')

subplot(322)
plot(0:length(res.mot_trq)-1,res.mot_trq,'b-', 'linewidth',1);   hold on
grid on
xlabel('Distance (m)'); ylabel('Motor torque (Nm)')

subplot(323)
plot(0:length(res.X{1})-1,res.X{2},'b-','linewidth',1); hold on
for i=1:(length(TrLig)*1)
    for j=1:length(TrLig)*2
    plot([TrLig(1,i) TrLig(1,i)],[prb.W{2}(1,TrLig(1,i))*(j-1)-prb.W{4}(1,TrLig(1,i)) prb.W{3}(1,TrLig(1,i))-prb.W{4}(1,TrLig(1,i))+prb.W{2}(1,TrLig(1,i))*(j-1)],'r-','linewidth',lw1); 
    end
end
axis([0 prb.N 0 max(res.X{2})+10]); grid on; hold off
xlabel('Distance (m)'); ylabel('Time (s)')

subplot(324)
plot(0:length(res.mot_spd)-1,res.mot_spd,'b-','linewidth',1); hold on
hold off
axis([0 prb.N 0 max(res.mot_spd)+0.05]); grid on
xlabel('Distance (m)')
ylabel('Motor speed (rad/s)')

subplot(325)
plot(res.X{2},res.X{1},'b-','linewidth',1)
axis([0 max(res.X{2}) 0 max(res.X{1})+2]); grid on
xlabel('Time (s)'); ylabel('Speed (m/s)')

subplot(326)
plot(res.veh_acc,'b-','linewidth',1)
axis([0 prb.N min(res.veh_acc)-1 max(res.veh_acc)+1]); grid on
xlabel('Distance (m)'); ylabel('Acceleration (m/s^2)')

