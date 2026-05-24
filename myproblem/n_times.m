clc; clear;

% --------- 配置参数 ----------
opts = struct();
opts.PopulationSize = 1000;
opts.MaxGenerations = 20;
opts.UseParallel = true;

% 可选：自定义目标点
% opts.tar.POS_e = [0.8 0.1 0.3]';
% opts.tar.ORI_e = cy(pi/3);

nRuns = 40;
dataFolder = fullfile(pwd, 'data');  % 使用绝对路径

% 创建文件夹（如果不存在）
if ~exist(dataFolder, 'dir')
    mkdir(dataFolder);
end

result_all = [];
% --------- 循环运行 ----------
for runIdx = 22:nRuns
    fprintf('Running iteration %d / %d...\n', runIdx, nRuns);

    tic;
    result = solve_MOEA_robot(opts);
    elapsedTime = toc;

    result_all = [result_all; result.fval];

    fprintf('Iteration %d finished in %.2f seconds.\n', runIdx, elapsedTime);

    % 保存每次运行结果
    saveFile = fullfile(dataFolder, sprintf('result_run_%d.mat', runIdx));
    save(saveFile, 'result');
end

% 保存全部结果
saveFileAll = fullfile(dataFolder, 'result_all.mat');
save(saveFileAll, 'result_all');

plot_pareto(result_all)

disp('All runs completed and saved in the data folder.');
