# this file is for debug to be removed

import json
import sys
import os
import gc
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from musetalk.data.dataset import FaceDataset
#read ~/conf_7242.json

with open('/home/pmilos_google_com/conf_7242.json', 'r') as f:
    conf_dict = json.load(f)

# conf_dict = {'cfg': cfg, 'list_paths': list_paths, 'root_path': root_path, 'repeats': repeats}

reader = FaceDataset(**conf_dict)

import psutil
process = psutil.Process(os.getpid())
try:
    for i, batch in enumerate(reader):
        if i % 10 == 0:
             print(f"rss {i}: {process.memory_info().rss / 1024 / 1024} MB")

        # if i % 20 ==0:
        #     print('restrting reader')
        #     reader = FaceDataset(**conf_dict)
        #     gc.collect()
        if i > 500:
            break
finally:
    print("done")

