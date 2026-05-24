function plot_pareto(data)

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
    
    % 按y降序排序
    [~, order] = sort(yi, 'descend');
    
    h = plot3(xi(order), yi(order), zi(order), ...
        'Color', colors(i,:), 'LineWidth', 1.5, ...
        'Marker', 'o', 'MarkerSize', 6, ...
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