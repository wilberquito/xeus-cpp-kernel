FROM ubuntu:18.04

LABEL maintainer="Wilber B. Quito typingwil@gmail.com"

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    wget \
    bzip2 \
    && rm -rf /var/lib/apt/lists/*

# Install Miniconda
RUN mkdir -p /opt/miniconda3 && \
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /opt/miniconda3/miniconda.sh && \
    bash /opt/miniconda3/miniconda.sh -b -u -p /opt/miniconda3 && \
    rm /opt/miniconda3/miniconda.sh

# Make sure conda is available in PATH
ENV PATH=/opt/miniconda3/bin:$PATH

# Create conda environment, activate it, and install necessary packages
RUN /opt/miniconda3/bin/conda create -n cpp python=3.11 -y && \
    bash -c "source /opt/miniconda3/bin/activate cpp && \
    conda install xeus-cling -c conda-forge -y && \
    pip install notebook==7.2.1"

# Set the working directory
WORKDIR /cpp

# Copy files into working directory
COPY . .

# Activate the environment by default
CMD ["bash", "-c", "source /opt/miniconda3/bin/activate cpp && jupyter notebook --ip=0.0.0.0 --no-browser --allow-root"]
