clc; clear;

opts = struct();
opts.PopulationSize = 100;
opts.MaxGenerations = 100;
opts.UseParallel = true;

% 可选：自定义目标点
% opts.tar.POS_e = [0.8 0.1 0.3]';
% opts.tar.ORI_e = cy(pi/3);

result = solve_MOEA_robot(opts);

% disp('Pareto fval = [-w_goal, sig_goal, num_goal]:');
% disp(result.fval);
% 
% plot_pareto(result.fvall);

RWGsigeXUs8eGS7egXSa
