# Architecture

## Role in the pipeline

This repository implements the embeddings stage of a larger OCR → RAG workflow.

Pipeline position:

cleaned chunks → embeddings → vector-ready outputs

Related preprocessing stage:
- OCR cleaning and chunk preparation:
  https://github.com/sergey-automation/ocr-rag-pipeline

## Input

Input data is provided as a JSONL file with prepared text chunks.

Typical input:
- one JSON object per line
- chunk text stored in the `text` field
- metadata preserved for downstream search / merge workflows

## Processing model

The program processes the dataset sequentially and writes results in independent blocks.

Main properties:
- block-based execution
- configurable block size
- configurable block range
- backend selection:
  - torch
  - onnx
  - openvino

## Output

For each completed block, the pipeline writes a triplet of files:

- embeddings part (`.npy`)
- metadata part (`.npz`)
- block info / status (`.json`)

Output layout:

`OUT_ROOT/<base_name>_e5_base_<backend>/parts/`

This structure allows:
- resumable execution
- distributed processing across multiple machines
- later merge/index stages without recomputing finished blocks

## Resume logic

A block is considered completed only if all required output files already exist.

If the process is interrupted, rerun starts from the last missing block instead of recomputing the whole dataset.

## Distributed execution

Block range is controlled from the batch file using:

- `BLOCK_START`
- `BLOCK_END`

This makes it possible to split one dataset across multiple machines.

Example:
- machine 1: blocks 0–5
- machine 2: blocks 5–10
- machine 3: blocks 10–15

## Engineering focus

This project is designed for:

- large corpora
- long-running CPU jobs
- reproducible benchmarking
- backend comparison on real datasets
- integration with vector search / RAG pipelines
