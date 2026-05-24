function P_final = merge_pareto_incremental(P1, P2)

% =========================================================
% P1 : 原始Pareto集合（基准）
% P2 : 待加入数据
%
% 规则：
% 1. 按第三维 z 从小到大处理P2
% 2. 新点加入后：
%       Pareto点数必须 +1
% 3. 否则拒绝加入
%
% 输出：
% P_final : 合并后的Pareto集合
% =========================================================

clc;

% ====== 按第三维排序 ======
P2 = sortrows(P2,3);

% ====== 初始集合 ======
P_current = P1;

fprintf('初始Pareto点数量: %d\n', size(P_current,1));

% =========================================================
% 逐点尝试加入
% =========================================================
for i = 1:size(P2,1)

    candidate = P2(i,:);

    % ===== 当前Pareto数量 =====
    old_count = size(P_current,1);

    % ===== 临时加入 =====
    P_temp = [P_current; candidate];

    % ===== 重新计算Pareto =====
    idx = pareto_filter(P_temp);

    P_new = P_temp(idx,:);

    new_count = size(P_new,1);

    % =====================================================
    % 规则：
    % Pareto数量必须 +1
    % =====================================================
    if new_count == old_count + 1

        P_current = P_new;

        fprintf('加入成功 [%3d/%3d]   当前数量: %d\n', ...
            i, size(P2,1), new_count);

    else

        fprintf('拒绝加入 [%3d/%3d]\n', ...
            i, size(P2,1));

    end

end

P_final = P_current;

fprintf('\n最终Pareto点数量: %d\n', size(P_final,1));

end

% =========================================================
% Pareto非支配筛选
%
% 默认：
% 三个目标全部最小化
%
% 如果某目标是最大化：
% 请提前取负号
% =========================================================
function idx = pareto_filter(P)

N = size(P,1);

is_pareto = true(N,1);

for i = 1:N

    if ~is_pareto(i)
        continue;
    end

    for j = 1:N

        if i == j
            continue;
        end

        % j支配i
        if all(P(j,:) <= P(i,:)) && any(P(j,:) < P(i,:))

            is_pareto(i) = false;
            break;

        end
    end
end

idx = is_pareto;

end
