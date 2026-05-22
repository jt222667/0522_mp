%% 模块库初始化函数，生成模块参数结构体RP_data

function RP_data = Module_Lib()
% 参数初始化
syms theta d a alf;

SDH = [
    cos(theta),  -sin(theta)*cos(alf),  sin(theta)*sin(alf),  a*cos(theta);
    sin(theta),   cos(theta)*cos(alf), -cos(theta)*sin(alf),  a*sin(theta);
    0,            sin(alf),             cos(alf),             d;
    0,            0,                      0,                      1
    ];

Num_connection = 3;
Num_modules = 10;
Mp = zeros(4,4,Num_modules);
Md = zeros(4,4,Num_modules);
Rp = zeros(3,3,Num_modules);
Rd = zeros(3,3,Num_modules);
Pp = zeros(3,Num_modules);
Pd = zeros(3,Num_modules);
Bcp= zeros(4,4,Num_connection);  % Base_connection_point 最后一位数字由基座上包含几个接口确定
RBcp= zeros(3,3,Num_connection); % 最后一位数字由基座上包含几个接口确定
PBcp= zeros(3,Num_connection);   % 最后一位数字由基座上包含几个接口确定

theta_prox = zeros(2,Num_modules);
d_prox = zeros(2,Num_modules);
a_prox = zeros(2,Num_modules);
alf_prox = zeros(2,Num_modules);

theta_dist = zeros(2,Num_modules);
d_dist = zeros(2,Num_modules);
a_dist = zeros(2,Num_modules);
alf_dist = zeros(2,Num_modules);

T_L = zeros(4,4,Num_modules);
T_B = zeros(4,4,2);

%% module 1
% 关节模块，信息用Rp Pp Rd Pd存储
J_type(1) = 'R'; 

theta_prox(1,1) = 0;
d_prox(1,1) = 0.2;
a_prox(1,1) = 0;
alf_prox(1,1) = 0;
Mp(:,:,1) = subs(SDH, {theta, d, a, alf}, {theta_prox(1,1), d_prox(1,1), a_prox(1,1), alf_prox(1,1)});
Rp(:,:,1) = Mp(1:3,1:3,1);
Pp(:,1) =Mp(1:3,4,1);

theta_dist(1,1) = 0;
d_dist(1,1) = 0.2;
a_dist(1,1) = 0;
alf_dist(1,1) = 0;
Md(:,:,1) = subs(SDH, {theta, d, a, alf}, {theta_dist(1,1), d_dist(1,1), a_dist(1,1), alf_dist(1,1)});
Rd(:,:,1) = Md(1:3,1:3,1);
Pd(:,1) =Md(1:3,4,1);

%% module 2
% 关节模块，信息用Rp Pp Rd Pd存储
J_type(2) = 'R'; 
 
theta_prox(1,2) = 0;
d_prox(1,2) = 0.2;
a_prox(1,2) = 0;
alf_prox(1,2) = -pi/2;
Mp(:,:,2) = subs(SDH, {theta, d, a, alf}, {theta_prox(1,2), d_prox(1,2), a_prox(1,2), alf_prox(1,2)});
Rp(:,:,2) = Mp(1:3,1:3,2);
Pp(:,2) =Mp(1:3,4,2);

theta_dist(1,2) = 0;
d_dist(1,2) = 0;
a_dist(1,2) = 0;
alf_dist(1,2) = pi/2;

theta_dist(2,2) = 0;
d_dist(2,2) = 0.2;
a_dist(2,2) = 0;
alf_dist(2,2) = 0;
Md(:,:,2) = subs(SDH, {theta, d, a, alf}, {theta_dist(1,2), d_dist(1,2), a_dist(1,2), alf_dist(1,2)})*subs(SDH, {theta, d, a, alf}, {theta_dist(2,2), d_dist(2,2), a_dist(2,2), alf_dist(2,2)});
Rd(:,:,2) = Md(1:3,1:3,2);
Pd(:,2) =Md(1:3,4,2);

%% module 3
% 关节模块，信息用Rp Pp Rd Pd存储
J_type(3) = 'R';

theta_prox(1,3) = 0;
d_prox(1,3) = 0.2;
a_prox(1,3) = 0;
alf_prox(1,3) = -pi/2;

