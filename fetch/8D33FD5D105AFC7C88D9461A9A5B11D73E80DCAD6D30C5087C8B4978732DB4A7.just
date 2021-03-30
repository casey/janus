wkhtmltopdf_function_name := "wkhtmltopdf-rust"
wkhtmltopdf_layer_name := "wkhtmltopdf"
wkhtmltopdf_layer_zip := "https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-4/wkhtmltox-0.12.6-4.amazonlinux2_lambda.zip"

build:
    cargo build --release --target x86_64-unknown-linux-musl

clean:
    rm -rf ./target/lambda ./target/lambda.zip ./wkhtmltopdf.zip ./output.json

pack bundle_wkhtmltopdf="":
    just build
    mkdir -p ./target/lambda
    if [[ -n "{{bundle_wkhtmltopdf}}" ]]; then \
        wget -O ./wkhtmltopdf.zip "{{wkhtmltopdf_layer_zip}}"; \
        unzip ./wkhtmltopdf.zip -d ./target/lambda; \
    fi
    cp ./target/x86_64-unknown-linux-musl/release/wkhtmltopdf-lambda ./target/lambda/bootstrap
    cd ./target/lambda && zip -r ../lambda.zip ./*

create-layer:
    wget -O wkhtmltopdf.zip "{{wkhtmltopdf_layer_zip}}"
    aws lambda publish-layer-version --layer-name "{{wkhtmltopdf_layer_name}}" --zip-file fileb://./wkhtmltopdf.zip
    just clean

get-layer bundle_wkhtmltopdf="":
    if [[ -n "{{bundle_wkhtmltopdf}}" ]]; then \
        printf ''; \
    else \
        printf -- '--layers %s' "$(aws --output text lambda list-layer-versions --layer-name {{wkhtmltopdf_layer_name}} | cut -d $'\t' -f 3 | head -n 1)"; \
    fi

create-function bundle_wkhtmltopdf="":
    just pack "{{bundle_wkhtmltopdf}}"
    aws lambda create-function --function-name "{{wkhtmltopdf_function_name}}" --handler "{{wkhtmltopdf_function_name}}" --runtime provided.al2 \
        --zip-file fileb://./target/lambda.zip --role "$LAMBDA_ROLE" --environment Variables={RUST_BACKTRACE=1} --tracing-config Mode=Active \
        --timeout 30 --memory-size 512 \
        $(just get-layer "{{bundle_wkhtmltopdf}}")
    just clean

update-function bundle_wkhtmltopdf="":
    just pack "{{bundle_wkhtmltopdf}}"
    aws lambda update-function-code --function-name "{{wkhtmltopdf_function_name}}" --zip-file fileb://./target/lambda.zip --publish
    just clean

test-function:
    aws lambda invoke --function-name "{{wkhtmltopdf_function_name}}" \
        --payload '{"pages": [{"type": "TOC"}, {"type": "PAGE", "htmlUrl": "https://github.com"}], "output": {"bucket": "wkhtmltopdf", "objectKey": "pdfs/github.com.pdf"}}' \
        ./output.json
    if [[ "$(jq '.success' ./output.json)" == "true" ]]; then \
        aws s3 cp s3://wkhtmltopdf/pdfs/github.com.pdf ./github.com.pdf; \
    else \
        printf 'Invocation failed:\n'; \
        cat ./output.json; \
    fi
    just clean
