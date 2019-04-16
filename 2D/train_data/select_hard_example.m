addpath(genpath('/raid/hujun/global_tool'));
addpath('/home/scw4750/caffe-master_without_cudnn/matlab');
data = importdata('/raid/hujun/train_data/bbox_hujun_with_big_pose.txt');
all_labels = data.data;
all_imgs = data.textdata;
caffe.reset_all();

prototxt = '/raid/hujun/retrain_vgg/train_file_v28/vgg_lmdb.prototxt';
caffemodel = '/raid/hujun/retrain_vgg/snapshot/v28/lvgg_iter_14000.caffemodel';

net = caffe.Net(prototxt , ...
   caffemodel ,'test');
caffe.set_mode_gpu();
caffe.set_device(1);
data_key = 'data';
feature_key = 'fc14128';
count = 0;
record_count = 0;
begin_number = 1;
% fid = fopen('hard_example.txt','wt');
last_label=-1;
deleted_number = 0;
for i_i = begin_number:length(all_labels)
    i_i
    label = all_labels(i_i);
    if label ~= last_label
        count=0;
        one_class_number = sum(all_labels == label);
    end
    last_label = label;
    try
        img = imread(['/raid/hujun/train_data/' all_imgs{i_i}]);
    catch
        continue;
    end
    preprocessed_img = preprocess_img(img);
    net.blobs(data_key).set_data(preprocessed_img);
    net.forward_prefilled();
    feature=net.blobs(feature_key).get_data();
    [~,index]=max(feature);
    if label+1 ~=index
%         fprintf(fid,'%s %d\n', all_imgs{i_i}, label);
        count = count + 1;
%         hard_example_index(count) = i_i;
%         hard_example_feature{count} = feature;
%         
        img_max_index = find(all_labels == index-1);
        img_max_index = img_max_index(1);
        img_max_name = all_imgs{img_max_index};
%         img_max_name_split = regexp(img_max_name,'/','split');
% %         fprintf(fid,'%s\n',img_max_name_split{2});
%         img_name = ['/raid/hujun/train_data/' all_imgs{i_i}];
%         threshold = single(count)/one_class_number;
%         if threshold > 0.1
%             record_count = record_count + 1;
%             img_name_split = regexp(img_name,filesep,'split');
%             record{record_count} = img_name_split{end-1};
%         end
%         try
%             delete(img_name);
%         catch
%             continue;
%         end
%         img_name_split = regexp(img_name,'/','split');
%         fprintf(fid,'%s\n',img_name_split{2});
%         %%% show img
        subplot(2,1,1);
        imshow(img);

        img_max = imread(['/raid/hujun/train_data/' img_max_name]);
        subplot(2,1,2);
        imshow(img_max);

    end
end
% fclose(fid);

function output_img = preprocess_img(img)
if length(size(img)) == 2
    img(:,:,2) = img(:,:,1);
    img(:,:,3) = img(:,:,1);
end

averageImg = [123, 117, 104];
img_size = [224,224];
img = img(:, :, [3, 2, 1]); % convert from RGB to BGR
img = permute(img, [2, 1, 3]); % permute width and height
img=imresize(img,img_size);
data = zeros(img_size(2),img_size(1),3,1);
data = single(data);

img=single(img);
img = cat(3,img(:,:,1)-averageImg(3),...
    img(:,:,2)-averageImg(2),...
    img(:,:,3)-averageImg(1));
data(:,:,1,1) = (single(img(:,:,1)));
data(:,:,2,1) = (single(img(:,:,2)));
data(:,:,3,1) = (single(img(:,:,3)));
output_img = data;
end