#!/bin/sh
docker run --rm -v "$(pwd)/host:/host" --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -d --name binexp-lab -i binexp-lab:ubuntu22.04
