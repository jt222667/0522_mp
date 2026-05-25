function plot_fitted_surface(data)

x = data(:,1);
y = data(:,2);
z = data(:,3);

unique_z = unique(z);

colors = turbo(length(unique_z));
colors(1,:) = [0.55 0.00 0.80];

figure('Color','w','Position',[100,100,1100,780]);
hold on; grid on; box on;

for i = 1:length(unique_z)-1

    z_low  = unique_z(i);
    z_high = unique_z(i+1);

    idx1 = (z == z_low);
    idx2 = (z == z_high);

    x1 = x(idx1); y1 = y(idx1);
    x2 = x(idx2); y2 = y(idx2);

    if length(x1) < 3 || length(x2) < 3
        continue;
    end

    [x1, ord1] = sort(x1); y1 = y1(ord1);
    [x2, ord2] = sort(x2); y2 = y2(ord2);

    [x1, ia1] = unique(x1); y1 = y1(ia1);
    [x2, ia2] = unique(x2); y2 = y2(ia2);

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

    surf([xx1;xx2],[yy1;yy2],[zz1;zz2], ...
        'FaceColor',colors(i,:), ...
        'FaceAlpha',0.50, ...
        'EdgeColor','none');
end

h_handles = [];
legend_str = {};

for i = 1:length(unique_z)

    idx = (z == unique_z(i));
    xi = x(idx);
    yi = y(idx);
    zi = z(idx);

    if isempty(xi), continue; end

    [xi, order] = sort(xi);
    yi = yi(order);
    zi = zi(order);

    [xi_unique, ia] = unique(xi);
    yi_unique = yi(ia);

    line_color = colors(i,:);
    point_color = max(line_color * 0.65,0);

    if length(xi_unique) >= 3
        xx = linspace(min(xi_unique), max(xi_unique), 250);
        yy = interp1(xi_unique, yi_unique, xx, 'pchip');
        zz = unique_z(i) * ones(size(xx));

        h = plot3(xx,yy,zz,'Color',line_color,'LineWidth',2.5);
    else
        h = plot3(xi,yi,zi,'-','Color',line_color,'LineWidth',2.5);
    end

    scatter3(xi,yi,zi,45,'filled', ...
        'MarkerFaceColor',point_color, ...
        'MarkerEdgeColor',max(point_color*0.7,0), ...
        'LineWidth',0.7);

    h_handles = [h_handles,h];

    legend_str{i} = sprintf('C = %.0f', unique_z(i));
end

camlight headlight;
lighting gouraud;

%% =========================
% 中文标签（宋体 + 不加粗）
%% =========================
% xlabel('可操作度ω', ...
%     'FontSize',15, ...
%     'FontWeight','normal', ...
%     'FontName','SimSun');
% 
% ylabel('最大定位误差E/m', ...
%     'FontSize',15, ...
%     'FontWeight','normal', ...
%     'FontName','SimSun');
% 
% zlabel('结构复杂度C', ...
%     'FontSize',15, ...
%     'FontWeight','normal', ...
%     'FontName','SimSun');
% 
% title('Pareto前沿三维分层包络曲面', ...
%     'FontSize',18, ...
%     'FontWeight','normal', ...
%     'FontName','SimSun');

%% =========================
% 关键：坐标轴刻度（只英文数字 Times New Roman）
%% =========================
ax = gca;
ax.FontName = 'Times New Roman';   % 只影响 tick（安全）
ax.FontSize = 22;
ax.FontWeight = 'normal';
ax.Box = 'on';

view(45,25);
axis normal;

%% =========================
% 图例（英文 Times New Roman）
%% =========================
legend(h_handles, legend_str, ...
    'Location','eastoutside', ...
    'FontName','Times New Roman', ...
    'FontWeight','normal', ...
    'FontSize',18);

hold off;

end