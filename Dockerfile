# Dockerfile
FROM continuumio/miniconda3:latest

# Create non-root user similar to jupyter's default 'jovyan'
RUN useradd -ms /bin/bash jovyan
USER root

# Copy environment files
COPY environment.yml /tmp/environment.yml
COPY apt.txt /tmp/apt.txt

# Install system dependencies
RUN apt-get update && \
    grep -v '^#' /tmp/apt.txt | xargs apt-get install -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create conda environment
RUN conda env create -f /tmp/environment.yml && \
    conda clean -afy

# Add jupyterlab to environment
RUN conda install -n gda -c conda-forge jupyterlab && \
    conda clean -afy

# Add conda environment to PATH
ENV PATH /opt/conda/envs/gda/bin:$PATH

# Set up work directory and permissions
WORKDIR /home/jovyan
RUN chown -R jovyan:jovyan /home/jovyan

# Switch to non-root user
USER jovyan

# Expose Jupyter port
EXPOSE 8888

# Start JupyterLab
CMD ["jupyter", "lab", "--ip", "0.0.0.0", "--no-browser", "--ServerApp.token=''"]

---
# docker-compose.yml
version: "3.9"
services:
  jupyterlab:
    image: "ghcr.io/uw-gda/uwgda-image-living:latest"
    ports:
      - "8888:8888"
    volumes:
      - ${PWD}:/home/jovyan
    user: "1000:1000"  # This matches typical Linux UID:GID for first user
