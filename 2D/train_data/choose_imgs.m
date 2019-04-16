asia = dir('/raid/Dataset/Megaface/centerloss_identities_2');
asia = asia(3:end);
fid = fopen('sphere_megaface_bigger25_v2.txt','wt');
for i = 1:length(asia)
    i
    class = asia(i).name;
    all_imgs = dir([asia(i).folder filesep class '/*.jpg']);
    if length(all_imgs) <25
        fprintf(fid,'%s\n',class); 
    end
end
fclose(fid);


