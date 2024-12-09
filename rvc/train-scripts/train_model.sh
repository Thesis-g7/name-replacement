#!/bin/bash


if [ -z "$1" ]; then
  echo "Usage: $0 <speaker id>"
  exit 1
fi

id=$1  # Assign the provided argument to a variable

# Step 1: Create the required directory
mkdir -p /home/g7/Retrieval-based-Voice-Conversion-WebUI/logs/$id

echo "created log $id"

# Step 2: Run the preprocess script
/home/g7/anaconda3/envs/rvc_env/bin/python infer/modules/train/preprocess.py \
"/home/g7/Desktop/names-dataset/Speech-dataset-generation/new_method_test/speaker_librispeech/$id" \
40000 16 "/home/g7/Retrieval-based-Voice-Conversion-WebUI/logs/$id" False 3.7 \
/home/g7/Desktop/names-dataset/Speech-dataset-generation/new_method_test/speaker_librispeech/$id \
40000 16 /home/g7/Retrieval-based-Voice-Conversion-WebUI/logs/$id False 3.7

# Step 3: Run the extract_f0_rmvpe.py script
/home/g7/anaconda3/envs/rvc_env/bin/python infer/modules/train/extract/extract_f0_rmvpe.py 2 1 0 \
"/home/g7/Retrieval-based-Voice-Conversion-WebUI/logs/$id" True

# Step 4: Run the extract_feature_print.py script
/home/g7/anaconda3/envs/rvc_env/bin/python infer/modules/train/extract_feature_print.py cuda:0 1 0 0 \
"/home/g7/Retrieval-based-Voice-Conversion-WebUI/logs/$id" v2 True

# Step 5: Touch config.json and add content
touch /home/g7/Retrieval-based-Voice-Conversion-WebUI/logs/$id/config.json

# Write the config content to config.json
cat <<EOL > /home/g7/Retrieval-based-Voice-Conversion-WebUI/logs/$id/config.json
{
    "data": {
        "filter_length": 2048,
        "hop_length": 400,
        "max_wav_value": 32768.0,
        "mel_fmax": null,
        "mel_fmin": 0.0,
        "n_mel_channels": 125,
        "sampling_rate": 40000,
        "win_length": 2048
    },
    "model": {
        "filter_channels": 768,
        "gin_channels": 256,
        "hidden_channels": 192,
        "inter_channels": 192,
        "kernel_size": 3,
        "n_heads": 2,
        "n_layers": 6,
        "p_dropout": 0,
        "resblock": "1",
        "resblock_dilation_sizes": [
            [1, 3, 5],
            [1, 3, 5],
            [1, 3, 5]
        ],
        "resblock_kernel_sizes": [3, 7, 11],
        "spk_embed_dim": 109,
        "upsample_initial_channel": 512,
        "upsample_kernel_sizes": [16, 16, 4, 4],
        "upsample_rates": [10, 10, 2, 2],
        "use_spectral_norm": false
    },
    "train": {
        "batch_size": 4,
        "betas": [0.8, 0.99],
        "c_kl": 1.0,
        "c_mel": 45,
        "epochs": 20000,
        "eps": 1e-09,
        "fp16_run": true,
        "init_lr_ratio": 1,
        "learning_rate": 0.0001,
        "log_interval": 200,
        "lr_decay": 0.999875,
        "seed": 1234,
        "segment_size": 12800,
        "warmup_epochs": 0
    }
}
EOL

/home/g7/Desktop/names-dataset/Speech-dataset-generation/new_method_test/speaker_librispeech/preprocess.sh "$id"

/home/g7/anaconda3/envs/rvc_env/bin/python infer/modules/train/train.py \
-e "$id" -sr 40k -f0 1 -bs 12 -g 0 -te 50 -se 5 \
-pg assets/pretrained_v2/f0G40k.pth -pd assets/pretrained_v2/f0D40k.pth -l 0 -c 0 -sw 0 -v v2

rm -r /home/g7/Retrieval-based-Voice-Conversion-WebUI/logs/$id

