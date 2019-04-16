function centerloss_align(face_dir,ffp_dir,save_dir,file_filter,pts_format,is_continue)

imgSize = [112, 96];

subdir = dir(face_dir);
subdir = subdir(3:end);
for i=1: length(subdir)
    if ~ subdir(i).isdir
        continue;
    end
    fprintf('[%.2f%%] %s\n', 100*i/length(subdir), subdir(i).name);
    pathstr = [save_dir filesep subdir(i).name];
    if exist(pathstr, 'dir')  == 0
        fprintf('create %s\n', pathstr);
        mkdir(pathstr);
    end
    
    img_fns = dir([face_dir filesep subdir(i).name filesep file_filter]);
    for k=1: length(img_fns)
        img = imread([face_dir filesep subdir(i).name filesep img_fns(k).name]);
        ffp_fn = [ffp_dir filesep subdir(i).name filesep img_fns(k).name(1:end-3) pts_format];
        if is_continue
            if ~exist(ffp_fn, 'file')
                continue;
            end
        end
        assert(logical(exist(ffp_fn, 'file')),'landmarks should be provided\n');
        img_cropped=centerloss_align_single(img,ffp_fn);

        save_fn = [save_dir filesep subdir(i).name filesep img_fns(k).name(1:end-3) output_format];
        imwrite(img_cropped, save_fn);
    end
end
        
end
     

