#!/bin/bash

# Check if the user provided a replacement value for 1098
if [ -z "$1" ]; then
  echo "Usage: $0 <replacement_for_1098>"
  exit 1
fi

id=$1  # Assign the provided argument to a variable

# Define the directories containing the .wav and .npy files
zero_dir="/home/g7/Retrieval-based-Voice-Conversion-WebUI/logs/$id/0_gt_wavs"
three_dir="/home/g7/Retrieval-based-Voice-Conversion-WebUI/logs/$id/3_feature768"
two_a_dir="/home/g7/Retrieval-based-Voice-Conversion-WebUI/logs/$id/2a_f0"
two_b_dir="/home/g7/Retrieval-based-Voice-Conversion-WebUI/logs/$id/2b-f0nsf"

output="/home/g7/Retrieval-based-Voice-Conversion-WebUI/logs/$id/filelist.txt"  # Output file where you will write the results

# Clear the output file
> "$output"

# Loop through each .wav file in the zero_dir
for wav_file in "$zero_dir"/*.wav; do
    # Extract the base name (removing the directory path and .wav extension)
    base_name_wav=$(basename "$wav_file" .wav)

    # Find the corresponding .npy files in the respective directories
    npy_file_0="$three_dir/$base_name_wav.npy"
    npy_file_1="$two_a_dir/$base_name_wav.wav.npy"
    npy_file_2="$two_b_dir/$base_name_wav.wav.npy"

    # Check if all .npy files exist
    if [ -f "$npy_file_0" ] && [ -f "$npy_file_1" ] && [ -f "$npy_file_2" ]; then
        # Write the full file paths to the output file
        echo "$wav_file|$npy_file_0|$npy_file_1|$npy_file_2|0" >> "$output"
    fi
done

echo "Processing complete. Results are in $output."

