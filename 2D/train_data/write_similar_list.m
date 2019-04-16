addpath(genpath('/raid/hujun/global_tool'));

webface = importdata('../bbox_webface.txt');
webface_label = webface.data;
webface = webface.textdata;
asia = importdata('../bbox_asia.txt');
asia_label = asia.data;
asia = asia.textdata;

fid_web = fopen('web_3_person_per_class.txt','wt');
all_class_index = get_class_index(webface_label);

for i = 1:length(all_class_index)
    i
    one_class_index = all_class_index{i};
    one_class_index_len = length(one_class_index);
    for i_o = 1:3
        index = one_class_index(i_o);
        fprintf(fid_web,'%s %d\n',webface{index}, webface_label(index));
    end
end

fclose(fid_web);

fid_asia = fopen('asia_3_person_per_class.txt','wt');
all_class_index = get_class_index(asia_label);
for i = 1:length(all_class_index)
    i
    one_class_index = all_class_index{i};
    one_class_index_len = length(one_class_index);
    for i_o = 1:3
        index = one_class_index(i_o);
        fprintf(fid_asia,'%s %d\n',asia{index}, asia_label(index));
    end
end
fclose(fid_asia);
