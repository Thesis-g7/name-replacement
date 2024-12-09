#!/bin/bash

# Define the parent directory containing the folders
parent_dir="/home/g7/Desktop/names-dataset/Speech-dataset-generation/new_method_test/speaker_librispeech"

# Define the path to the train_model.sh script
train_script="$parent_dir/train_model.sh"

# Check if the train_model.sh script exists
if [ ! -f "$train_script" ]; then
    echo "Error: train_model.sh script not found at $train_script"
    exit 1
fi

# Loop over each subdirectory in the parent directory
for folder in "$parent_dir"/*/; do
    # Extract the folder name without the trailing slash
    folder_name=$(basename "$folder")

    # Run the train_model.sh script with the folder name as argument
    echo "Running train_model.sh for folder: $folder_name"
    "$train_script" "$folder_name"
done

