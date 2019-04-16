
function [all_class, all_class_id]= get_class_index(all_labels)
%% Nowadays, I'm so tired to modify the name and write annotation
%%
%%
reg_label = [];
u_label = unique(all_labels);
all_class = cell(length(u_label), 1);
count = 0;
for i_l = 1:length(all_labels)
    label = all_labels(i_l);
    if isempty(find(reg_label ==  label))
        reg_label = [reg_label label];
        count = count + 1;
        all_class{count} = i_l;
        all_class_id(count) = label;

    else
        index = find(reg_label == label);
        all_class{index} = [all_class{index} i_l];
    end
end
end
