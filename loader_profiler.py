from musetalk.data.dataset import HDTFDataset
import tqdm


cfg = {"image_size": 256, 
        "T": 1, 
        "sample_method": "pose_similarity_and_mouth_dissimilarity", 
        "top_k_ratio": 0.51, 
        "contorl_face_min_size": True, 
        "dataset_key": "HDTF", 
        "padding_pixel_mouth": 10, 
        "whisper_path": "./models/whisper", 
        "min_face_size": 150, 
        "cropping_jaw2edge_margin_mean": 10, 
        "cropping_jaw2edge_margin_std": 10, 
        "crop_type": "crop_resize", 
        "random_margin_method": "normal"}

dataset = HDTFDataset(cfg=cfg)


for i in tqdm.tqdm(range(50)):
    dataset.__getitem__(0)

