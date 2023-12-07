These image are CentOS Stream image, which is download by podman from here: [stream9-minimal](https://quay.io/repository/centos/centos?tab=tags&tag=stream9)

Command to pull:

Only 2 arch is available: amd64, arm64

> podman pull --arch=arm64 quay.io/centos/centos:stream9-minimal

Command to save the file:

> podman save --format docker-archive -o stream9-arm64.tar centos:stream9-minimal