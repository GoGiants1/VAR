################## 1. Download checkpoints and build models
import os
import os.path as osp
from concurrent.futures import ThreadPoolExecutor

# model_depth_list = [16, 20, 24, 30] # 원본
model_depth_list = [20, 24, 30]


# Download checkpoint
hf_home = "https://huggingface.co/FoundationVision/var/resolve/main"

vae_ckpt = "vae_ch160v4096z32.pth"


def download_file(filename):
    if not osp.exists(filename):
        os.system(f"wget {hf_home}/{filename}")


# Create a list of filenames to download
# filenames = [vae_ckpt] + [f"var_d{d}.pth" for d in model_depth_list] # VAE 포함 다운로드

filenames = [f"var_d{d}.pth" for d in model_depth_list]

# Use ThreadPoolExecutor to download files in parallel
with ThreadPoolExecutor() as executor:
    executor.map(download_file, filenames)
