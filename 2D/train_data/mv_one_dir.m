data = dir('bbox_webface/*/*.jpg');
r = randperm(length(data));
for i_i = 1:400
    i_i
    i = r(i_i);
    name = data(i).name;
    folder = data(i).folder;
    folder_split = regexp(folder,filesep,'split');
    source_file = [folder filesep name];
    des_file = ['one_dir_v2/' folder_split{end} '_' name];
    copyfile(source_file,des_file);
end