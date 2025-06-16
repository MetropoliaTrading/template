FROM ubuntu:latest
LABEL authors="ali"

ENTRYPOINT ["top", "-b"]