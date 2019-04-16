% refresh('bbox_22_railway.txt','refresh_bbox_22_railway.txt');
% refresh('bbox_30_railway.txt','refresh_bbox_30_railway.txt');
% refresh('bbox_asia.txt','refresh_bbox_asia.txt');
% refresh('bbox_webface.txt','refresh_bbox_webface.txt');
% refresh('bbox_hujun.txt','refresh_bbox_hujun.txt');
refresh('/raid/hujun/train_data/bbox_webface.txt','/raid/hujun/train_data/sphere_webface.txt');

function refresh(ffp,out_ffp)
root_dir = '/raid/hujun/train_data/';
fid = fopen(out_ffp,'wt');
data = importdata(ffp);
image = data.textdata;
label = data.data;
for i = 1:length(image)
    i
    img_name = image{i};
    if exist([root_dir img_name],'file')
        fprintf(fid,'%s %d\n', img_name, label(i)); 
    end
end

fclose(fid);
end