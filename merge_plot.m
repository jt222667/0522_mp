%% 3d pareto合并

clc;clear;

i = 3;

msg = sprintf('F:\\Archive 归档\\0522_mp\\data\\result_run_%d.mat',i);
load(msg);
P_final = result.fval;

for j = 1:21
    if j ~= i
        msg = sprintf('F:\\Archive 归档\\0522_mp\\data\\result_run_%d.mat',j);
        load(msg);
        P_final = merge_pareto_incremental(P_final, result.fval);
    end
end

% plot_pareto_smooth(P_final);

plot_fitted_surface(P_final)
