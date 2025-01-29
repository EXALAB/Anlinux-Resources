These image are CentOS Stream image, which is download by podman from here: [stream10-minimal](https://quay.io/repository/centos/centos?tab=tags&tag=stream10)

Command to pull:

Only 2 arch is available: amd64, arm64

> podman pull --arch=arm64 quay.io/centos/centos:stream10-minimal

Command to save the file:

> podman save --format docker-archive -o stream10-arm64.tar centos:stream10-minimal