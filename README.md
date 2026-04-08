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

## Test configuration

Model: intfloat/multilingual-e5-base  
Embedding dim: 768  
CPU: AMD Ryzen 5 5625U  

## Dataset

- total chunks: 117800
- avg chunk size: ~160 words (~512 tokens)

## Performance (avg)

- torch: 2.99 chunks/s
- onnx: 2.86 chunks/s
- openvino: 2.70 chunks/s
