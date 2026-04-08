@echo off
chcp 65001 >nul
setlocal

set "SCRIPT_DIR=%~dp0"

set "CHUNKS=C:\gold\chunks_gold.jsonl"
set "OUT_ROOT=C:\gold"

set "BASE_NAME=gold"
set "MODEL=intfloat/multilingual-e5-base"
set "BACKEND=torch"
REM set "BACKEND=onnx"
REM set "BACKEND=openvino"
set "BATCH=128"

set "BLOCK_SIZE=5000"
set "BLOCK_START=0"
set "BLOCK_END=-1"

echo Running backend=%BACKEND% batch=%BATCH% block=%BLOCK_START%-%BLOCK_END%

python "%SCRIPT_DIR%block_embeddings_builder.py" ^
  --chunks "%CHUNKS%" ^
  --out-root "%OUT_ROOT%" ^
  --base-name "%BASE_NAME%" ^
  --model "%MODEL%" ^
  --backend "%BACKEND%" ^
  --batch %BATCH% ^
  --block-size %BLOCK_SIZE% ^
  --block-start %BLOCK_START% ^
  --block-end %BLOCK_END%

pause
