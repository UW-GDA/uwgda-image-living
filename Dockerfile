# Dockerfile
FROM jupyter/minimal-notebook:latest

ENV PROJ_LIB=/opt/conda/share/proj/
# Install system dependencies
COPY apt.txt /tmp/apt.txt
USER root
RUN apt-get update && \
    xargs apt-get install -y < /tmp/apt.txt && \
    apt-get install -y sqlite3 libsqlite3-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Switch back to jovyan user
USER ${NB_UID}

# Copy environment.yml
COPY environment.yml /tmp/environment.yml

# Create conda environment
RUN mamba env update -n base -f /tmp/environment.yml && \
    mamba clean --all -f -y
