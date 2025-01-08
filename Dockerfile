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

# Create conda environment and install jupyterlab
RUN conda env create -f /tmp/environment.yml && \
    conda install -n uwgda-image-living -c conda-forge jupyterlab && \
    conda clean -afy

# Make RUN commands use the new conda environment
SHELL ["conda", "run", "-n", "uwgda-image-living", "/bin/bash", "-c"]

# Set up conda env activation
RUN echo "conda activate uwgda-image-living" >> ~/.bashrc

# Add conda environment to PATH and set CONDA_DEFAULT_ENV
ENV PATH /opt/conda/envs/uwgda-image-living/bin:$PATH
ENV CONDA_DEFAULT_ENV uwgda-image-living

# Set up work directory and permissions
WORKDIR /home/jovyan
RUN chown -R jovyan:jovyan /home/jovyan

# Switch to non-root user
USER jovyan

# Expose Jupyter port
EXPOSE 8888

# Start JupyterLab using conda run to ensure we're in the right environment
ENTRYPOINT ["conda", "run", "-n", "uwgda-image-living"]
CMD ["jupyter", "lab", "--ip", "0.0.0.0", "--no-browser", "--ServerApp.token=''"]
