#!/bin/bash

#SBATCH --job-name=jupyter
#SBATCH --partition=a100
#SBATCH --nodelist=node01
#SBATCH --mem=50G
#SBATCH --gres=gpu:1
#SBATCH --time=0-06:00:00
#SBATCH --cpus-per-task=4
#SBATCH --output=./slurm_log/S-%x.%j.out

if [ $# -lt 1 ]; then
    echo "Usage: launch_jupyter.sh [partition] [env_name] [node_list] [port] [mem]"
    exit 1
fi

DEFAULT_PORT=29165

# Get partition, environment name, port, and nodelist from input arguments
partition=${1:-"a100"}    # Default partition is "a4000" if not specified
env_name=${2:-"base"}      # Default environment is "base" if not specified
nodelist=${3:-""}          # No default for nodelist; only included if specified
port=${4:-$DEFAULT_PORT}   # Default port is 29165 if not provided
mem=${5:-"50G"}           # Default memory is 50G if not specified




# Check arguments and print help message if necessary
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
  echo "Usage: launch_jupyter.sh [partition] [env_name] [node_list] [port] [mem]"
  echo "partition: Partition to run the job on (default: a100)"
  echo "env_name: Conda environment to activate (default: base)"
  echo "node_list: List of nodes to run the job on (default: none)"
  echo "port: Port to run Jupyter Notebook on (default: 29165)"
  echo "mem: Memory to allocate for the job (default: 50G)"
  exit 0
fi

# Include partition option in SBATCH if provided
if [ -n "$partition" ]; then
  SBATCH_PARTITION="--partition=$partition"
else
  SBATCH_PARTITION=""
fi


# Include nodelist option in SBATCH if provided
if [ -n "$nodelist" ]; then
  SBATCH_NODELIST="--nodelist=$nodelist"
else
  SBATCH_NODELIST=""
fi

# Include memory option in SBATCH if provided
if [ -n "$mem" ]; then
  SBATCH_MEM="--mem=$mem"
else
  SBATCH_MEM=""
fi



# Default values 

# Load necessary modules
ml purge
ml load cuda/12.1
ml load gnu12/12.3.0

# Activate conda environment
eval "$(conda shell.bash hook)"
conda activate "$env_name"

pip install jupyter

# Ensure slurm_log directory exists
mkdir -p ./slurm_log

# Start Jupyter Notebook with SBATCH options

echo "Starting Jupyter Notebook on port $port with partition $SBATCH_PARTITION and nodelist $SBATCH_NODELIST"

srun $SBATCH_PARTITION $SBATCH_NODELIST $SBATCH_MEM jupyter notebook --no-browser --port="$port" 
