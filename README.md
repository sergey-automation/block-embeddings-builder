# Block Embeddings Builder

Block-based embeddings builder for large JSONL corpora.

## Features

- block processing (default: 5000 chunks per block)
- resume after interruption
- distributed processing (chunk ranges)
- multiple backends:
  - torch
  - onnx
  - openvino

## Quick Start

1. Prepare input JSONL file (chunks)

2. Edit `scripts/RUN_block_embeddings_builder.bat`:

- set paths:
  - CHUNKS
  - OUT_ROOT
- choose backend:
  - torch / onnx / openvino
- optionally set block range:
  - BLOCK_START / BLOCK_END

3. Run:

```bat
scripts\RUN_block_embeddings_builder.bat
```

## Test configuration

Model: intfloat/multilingual-e5-base  
Embedding dim: 768  
CPU: AMD Ryzen 5 5625U  

## Dataset

- total chunks: 117 800
- avg chunk size: ~160 words (~352 tokens)

## Performance (avg)

- torch: 2.99 chunks/s
- onnx: 2.86 chunks/s
- openvino: 2.70 chunks/s

## Pipeline

### 1. Chunk generation

Chunks are generated from cleaned text with constraints:

- max words per chunk: 222
- overlap: 10 words

Chunk size:

- average: ~160 words (~352 tokens at x2.2)
- maximum: 222 words (~488 tokens at x2.2, below the 512-token target)

Report:
- reports/chunks_512_e5_input.txt

---

### 2. Embedding

Embeddings are built in blocks:

- block size: 5000 chunks
- resume supported (continues from last completed block)
- supports distributed execution via block ranges
- block range is configured in the .bat file (BLOCK_START / BLOCK_END), allowing parallel processing across multiple machines
---

### 3. Backend comparison

All runs were executed on the same dataset (117800 chunks).

| Backend   | Speed (chunks/sec) |
|----------|--------------------|
| torch    | 2.99 |
| onnx     | 2.86 |
| openvino | 2.70 |

Reports:

- reports/gold_0704_e5_base_torch.txt
- reports/gold_0904_e5_base_onnx.txt
- reports/gold_0604_e5_base_openvino.txt

---

## Key engineering points

- no full dataset loading into RAM
- block-based processing (scalable)
- resume after interruption
- reproducible runs
- backend-agnostic design

---

## Conclusion

On this setup (Ryzen 5 5625U), standard torch backend showed the best performance.

Optimized backends (ONNX, OpenVINO) did not provide speedup on this workload.

### Visual comparison
Backend performance (chunks/sec)

torch : 2.99 ███████████████████
onnx : 2.86 ██████████████████
openvino : 2.70 █████████████████
