function [prb,TrLig] = ST2prb(ST)
TrLig = ST{1};
Distn = ST{1}(end);
prb.Ts = 1;  % one meter (distance) per step
prb.N  = Distn/prb.Ts;        prb.N0 = 1;
prb.W{1} = zeros(1,Distn); 
prb.W{2} = zeros(1,Distn);
prb.W{3} = ones(1,Distn);
prb.W{4} = zeros(1,Distn);
prb.W{2}(1,1:TrLig(end)) = 30;
for i = 1:length(TrLig)-1
    prb.W{1}(1,TrLig(i)) = 1;
    prb.W{2}(1,TrLig(i)) = ST{2}(i);
    prb.W{3}(1,TrLig(i)) = ST{3}(i);
    prb.W{4}(1,TrLig(i)) = ST{4}(i);
end
prb.W{1}(1,TrLig(end)) = 2;   % type
end

