%% 将原始module_real, install_real, align_real, RP_data中所有集成模块进行展开，并调用is_valid_expanded_config_debug进行构型合法性评估

function [module_out, install_out, align_out, sequence_out, num_exp, is_valid, err] = expand_module_units(module_real, install_real, align_real, sequence_real, RP_data)

num_single = 7;
integrated_modules = RP_data.integrated_modules;
n = numel(module_real);

module_cell = cell(1, n);
install_cell = cell(1, n);
align_cell   = cell(1, n);

num_exp = 0;

for i = 1:n
    unit_id = round(module_real(i));
    unit_install = round(install_real(i));
    unit_align   = round(align_real(i));

    if unit_id <= num_single
        module_cell{i}  = unit_id;
        install_cell{i} = unit_install;
        align_cell{i}   = unit_align;
        num_exp = num_exp + 1;
    else
        idx = unit_id - num_single;

        if idx >= 1 && idx <= numel(integrated_modules)
            unit = integrated_modules{idx};

            module_cell{i}  = unit.module;
            install_cell{i} = unit.install;
            align_cell{i}   = unit.align;

            num_exp = num_exp + numel(unit.module);
        else
            module_cell{i}  = 1;
            install_cell{i} = unit_install;
            align_cell{i}   = unit_align;

            num_exp = num_exp + 1;
        end
    end
end

module_out  = [module_cell{:}];
install_out = [install_cell{:}];
align_out   = [align_cell{:}];

[is_valid, err] = is_valid_expanded_config_debug(module_out, install_out, RP_data);

%% 真实sequence_out
branch_s = find(sequence_real == 0);
branch_e_tmp = branch_s - 1;
branch_e  = [branch_e_tmp(2:end) numel(sequence_real)];
m = numel(branch_s);
branchs = cell(1,m);
lens    = zeros(1,m);
for i = 1:m
branchs{i} = module_real(branch_s(i):branch_e(i));
lens(i) = length(branchs{i});
    for j = 1:length(branchs{i})
        a = branchs{i}(j);
        if a > 7
        b = integrated_modules{a-7}.module;
        lens(i) = lens(i) + length(b) - 1;
        end 
    end
end
if m == 1
    sequence_out = [0,1:lens(1) - 1];
elseif m == 2
    sequence_out =    [0 1:lens(1)-1 ...
        0 lens(1)+1:lens(1)+lens(2)-1];
elseif m == 3
    sequence_out =    [0 1:lens(1)-1 ...
        0 lens(1)+1:lens(1)+lens(2)-1 ...
        0 lens(1)+lens(2)+1:lens(1)+lens(2)+lens(3)-1];
end


end


