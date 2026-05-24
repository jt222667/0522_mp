function plot_pareto_smooth(data)

% 拆分三列坐标
x = data(:,1); % 末端可操作度
y = data(:,2); % 末端最大定位误差
z = data(:,3); % 模块数量

% 获取Z唯一值（分组）
unique_z = unique(z);
fprintf('自动识别分组 Z值：');
disp(unique_z');

% 颜色
colors = lines(length(unique_z));

% 绘图
figure('Color','w','Position',[100,100,800,600]);
hold on; grid on; box on;

% ===== 坐标轴名称修改 =====
xlabel('可操作度','FontSize',12);
ylabel('最大定位误差','FontSize',12);
zlabel('结构复杂度','FontSize',12);

title('Pareto前沿分布（按结构复杂度分类）','FontSize',14);

% 图例句柄
h_handles = [];
legend_str = {};

% 分组绘制
for i = 1:length(unique_z)
    idx = (z == unique_z(i));
    xi = x(idx);
    yi = y(idx);
    zi = z(idx);
    
    % 按x排序（拟合曲线更稳定）
    [xi, order] = sort(xi);
    yi = yi(order);
    zi = zi(order);

    % 去除重复x值
    [xi_unique, ia] = unique(xi);
    yi_unique = yi(ia);

    % 光滑拟合
    xx = linspace(min(xi_unique), max(xi_unique), 200);
    yy = interp1(xi_unique, yi_unique, xx, 'pchip');

    % 对应z保持不变
    zz = unique_z(i) * ones(size(xx));

    h = plot3(xx, yy, zz, ...
        'Color', colors(i,:), 'LineWidth', 2);

    % 原始点
    plot3(xi, yi, zi, 'o', ...
        'Color', colors(i,:), ...
        'MarkerSize', 6, ...
        'MarkerFaceColor', colors(i,:), ...
        'MarkerEdgeColor', colors(i,:));

    h_handles = [h_handles, h];
    
    % ===== 图例名称修改 =====
    legend_str{i} = sprintf('结构复杂度 = %.0f', unique_z(i));
end

legend(h_handles, legend_str, 'Location','best');

view(3);
hold off;

end