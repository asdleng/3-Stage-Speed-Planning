function [s_x0,s_y0,p0,v0] = random_scat(ST,ar_t,cost,vis_flag)
if vis_flag
    k=ar_t/ST{1}(end);
    %画红绿灯
    p{1,1}= plot(0,0,'*k');%起点
    hold on;
    p{1,2}= plot(ar_t,ST{1}(end),'*k');%终点
    for i=1:length(ST{1})-1
        for k=1:20
            p{1,3} = plot([ST{2}(i)*(k-1)-ST{4}(i),ST{3}(i)-ST{4}(i)+ST{2}(i)*(k-1)],[ST{1}(i),ST{1}(i)],'-r','linewidth',2);
            hold on;
        end
    end
    ylabel('Distance (m)','FontSize',12,'FontName','宋体');
    xlabel('Time (s)','FontSize',12,'FontName','宋体');
    axis([0 ar_t+50 0 ST{1}(end)]);

end
%%正态分布撒点
%K=0.01;
K=0.015;
%K=0.020;

dis_A=sqrt((ar_t^2)+(ST{1}(end)^2));%距离
alpha=atan(ST{1}(end)/ar_t);%角度
x=0;
k=0;
dis_start_stop = 200;%预留起步-停止距离
dis_gap = 200; %撒点 (距离^2+时间^2)^0.5 间隔
%carla仿真场景需要
% dis_start_stop = 50;%预留起步-停止距离
% dis_gap = 50; %撒点 (距离^2+时间^2)^0.5 间隔
i = dis_start_stop;
while(i<dis_A-dis_start_stop)
    x = x+1;
    for j=1:70
        y(x,j)=myfun(i,K,dis_A,j);
        k=k+1;
        [x0(x,j),y0(x,j)] = transform(i,y(x,j),alpha);
        if vis_flag
            p{1,4}=plot(x0(x,j),y0(x,j),'.k','Markersize',3);%撒点
        end
        hold on;
    end
    i = i+dis_gap;
end
%%构造权重
% tic;
A = ones(size(x0,1)*size(x0,2)+2)-eye(size(x0,1)*size(x0,2)+2);
A(A==1)=inf;
mm=0;
for j=1:size(x0,2)
    mm=mm+1;
    v0=y0(1,j)/x0(1,j);%第一阶段的速度
    s=y0(1,j);%路程
    [A,B]=passIntersection(0,0,x0(1,j),y0(1,j),ST{1});
    if(A)
        if(IsCross(0,0,x0(1,j),y0(1,j),B,ST))
            wm=Inf;
        else
            wm=interp1(0:30,cost,v0)*s;
        end
    else
        wm=interp1(0:30,cost,v0)*s;
    end
    %     wm=interp1(0:30,cost,v0)*s;%油耗
    %     A(1,j+1) = wm;
    u(mm)=1;
    v(mm)=j+1;
    w(mm)=wm;
end

for i=1:(size(x0,1)-1)%每一个阶段
    for j=1:size(x0,2)
        for k=1:size(x0,2)
            mm=mm+1;
            v0=(y0(i+1,k)-y0(i,j))/(x0(i+1,k)-x0(i,j));
            s=y0(i+1,k)-y0(i,j);
            [A,B]=passIntersection(x0(i,j),y0(i,j),x0(i+1,k),y0(i+1,k),ST{1});
            if(A)
                if(IsCross(x0(i,j),y0(i,j),x0(i+1,k),y0(i+1,k),B,ST))
                    wm=Inf;
                else
                    wm=interp1(0:30,cost,v0)*s;
                end
            else
                wm=interp1(0:30,cost,v0)*s;
            end
            %             wm=interp1(0:30,cost,v0)*s;
            %             A((i-1)*size(x0,2)+j+1,i*size(x0,2)+j+1)=wm;
            u(mm)=(i-1)*size(x0,2)+j+1;
            v(mm)=i*size(x0,2)+k+1;
            w(mm)=wm;
        end
    end
end
for j=1:size(x0,2)%最后一个阶段
    mm=mm+1;%边
    v0=(ST{1}(end)-y0(end,j))/(ar_t-x0(end,j));
    s=ST{1}(end)-y0(end,j);
    [A,B]=passIntersection(x0(end,j),y0(end,j),ar_t,ST{1},ST{1});
    if(A)
        if(IsCross(x0(end,j),y0(end,j),ar_t,ST{1},B,ST))
            wm=Inf;
        else
            wm=interp1(0:30,cost,v0)*s;
        end
    else
        wm=interp1(0:30,cost,v0)*s;
    end
    %     wm=interp1(0:30,cost,v0)*s;
    %     A((size(x0,1)-1)*size(x0,2)+j+1,size(x0,1)*size(x0,2)+1+1)=wm;
    u(mm)=(size(x0,1)-1)*size(x0,2)+j+1;
    v(mm)=size(x0,1)*size(x0,2)+1+1;
    w(mm)=wm;
end

xlim([0,ar_t+50]);
ylim([0,ST{1}(end)]);
%%寻找路径
% tic;
w(isnan(w))=Inf;
G = digraph(u,v,w);
%%第几阶段的第几个序号
disp("1阶段耗时");
tic;
[P,d] = shortestpath(G,1,size(x0,1)*size(x0,2)+2);
toc;
s_x0 = [0];s_y0 = [0];
for i=2:(size(x0,1)+1)
    k=floor((P(i)-1)/size(x0,2))+1;%第几阶段
    kk=mod((P(i)-1),size(x0,2));%第几个序号
    if(kk==0)
        k=k-1;
        kk=size(x0,2);
    end
    s_x0 = [s_x0,x0(k,kk)];
    s_y0 = [s_y0,y0(k,kk)];
end
s_x0 = [s_x0,ar_t];
s_y0 = [s_y0,ST{1}(end)];
v_0 = [diff(s_y0)./diff(s_x0),0];
p0 = [];
v0 = [];
if vis_flag
    p0 = plot(s_x0,s_y0,'Color',[19,59,64]/100,'LineWidth',1.0);
    figure(4)
    v0 = plot(s_y0,v_0,'Color',[19,59,64]/100,'LineWidth',1.5);
    xlabel('Distance (m)','FontSize',12);
    ylabel('Speed (m/s)','FontSize',12);
    ylim([0,20]);
    hold on;
    figure(1)
end   
end

function f=myfun(x,K,dis_A,j)
if x<=(dis_A/2)
    f=K*x*randn(1);
end
if x>(dis_A/2)
    f=(-K*x+dis_A*K)*randn(1);
end
end
function [x1,y1] = transform(x,y,alpha)
x1=x*cos(alpha)-y*sin(alpha);
y1=x*sin(alpha)+y*cos(alpha);
end
%%判断是否过红绿灯
function [res1,res2]=passIntersection(x1,y1,x2,y2,Int)
res1=false;res2=0;
for i=1:length(Int)
    if (y2>Int(i)&y1<Int(i))
        res1=true;res2=i;
        break;
    end
end
end
function [res]=IsCross(x1,y1,x2,y2,ind,SPaT)
res=false;
for i=1:20
    x3=SPaT{2}(ind)*(i-1)-SPaT{4}(ind);
    x4=SPaT{3}(ind)-SPaT{4}(ind)+SPaT{2}(ind)*(i-1);
    y3=SPaT{1}(ind);
    y4=y3;
    x=x1+(y3-y1)/(y2-y1)*(x2-x1);
    if(x>x3&x<x4)
        res=true;
        break;
    end
end
end
