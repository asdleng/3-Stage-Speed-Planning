function [y,p3,v3] = IDM(SPaT,amax,dmax,vmax,pre_see_distance,vis_flag)
t=0;
x=zeros(2,1);
maxinter = 5000;
count = 0;
while x(2) < SPaT{1}(end)-5
    t=t+1;
    y(1,t) = x(1);
    y(2,t) = x(2);
    
    for i = 1:length(SPaT{1})
        if x(2)<SPaT{1}(i)
            pi_tra = i;
            break;
        end
    end
    Dsf = SPaT{1}(pi_tra)-x(2);
    if(pi_tra<length(SPaT{1}))
        Stss = mod(t+SPaT{4}(pi_tra),SPaT{2}(pi_tra))<SPaT{3}(pi_tra);
    end
    if (Stss&&Dsf<pre_see_distance)||(i==length(SPaT{1})&&Dsf<pre_see_distance)
        a = - x(1)^2/(Dsf-0.01);
    else
        a = amax*(1-(x(1)/vmax)^4);
    end
    a(a>amax) = amax;
    a(a<-dmax) = -dmax;
    y(3,t) = a;
    x(1) = x(1)+a;
    x(2) = x(2)+x(1);
    count = count+1;
    if count>maxinter
        break;
    end
end
p3 = [];
v3 = [];
if vis_flag
    figure(1)
    p3 = plot(y(2,:),'Color',[24,7,43]/100,'LineWidth',1.0);
    hold on;
    figure(4)
    v3 = plot(y(2,:),y(1,:),'Color',[24,7,43]/100,'LineWidth',1.5);
    hold on;
end
end