
CPU_IMAGEBASENAME := "tvm"
GPU_IMAGEBASENAME := "tvm-gpu"
REGISTRYREPO := "octoml"
REGISTRY := "docker.io"

# IMAGETAG := "331f6fd012763438c6d756be051b6e2c8a96f61c"
IMAGETAG := "latest"

CPU_IMAGENAME := REGISTRY + "/" + REGISTRYREPO + "/" + CPU_IMAGEBASENAME
CPU_IMAGEFULL := CPU_IMAGENAME + ":" + IMAGETAG

GPU_IMAGENAME := REGISTRY + "/" + REGISTRYREPO + "/" + GPU_IMAGEBASENAME
GPU_IMAGEFULL := GPU_IMAGENAME + ":" + IMAGETAG

docker-build-cpu:
    docker build -t {{CPU_IMAGEFULL}} - < Dockerfile.cpu_base

docker-build-gpu:
    docker build -t {{GPU_IMAGEFULL}} - < Dockerfile.gpu_base

docker-push-cpu:
    docker push {{CPU_IMAGEFULL}}

docker-push-gpu:
    docker push {{GPU_IMAGEFULL}}

docker-push: docker-build-cpu docker-build-gpu
    docker push {{CPU_IMAGEFULL}}
    docker push {{GPU_IMAGEFULL}}
