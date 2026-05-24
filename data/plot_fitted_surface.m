function plot_fitted_surface(data)

%% =========================
% 数据拆分
%% =========================
x = data(:,1);   % 可操作度
y = data(:,2);   % 最大定位误差
z = data(:,3);   % 结构复杂度

%% =========================
% Z分组
%% =========================
unique_z = unique(z);

fprintf('自动识别分组 Z值：');
disp(unique_z');

%% =========================
% 配色
%% =========================
colors = turbo(length(unique_z));

% 仅修改第一个颜色：黑色 -> 紫色
colors(1,:) = [0.55 0.00 0.80];

%% =========================
% 创建图窗
%% =========================
figure( ...
    'Color','w', ...
    'Position',[100,100,1100,780]);

hold on;
grid on;
box on;

%% =========================================================
% 仅绘制层间曲面（不封闭xy平面）
%% =========================================================
for i = 1:length(unique_z)-1

    %% 当前层
    z_low  = unique_z(i);
    z_high = unique_z(i+1);

    %% 取上下层数据
    idx1 = (z == z_low);
    idx2 = (z == z_high);

    x1 = x(idx1);
    y1 = y(idx1);

    x2 = x(idx2);
    y2 = y(idx2);

    %% 点太少
    if length(x1) < 3 || length(x2) < 3
        continue;
    end

    %% =========================
    % 按x排序
    %% =========================
    [x1, ord1] = sort(x1);
    y1 = y1(ord1);

    [x2, ord2] = sort(x2);
    y2 = y2(ord2);

    %% =========================
    % 去重
    %% =========================
    [x1, ia1] = unique(x1);
    y1 = y1(ia1);

    [x2, ia2] = unique(x2);
    y2 = y2(ia2);

    %% =========================
    % 点太少跳过
    %% =========================
    if length(x1) < 2 || length(x2) < 2
        continue;
    end

    %% =========================
    % 插值统一采样
    %% =========================
    nSample = 120;

    t1 = linspace(0,1,length(x1));
    t2 = linspace(0,1,length(x2));

    tt = linspace(0,1,nSample);

    xx1 = interp1(t1,x1,tt,'pchip');
    yy1 = interp1(t1,y1,tt,'pchip');

    xx2 = interp1(t2,x2,tt,'pchip');
    yy2 = interp1(t2,y2,tt,'pchip');

    zz1 = z_low  * ones(size(xx1));
    zz2 = z_high * ones(size(xx2));

    %% =========================
    % 构造层间幕布曲面
    %% =========================
    X = [xx1; xx2];
    Y = [yy1; yy2];
    Z = [zz1; zz2];

    %% 当前颜色
    layer_color = colors(i,:);

    %% 绘制侧壁
    surf( ...
        X, Y, Z, ...
        'FaceColor', layer_color, ...
        'FaceAlpha', 0.50, ...
        'EdgeColor', 'none');

end

%% =========================================================
% 绘制各层曲线 + 散点
%% =========================================================
h_handles = [];
legend_str = {};

for i = 1:length(unique_z)

    %% 当前层
    idx = (z == unique_z(i));

    xi = x(idx);
    yi = y(idx);
    zi = z(idx);

    if isempty(xi)
        continue;
    end

    %% 排序
    [xi, order] = sort(xi);

    yi = yi(order);
    zi = zi(order);

    %% 去重
    [xi_unique, ia] = unique(xi);
    yi_unique = yi(ia);

    %% 当前颜色
    line_color = colors(i,:);

    %% 点颜色
    point_color = max(line_color * 0.65,0);

    %% =========================
    % 平滑曲线
    %% =========================
    if length(xi_unique) >= 3

        xx = linspace( ...
            min(xi_unique), ...
            max(xi_unique), ...
            250);

        yy = interp1( ...
            xi_unique, ...
            yi_unique, ...
            xx, ...
            'pchip');

        zz = unique_z(i) * ones(size(xx));

        %% 曲线
        h = plot3( ...
            xx,yy,zz, ...
            'Color',line_color, ...
            'LineWidth',2.5);

    else

        %% 点太少直接连线
        h = plot3( ...
            xi,yi,zi, ...
            '-', ...
            'Color',line_color, ...
            'LineWidth',2.5);

    end

    %% =========================
    % 散点
    %% =========================
    scatter3( ...
        xi,yi,zi, ...
        45, ...
        'filled', ...
        'MarkerFaceColor',point_color, ...
        'MarkerEdgeColor',max(point_color*0.7,0), ...
        'LineWidth',0.7);

    %% 图例
    h_handles = [h_handles,h];

    legend_str{i} = sprintf( ...
        '结构复杂度 = %.0f', ...
        unique_z(i));

end

%% =========================
% 光照
%% =========================
camlight headlight;
lighting gouraud;

%% =========================
% 坐标轴
%% =========================
xlabel( ...
    '可操作度', ...
    'FontSize',13, ...
    'FontWeight','bold');

ylabel( ...
    '最大定位误差', ...
    'FontSize',13, ...
    'FontWeight','bold');

zlabel( ...
    '结构复杂度', ...
    'FontSize',13, ...
    'FontWeight','bold');

title( ...
    'Pareto前沿三维分层包络曲面', ...
    'FontSize',16, ...
    'FontWeight','bold');

%% =========================
% 图例
%% =========================
legend( ...
    h_handles, ...
    legend_str, ...
    'Location','eastoutside');

%% =========================
% 视角
%% =========================
view(45,25);

%% =========================
% 坐标轴比例
%% =========================
axis normal

%% =========================
% 美化
%% =========================
set(gca, ...
    'LineWidth',1.15, ...
    'FontSize',11, ...
    'Box','on');

hold off;

end