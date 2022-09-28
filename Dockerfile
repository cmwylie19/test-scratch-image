# Stage 0
FROM ubuntu:latest
RUN useradd -u 10001 scratchuser

# Stag 1
FROM scratch
COPY sleep /sleep
COPY --from=0 /etc/passwd /etc/passwd
USER scratchuser
CMD ["/sleep"]
