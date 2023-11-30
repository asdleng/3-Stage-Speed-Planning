clc;clear;close all;
threestageres = csvread("3stage\3stage_res.csv");
threestagetime = csvread("3stage\3stage_time.csv");
DPres = csvread("DP\DP_res.csv");
DPtime = csvread("DP\DP_time.csv");

threestageres = prepare(threestageres);
threestagetime = prepare(threestagetime);
DPres = prepare(DPres);
DPtime = prepare(DPtime);

threestagetime = log10(threestagetime);
DPtime = log10(DPtime);

plot(DPtime,DPres,'.','Markersize',15,'Color',[0.00,0.63,0.95]);
hold on;
plot(threestagetime,threestageres,'.','Markersize',15,'Color',[94,39,29]/100);

function res = prepare(raw)
res = raw(:,2:end);
res(res==0) = NaN;
res = mean(res,2,'omitnan');
end
