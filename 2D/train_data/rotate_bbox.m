rotate_img('bbox_22_railway.txt');
rotate_img('bbox_30_railway.txt');
rotate_img('bbox_asia.txt');
rotate_img('bbox_webface.txt');

function rotate_img(ffp)
root_dir  = '/raid/hujun/train_data/';
out_dir = '/raid/hujun/train_data/ROTATE_BBOX/';
data = importdata(ffp);
image = data.textdata;

for i = 1:length(image)
    i
    img_name = image{i};
    img_name_split = regexp(img_name, '/', 'split');
    subdir = [out_dir img_name_split{1} filesep img_name_split{2}];
    if ~exist(subdir, 'dir')
        mkdir(subdir);
    end
    img = imread([root_dir img_name]);
    for i_f = 1:4
        rotate = imrotate(img,i_f*90);
        imwrite(rotate, [out_dir img_name(1:end-4) '_' num2str(i_f) '.jpg']);
    end
end

end