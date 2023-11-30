function [asd_s_1,p1,v1] = Bspline_smooth(s_x0,s_y0,ar_t,vis_flag)
%B样条曲线轨迹平滑
x = [-1,s_x0,s_x0(end)+1];
y = [0,s_y0,s_y0(end)];
w = ones(1,2+size(s_x0,2)); w([1 end]) = 100;

degree = 3; % Degree of the spline (cubic spline)
numKnots = 10; % Number of knots

% Create a knot vector
knots = augknt(linspace(min(x), max(x), numKnots), degree);

% Fit a B-spline to the data
%sp = spap2(knots, degree, x, y);
sp = spaps(x,y, 1.e-2, w, 3);%toc;

dt = 1;
asd_s_1= fnval(sp,0:dt:ar_t);
v = [diff(asd_s_1),0];
p1 = [];
if vis_flag
    figure(1)
    p1 = plot(0:dt:ar_t,asd_s_1,'Color',[0,67,20]/100,'LineWidth',1.0);
    figure(4)
    v1 = plot(asd_s_1,v,'Color',[0,67,20]/100,'LineWidth',1.5);
    figure(1)
end

end

