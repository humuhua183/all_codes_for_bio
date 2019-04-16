
fid = fopen('/home/idealsee/all_data_a-softmax/train_txt/asia.txt');
data =textscan(fid,'%s %d\n');
all_labels = data{2};
all_imgs = data{1};
fclose(fid);

fid = fopen('/home/idealsee/all_data_a-softmax/train_txt/asia_test.txt','wt');
label_len = length(all_labels);
r = randperm(label_len);
for i = 1:2000
    index = r(i);
    fprintf(fid,'%s %d\n',all_imgs{index},all_labels(index));
end
fclose(fid);