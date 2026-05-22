%% 机器人结构状态参数结构体LP

function LP = LP_generate(n, module_raw, install_raw, align_raw, sequence_raw, RP_data) %#codegen

%% ===================== 提取有效决策变 =====================
module_real   =   module_raw(1:n);
install_real  =   install_raw(1:n);
align_real    =   align_raw(1:n);
sequence_real =   sequence_raw(1:n);
[module, install, align, sequence, num_exp, ~, ~] = expand_module_units(module_real, install_real, align_real, sequence_real, RP_data);

%% ===================== 计算指标3 =====================
LP.num_goal = num_exp + n;

%% ===================== 1. 运动学参数 =====================
LP.module = module;
LP.num_q  = length(module);  % 总模块数
LP.install = install;
LP.align   = align * 2 * pi/3;
LP.BB      = sequence;

% 从 RP_data 读取基础参数
LP.Rp   = RP_data.Rp;
LP.Rd   = RP_data.Rd;
LP.Pp   = RP_data.Pp;
LP.Pd   = RP_data.Pd;
LP.RBcp = RP_data.RBcp;
LP.PBcp = RP_data.PBcp;
LP.T_L  = RP_data.T_L;
LP.T_B  = RP_data.T_B;

% 关节类型与索引
LP.J_type    = RP_data.J_type(module);
R_idx        = find(LP.J_type == 'R');
LP.R_idx     = [R_idx, zeros(1, 30 - length(R_idx))];
LP.num_joint = length(R_idx); 

% 被动关节标记
LP.S0 = zeros(1, LP.num_q);
LP.S0(LP.BB == 0) = 1;

% 被动关节编号
LP.SN = zeros(1, LP.num_q);
zero_indices = find(LP.BB == 0);
LP.SN(zero_indices) = 1:length(zero_indices);

% SE 标记
LP.SE = zeros(1, LP.num_q);
for i = 2:LP.num_q
    if LP.S0(i) == 1
        LP.SE(i-1) = 1;
    end
end
LP.SE(LP.num_q) = 1;

LP.SS = calculate_SS_project(LP);

% 初始化坐标相关矩阵
LP.Qe  = zeros(3, LP.num_q);
LP.cc  = zeros(3, LP.num_q, LP.num_q);
LP.c0  = zeros(3, LP.num_q);
LP.ce  = zeros(3, LP.num_q);

%% ===================== 2. 动力学参数 =====================
LP.m0      = zeros(1, LP.num_q);
LP.m       = 0;
LP.mass    = sum(LP.m0) + LP.m;
LP.inertia = zeros(3, 3*LP.num_q);
for k = 1:LP.num_q
    LP.inertia(:, 3*k-2:3*k) = eye(3);
end
LP.inertia0 = eye(3);

end