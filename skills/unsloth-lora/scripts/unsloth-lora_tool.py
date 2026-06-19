import argparse

def configure_lora(rank, alpha, use_rslora=False, dropout=0.0):
    """
    Generates the configuration for Unsloth get_peft_model.
    """
    config = {
        "r": rank,
        "target_modules": [
            "q_proj", "k_proj", "v_proj", "o_proj",
            "gate_proj", "up_proj", "down_proj",
        ],
        "lora_alpha": alpha,
        "lora_dropout": dropout,
        "bias": "none",
        "use_gradient_checkpointing": "unsloth",
        "random_state": 3407,
        "use_rslora": use_rslora,
    }
    return config

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Unsloth LoRA Configurator")
    parser.add_argument("--rank", type=int, default=16)
    parser.add_argument("--alpha", type=int, default=16)
    parser.add_argument("--rslora", action="store_true")
    args = parser.parse_args()
    
    print(f"Generated Config: {configure_lora(args.rank, args.alpha, args.rslora)}")