theta_prox(2,3) = 0;
d_prox(2,3) = 0.1;
a_prox(2,3) = 0;
alf_prox(2,3) = 0;
Mp(:,:,3) = subs(SDH, {theta, d, a, alf}, {theta_prox(1,3), d_prox(1,3), a_prox(1,3), alf_prox(1,3)})*subs(SDH, {theta, d, a, alf}, {theta_prox(2,3), d_prox(2,3), a_prox(2,3), alf_prox(2,3)});
Rp(:,:,3) = Mp(1:3,1:3,3);
Pp(:,3) =Mp(1:3,4,3);

theta_dist(1,3) = 0;
d_dist(1,3) = 0.1;
a_dist(1,3) = 0;
alf_dist(1,3) = 0;
Md(:,:,3) = subs(SDH, {theta, d, a, alf}, {theta_dist(1,3), d_dist(1,3), a_dist(1,3), alf_dist(1,3)});
Rd(:,:,3) = Md(1:3,1:3,3);
Pd(:,3) =Md(1:3,4,3);

%% module 4
% 关节模块（新增），信息用Rp Pp Rd Pd存储
J_type(4) = 'R';

theta_prox(1,4) = 0;
d_prox(1,4) = 0.2;
a_prox(1,4) = 0;
alf_prox(1,4) = pi/2;

theta_prox(2,4) = 0;
d_prox(2,4) = 0.2;
a_prox(2,4) = 0;
alf_prox(2,4) = 0;

Mp(:,:,4) = subs(SDH, {theta, d, a, alf}, {theta_prox(1,4), d_prox(1,4), a_prox(1,4), alf_prox(1,4)})*subs(SDH, {theta, d, a, alf}, {theta_prox(2,4), d_prox(2,4), a_prox(2,4), alf_prox(2,4)});
Rp(:,:,4) = Mp(1:3,1:3,4);
Pp(:,4) =Mp(1:3,4,4);

theta_dist(1,4) = 0;
d_dist(1,4) = 0.1;
a_dist(1,4) = 0;
alf_dist(1,4) = -pi/2;

theta_dist(2,4) = 0;
d_dist(2,4) = 0.2;
a_dist(2,4) = 0;
alf_dist(2,4) = 0;

Md(:,:,4) = subs(SDH, {theta, d, a, alf}, {theta_dist(1,4), d_dist(1,4), a_dist(1,4), alf_dist(1,4)}) * subs(SDH, {theta, d, a, alf}, {theta_dist(2,4), d_dist(2,4), a_dist(2,4), alf_dist(2,4)});
Rd(:,:,4) = Md(1:3,1:3,4);
Pd(:,4) =Md(1:3,4,4);

%% module 5
% 连杆模块（新增），参数与 module 1 相同
J_type(5) = 'L';

theta_prox(1,5) = 0;
d_prox(1,5) = 0.2;
a_prox(1,5) = 0;
alf_prox(1,5) = 0;
Mp(:,:,5) = subs(SDH, {theta, d, a, alf}, {theta_prox(1,5), d_prox(1,5), a_prox(1,5), alf_prox(1,5)});
Rp(:,:,5) = Mp(1:3,1:3,5);
Pp(:,5) =Mp(1:3,4,5);

theta_dist(1,5) = 0;
d_dist(1,5) = 0.2;
a_dist(1,5) = 0;
alf_dist(1,5) = 0;
Md(:,:,5) = subs(SDH, {theta, d, a, alf}, {theta_dist(1,5), d_dist(1,5), a_dist(1,5), alf_dist(1,5)});
Rd(:,:,5) = Md(1:3,1:3,5);
Pd(:,5) =Md(1:3,4,5);

T_L(:,:,5) = Mp(:,:,5)*Md(:,:,5);

%% module 6
% 连杆模块（原 module 4，编号顺延 +2）
J_type(6) = 'L';

theta_prox(1,6) = 0;
d_prox(1,6) = 0.2;
a_prox(1,6) = 0;
alf_prox(1,6) = -pi/2;
Mp(:,:,6) = subs(SDH, {theta, d, a, alf}, {theta_prox(1,6), d_prox(1,6), a_prox(1,6), alf_prox(1,6)});
Rp(:,:,6) = Mp(1:3,1:3,6);
Pp(:,6) =Mp(1:3,4,6);

