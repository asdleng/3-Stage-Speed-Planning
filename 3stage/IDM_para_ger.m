function [amax,dmax,pre_see_distance,vmax] = IDM_para_ger(scenario_num)
amax = 3;
dmax = 100;
pre_see_distance = 200;


switch(scenario_num)
    case 1
        vmax=49.38/3.6;%场景1
    case 2
        vmax = 53.2/3.6;%场景2
    case 3
        vmax=55/3.6;%场景3
    case 4
        vmax=52/3.6;%场景4
    case 5
        vmax = 61/3.6;%场景5
    case 6
        vmax = 55/3.6;%场景6
end

end

