# -*- coding:utf-8 -*-

import urllib2
import urllib
import time
import os
import json
import ssl
from functools import wraps
import itertools



class Post(object):
    POSITION_LEFT = "L"
    POSITION_RIGHT = "R"

    def set_image(self, left_img_path):
        self.left_img_path = left_img_path
        self.right_img_path = None
        self.left_face_id = None
        self.right_face_id = None
        self.score = None
        self.desc = None
		
    def run_by_leftImage(self):
        self.post_img(self.left_img_path, self.POSITION_LEFT)
        return self.left_face_id

    def post_img(self, path, position):
        boundary = '----%s' % hex(int(time.time() * 1000))
        data = self.get_img_data(path, boundary, position)
        http_url = 'https://www.twinsornot.net/Home/AnalyzeOneImage?isTest=False&fileid=%s' % position
        http_body = '\r\n'.join(data)

        # build http request
        req = urllib2.Request(http_url, data=http_body)
        # header
        req.add_header('Content-Type', 'multipart/form-data; boundary=%s' % boundary)
        # req.add_header('Accept-Encoding', 'gzip, deflate, br')
        req.add_header('User-Agent',
                       'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.87 Safari/537.36')
        req.add_header('X-Requested-With', 'XMLHttpRequest')
        # post data to server
        print("Posting img data...")
        resp = urllib2.urlopen(req, timeout=15)
        # get response
        result = resp.read()
        print("Parsing response...")
        self.parse_face_id(position, result)

    def parse_face_id(self, position, result):
        result_dict = json.loads(json.loads(result))
        if "success" == result_dict.get("Category"):
            for face_dict in result_dict.get("Faces", []):
                if "faceId" in face_dict:
                    if position == self.POSITION_LEFT:
                        self.left_face_id = face_dict.get("faceId", "")
                        print("Left face id is: %s" % self.left_face_id)
                    if position == self.POSITION_RIGHT:
                        self.right_face_id = face_dict.get("faceId", "")
                        print("Right face id is: %s" % self.right_face_id)

    def parse_score(self, result):
        result_dict = json.loads(json.loads(result))
        if "success" == result_dict.get("Category"):
            self.score = result_dict.get("Score")
            self.desc = result_dict.get("Description")
            print('Score: %s' % (self.score))
            # print("Score: %s, %s" % (self.score, self.desc))
            return self.score

    def get_img_data(self, path, boundary, position):
        data = []
        data.append('--%s' % boundary)
        fr = open(r'%s' % path, 'rb')
        file_name = os.path.basename(path)
        data.append('Content-Disposition: form-data; name="processedImg%s"; filename="%s"' % (position, file_name))
        data.append('Content-Type: %s\r\n' % 'image/jpeg')
        data.append(fr.read())
        fr.close()
        data.append('--%s--\r\n' % boundary)
        return data

    def how_similar(self):
        http_url = "https://www.twinsornot.net/Home/HowSimilar"
        form_data = {
            "leftFaceID": self.left_face_id,
            "rightFaceID": self.right_face_id
        }
        req = urllib2.Request(http_url)
        data = urllib.urlencode(form_data)
        resp = urllib2.urlopen(req, data, timeout=10)
        print("Parsing score...")
        return self.parse_score(resp.read())

    def how_similar(self, leftID, rightID):
        http_url = "https://www.twinsornot.net/Home/HowSimilar"
        form_data = {
            "leftFaceID": leftID,
            "rightFaceID": rightID
        }
        req = urllib2.Request(http_url)
        data = urllib.urlencode(form_data)
        resp = urllib2.urlopen(req, data, timeout=10)
        print("Parsing score...")
        return self.parse_score(resp.read())
def get_faceID(objPost, path):
    print('Current file: %s', path)
    cn = 0
    faceID = []
    while cn<3:                
        try:
            objPost.set_image(path)
            faceID = objPost.run_by_leftImage()
            break
        except:
            print 'error\n'
            cn = cn+1
            print
    return faceID, cn



def compute_folder_similarity(first_path, second_path, root_dir):
    all_1st_imgs = os.listdir(root_dir+os.path.sep+first_path)
    all_2nd_imgs = os.listdir(root_dir+os.path.sep+second_path)


    objPost = Post();
    lines = []
    for i_f, iterm_1 in enumerate(all_1st_imgs):
        first_file_name = first_path+os.path.sep+iterm_1
        [faceID_1st, try_time] = get_faceID(objPost,root_dir+os.path.sep+ first_file_name)
        if try_time == 3:
            continue
        for i_s, iterm_2 in enumerate(all_2nd_imgs):
            second_file_name = second_path+os.path.sep+iterm_2
            [faceID_2nd, try_time] = get_faceID(objPost, root_dir+os.path.sep+second_file_name)
            if try_time ==3:
                continue
            try:
                score = objPost.how_similar(faceID_1st, faceID_2nd)
                one_line = '%s %s %s\n'%(first_file_name, second_file_name, score)
                lines.append(one_line)
            except:
                print('error when compute similarity\n')

    txt_name = root_dir+os.path.sep+first_path+'_'+second_path+'.txt'
    with open(txt_name, 'wt') as f:
        f.writelines(lines)

    
def FindFacePair(dirPath):
    folder = os.listdir(dirPath)
    for first_idx in range(len(folder)):
        for second_idx in range(first_idx+1,len(folder)):
            compute_folder_similarity(folder[first_idx], folder[second_idx],dirPath)




# 主函数测试代码
if __name__ == '__main__':
    dirPath = "/home/scw4750/BRL/result_twins"

    def sslwrap(func):
        @wraps(func)
        def bar(*args, **kw):
            kw['ssl_version'] = ssl.PROTOCOL_TLSv1
            return func(*args, **kw)

        return bar

    ssl.wrap_socket = sslwrap(ssl.wrap_socket)

    FindFacePair(dirPath)
    




