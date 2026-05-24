clc; clear;

opts = struct();
opts.PopulationSize = 1000;
opts.MaxGenerations = 10;
opts.UseParallel = true;
% opts.UseParallel = false;

% 可选：自定义目标点
% opts.tar.POS_e = [0.8 0.1 0.3]';
% opts.tar.ORI_e = cy(pi/3);

tic;
result = solve_MOEA_robot(opts);
toc;

disp('Pareto fval = [-w_goal, sig_goal, num_goal]:');
disp(result.fval);

plot_pareto(fval_all);
