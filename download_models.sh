#!/bin/bash

#SBATCH --job-name=var_download
#SBATCH --partition=a6000
#SBATCH --nodelist=node06
#SBATCH --mem=50G
#SBATCH --gres=gpu:0
#SBATCH --time=0-06:00:00
#SBATCH --cpus-per-task=8

eval "$(conda shell.bash hook)"
conda activate var


srun python download_all_ckpts.py # 수행할 작업