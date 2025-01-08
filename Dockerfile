# Dockerfile
FROM continuumio/miniconda3:latest

# Copy environment files
COPY environment.yml /tmp/environment.yml
COPY apt.txt /tmp/apt.txt

# Install system dependencies
RUN apt-get update && \
    xargs apt-get install -y < /tmp/apt.txt && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create conda environment
RUN conda env create -f /tmp/environment.yml && \
    conda clean -afy

# Add conda environment to PATH
ENV PATH /opt/conda/envs/$(head -1 /tmp/environment.yml | cut -d' ' -f2)/bin:$PATH

# Set the shell to bash
SHELL ["/bin/bash", "-c"]
ENTRYPOINT ["bash"]
