DOCKER_IMAGE := "embed-rs"

build:
    cargo build --release

build-docker:
    docker build -t {{DOCKER_IMAGE}} .

run:
    ORT_DYLIB_PATH=./target/release/libonnxruntime.so cargo run --release

run-docker:
    docker run -p 50052:50052 {{DOCKER_IMAGE}}

perf-test-for-text:
    ghz --insecure --enable-compression --proto ./pb/encoder/encoder.proto --call encoder.Encoder.EncodeText -d '{"texts":"{randomString 16 }"}' -c 10 -z 1h --load-schedule=step --load-start=50 --load-end=300 --load-step=10 --load-step-duration=10s 0.0.0.0:50052

unit-test:
    cargo test

coverage:
    ORT_DYLIB_PATH=./target/release/libonnxruntime.so cargo tarpaulin -o xml --output-dir coverage --skip-clean

watch-test:
    ORT_DYLIB_PATH=./target/release/libonnxruntime.so cargo watch -x test -d 2

watch-run:
    ORT_DYLIB_PATH=./target/release/libonnxruntime.so cargo watch -x run

download-models:
    poetry run convert_text_model
    poetry run convert_image_model
