# Test UID in Scratch Containers

- [Build Executable](#build-executable)
- [Scratch Build](#scratch-build)
- [Multi Stage Scratch Build](#multi-stage-scratch-build)

## Build Executable

I'm testing on arm64

```bash
GOARCH=arm64 CGO_ENABLED=0 GOOS=linux  go build -o sleep
```

## Scratch Build

```Dockerfile
cat << EOF > Dockerfile
FROM scratch

USER 1001:1001
COPY sleep /sleep
CMD ["/sleep"]
EOF
```

Build and Push 

```bash
docker build -t docker.io/cmwylie19/test-scratch-image .
docker push docker.io/cmwylie19/test-scratch-image
```

Output of running container

```bash
rock@controlplane:~$ sudo ps aux | egrep '/sleep' 
db       2163519  0.0  0.0 710576   916 ?        Ssl  10:30   0:00 /sleep
```

_Remove the container from the box_

## Multi Stage Scratch Build


```Dockerfile
cat << EOF > Dockerfile
# Stage 0
FROM ubuntu:latest
RUN useradd -u 10001 scratchuser

# Stag 1
FROM scratch
COPY sleep /sleep
COPY --from=0 /etc/passwd /etc/passwd
USER scratchuser
CMD ["/sleep"]
EOF
```

Build and Push 

```bash
docker build -t docker.io/cmwylie19/test-scratch-image .
docker push docker.io/cmwylie19/test-scratch-image
```


Output of running container

```bash
rock@controlplane:~$ ps aux | egrep "/sleep"
10001    2179317  0.2  0.0 710576   916 ?        Ssl  10:45   0:00 /sleep
```