theta_dist(1,6) = 0;
d_dist(1,6) = 0.2;
a_dist(1,6) = 0;
alf_dist(1,6) = 0;
Md(:,:,6) = subs(SDH, {theta, d, a, alf}, {theta_dist(1,6), d_dist(1,6), a_dist(1,6), alf_dist(1,6)});
Rd(:,:,6) = Md(1:3,1:3,6);
Pd(:,6) =Md(1:3,4,6);

T_L(:,:,6) = Mp(:,:,6)*Md(:,:,6);

%% module 7
% 连杆模块（原 module 5，编号顺延 +2）
J_type(7) = 'L';

theta_prox(1,7) = 0;
d_prox(1,7) = 0.2;
a_prox(1,7) = 0;
alf_prox(1,7) = -pi/4;
Mp(:,:,7) = subs(SDH, {theta, d, a, alf}, {theta_prox(1,7), d_prox(1,7), a_prox(1,7), alf_prox(1,7)});
Rp(:,:,7) = Mp(1:3,1:3,7);
Pp(:,7) =Mp(1:3,4,7);

theta_dist(1,7) = 0;
d_dist(1,7) = 0.2;
a_dist(1,7) = 0;
alf_dist(1,7) = 0;
Md(:,:,7) = subs(SDH, {theta, d, a, alf}, {theta_dist(1,7), d_dist(1,7), a_dist(1,7), alf_dist(1,7)});
Rd(:,:,7) = Md(1:3,1:3,7);
Pd(:,7) =Md(1:3,4,7);

T_L(:,:,7) = Mp(:,:,7)*Md(:,:,7);

%% 基座模块，现在将其视作模块，0,1,2,3对应基座原点和基座上的接口，这里计算T13,T12
T01 = [1 0 0 0;
    0 1 0 0;
    0 0 1 0.2;
    0 0 0 1];
T02 = Rx(2*pi/3)*T01;
T03 = Rx(4*pi/3)*T01;

T_B(:,:,1) = Rx(pi) * T_inv(T02) * T01; % T21
T_B(:,:,2) = Rx(pi) * T_inv(T02) * T03; % T23


%% 接口位姿
Bcp(:,:,1) = [1 0 0 0;
    0 1 0 0;
    0 0 1 0.2;
    0 0 0 1];
Bcp(:,:,2) = Rx(2*pi/3)*Bcp(:,:,1);
Bcp(:,:,3) = Rx(4*pi/3)*Bcp(:,:,1);

RBcp(:,:,1) = Bcp(1:3,1:3,1);
PBcp(:,1) = Bcp(1:3,4,1);
RBcp(:,:,2) = Bcp(1:3,1:3,2);
PBcp(:,2) = Bcp(1:3,4,2);
RBcp(:,:,3) = Bcp(1:3,1:3,3);
PBcp(:,3) = Bcp(1:3,4,3);

%% 集成模块
RP_data.integrated_modules = {
    struct('num',2,'module', [1 2], 'install', [1 1], 'align', [0 0]), ...
    struct('num',2,'module', [1 2 1], 'install', [1 1 1], 'align', [0 0 0]), ...
    struct('num',2,'module', [3 6 1 6 1], 'install', [1 1 1 1 1], 'align', [0 0 0 0 0]) ...
};

%% 信息存储
RP_data.Rp = Rp;     % [模块近端] --> [关节] 的旋转矩阵，维度：(3, 3, 模块数)
RP_data.Rd = Rd;     % [关节] --> [模块远端] 的旋转矩阵，维度：(3, 3, 模块数)
RP_data.Pp = Pp;     % [模块近端] --> [关节] 的位移向量，维度：(3, 模块数)
RP_data.Pd = Pd;     % [关节] --> [模块近端] 的位移向量，维度：(3, 模块数)
RP_data.RBcp = RBcp; % [基座原点] --> [基座接口处] 的旋转矩阵，维度：(3, 3, 接口数)
RP_data.PBcp = PBcp; % [基座原点] --> [基座接口处] 的位移向量，维度：(3, 接口数)
RP_data.J_type = J_type;
RP_data.T_L = T_L;
RP_data.T_B = T_B;

end


