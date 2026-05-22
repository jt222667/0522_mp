%% 随机生成一个合法构型（通过 expand_module_units 检验）
% 输出:
%   n            : 原始模块数量（4~10）
%   module_raw   : 1x13，前 n 位为随机模块ID，后续补 0
%   install_raw  : 1x13，全 1
%   align_raw    : 1x13，全 0
%   sequence_raw : 1x13，[0 1:12]
%
% 输入:
%   RP_data      : 模块库数据（包含 integrated_modules 等字段）
%   iter_max     : 最大迭代次数（可选，默认 1000）

function [n, module_raw, install_raw, align_raw, sequence_raw] = generate_valid_config_x(RP_data, iter_max)

if nargin < 2 || isempty(iter_max)
    iter_max = 1000;
end

is_found = false;

for iter = 1:iter_max
    %% 第一步：随机生成 mo, is, al, se
    n  = randi([4, 10]);
    mo = randi([1, 10], 1, n);
    is = ones(1, n);
    al = zeros(1, n);
    se = [0, 1:n-1];

    %% 第二步：用 expand_module_units 检验合法性
    [~, ~, ~, ~, ~, is_valid, ~] = expand_module_units(mo, is, al, se, RP_data);

    %% 第三步：合法则输出；不合法继续迭代
    if is_valid
        module_raw   = [mo, zeros(1, 13-n)];
        install_raw  = ones(1, 13);
        align_raw    = zeros(1, 13);
        sequence_raw = [0, 1:12];

        is_found = true;
        break;
    end
end

if ~is_found
    error('generate_random_valid_config:MaxIterReached', ...
        '在 iter_max=%d 次迭代内未找到合法构型。', iter_max);
end

end
