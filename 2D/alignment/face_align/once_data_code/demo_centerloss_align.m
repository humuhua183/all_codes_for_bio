clear;
%The function of this script: 
%      Get aligned image using the same method in 'centerloss'(A Discriminative Feature Learning Approach for Deep Face Recognition).  The detail of this algorithm at the end of this script. 
%
%
%notices: 1. the five points should be  left-eye,right-eye,nose,left,mouse,rightmouse  in order;
%        the format in pts should be left-eye-x left-eye-y \n      a   
%                                    right-eye-x right-eye-y \n
%                                    ...
%         2. the resized image must be square
%         3. the images should be stored as  root_dir/class/image
%Jun Hu
%2017-4
face_dir='/media/scw4750/pipa_IDcard/megaface/FaceScrub/downloaded';
ffp_dir=face_dir;
save_dir='/media/scw4750/pipa_IDcard/megaface/centerloss_FaceScrub';

% save_dir='/home/scw4750/github/IJCB2017/liangjie/croped/with_pts/enlarge_mulitpie_croped_by_liang_with_pts/gallery';
pts_format='5pt';
filter='*.jpg';
is_continue=true; %when landmarks does not exist or is not correct,choose whether to continue;
centerloss_align(face_dir, ffp_dir, save_dir,'*.jpg',pts_format,is_continue);

%algorithm:
% First, this algorithm gets similarity transform matrix by the landmarks of a mean shape and the un-aligned image. 
% then, it transforms un-aligned image to aligned image 
% 
