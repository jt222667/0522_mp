function plot_pareto_smooth(data)

% 拆分三列坐标
x = data(:,1);
y = data(:,2);
z = data(:,3);

unique_z = unique(z);
fprintf('自动识别分组 Z值：');
disp(unique_z');

% 颜色（对齐 plot_fitted_surface）
colors = turbo(length(unique_z));
colors(1,:) = [0.55 0.00 0.80];

% ===== 图窗（对齐尺寸风格）=====
figure('Color','w','Position',[100,100,1100,780]);
hold on; grid on; box on;

% ===== 坐标轴 =====
% xlabel('可操作度','FontSize',15,'FontWeight','normal');
% ylabel('最大定位误差','FontSize',15,'FontWeight','normal');
% zlabel('结构复杂度','FontSize',15,'FontWeight','normal');

% title('Pareto前沿分布（按结构复杂度分类）', ...
%     'FontSize',18,'FontWeight','normal');

h_handles = [];
legend_str = {};

for i = 1:length(unique_z)

    idx = (z == unique_z(i));
    xi = x(idx);
    yi = y(idx);
    zi = z(idx);

    [xi, order] = sort(xi);
    yi = yi(order);
    zi = zi(order);

    [xi_unique, ia] = unique(xi);
    yi_unique = yi(ia);

    % ===== 光滑曲线（保留原逻辑）=====
    xx = linspace(min(xi_unique), max(xi_unique), 250);
    yy = interp1(xi_unique, yi_unique, xx, 'pchip');
    zz = unique_z(i) * ones(size(xx));

    line_color = colors(i,:);
    point_color = max(line_color * 0.65, 0);

    % ===== 线（对齐 plot_fitted_surface 风格）=====
    h = plot3(xx, yy, zz, ...
        'Color', line_color, ...
        'LineWidth', 2.5);

    % ===== 点（改成 scatter3 风格）=====
    scatter3(xi, yi, zi, 45, 'filled', ...
        'MarkerFaceColor', point_color, ...
        'MarkerEdgeColor', max(point_color*0.7,0), ...
        'LineWidth', 0.7);

    h_handles = [h_handles, h];
    legend_str{i} = sprintf('C = %.0f', unique_z(i));
end

legend(h_handles, legend_str, ...
    'Location','eastoutside', ...
    'FontName','Times New Roman', ...
    'FontWeight','normal', ...
    'FontSize',10, ...
    'NumColumns',2);

% ===== 坐标轴风格统一 =====
ax = gca;
ax.FontName = 'Times New Roman';
ax.FontSize = 22;
ax.FontWeight = 'normal';
ax.Box = 'on';


% ===== 自动收紧坐标轴（更美观）=====
pad_x = 0.05 * range(x);
pad_y = 0.05 * range(y);
pad_z = 0.05 * range(z);

xlim([min(x)-pad_x, max(x)+pad_x]);
ylim([min(y)-pad_y, max(y)+pad_y]);
zlim([min(z)-pad_z, max(z)+pad_z]);

axis normal;

camlight headlight;
lighting gouraud;

hold off;

end