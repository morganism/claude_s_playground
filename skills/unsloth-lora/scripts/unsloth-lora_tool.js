/**
 * Helper to format LoRA parameters for documentation or configuration files.
 */
function getLoRAConfig(rank, alpha, useRslora = false) {
    return {
        r: rank,
        lora_alpha: alpha,
        use_rslora: useRslora,
        lora_dropout: 0, // Recommended by Unsloth for speed
        target_modules: ["q_proj", "k_proj", "v_proj", "o_proj", "gate_proj", "up_proj", "down_proj"]
    };
}

const args = process.argv.slice(2);
const r = parseInt(args[0]) || 16;
const a = parseInt(args[1]) || 16;
const rs = args[2] === 'true';

console.log(JSON.stringify(getLoRAConfig(r, a, rs), null, 2));