import os
import shutil,os
path = '/home/scw4750/Dataset/Celebrity_Asia_Crop_ClusterByMicrosoft'
count = 0
all_folders = os.listdir(path)

for file in all_folders:
    if os.path.isdir(os.path.join(path,file))==True:
            newname=str(count).zfill(6)
            count = count + 1
            shutil.move(os.path.join(path,file),os.path.join(path,newname))
