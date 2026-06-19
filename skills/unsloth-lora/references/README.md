## Evidence
- "LoRA: Fine-tunes small, trainable matrices in 16-bit without updating all model weights." [Source](https://docs.unsloth.ai/get-started/fine-tuning-llms-guide)
- "For optimal performance, LoRA should be applied to all major linear layers: q_proj, k_proj, v_proj, o_proj, gate_proj, up_proj, down_proj." [Source](https://docs.unsloth.ai/basics/lora-parameters-encyclopedia)
- "Set use_rslora = True... the effective scaling becomes lora_alpha / sqrt(r) instead of the standard lora_alpha / r." [Source](https://docs.unsloth.ai/basics/lora-parameters-encyclopedia)

## Expanded Workflows

### LoRA Hyperparameter Tuning
1. **Rank Selection**: Higher ranks (r) allow the model to learn more complex features but increase VRAM. For most tasks, 16-32 is the "sweet spot."
2. **Alpha Scaling**: `lora_alpha` is the scaling factor. Setting it to 1x or 2x the rank is standard. In Unsloth, `use_rslora` changes the denominator to `sqrt(r)`, allowing for higher ranks without exploding gradients.
3. **Target Modules**: To reach full fine-tuning parity, Unsloth suggests targeting all linear layers. This prevents the bottleneck of only adapting attention layers.
4. **Optimization**: Ensure `lora_dropout` is 0 unless the model is severely overfitting; the performance gain from optimized kernels is substantial.