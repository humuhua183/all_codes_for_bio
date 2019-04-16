clear;
data = importdata('/raid/hujun/webface_sphereface/data/CASIA-WebFace-112X96.txt');
image = data.textdata;
label = data.data;
r = randperm(length(image));
image = image(r);
label = label(r);
fid = fopen('/raid/hujun/webface_sphereface/data/CASIA-WebFace-112X96_shuffle.txt','wt');
for i = 1:length(image)
    i
    fprintf(fid,'%s %d\n',image{i}, label(i));
end
fclose(fid);