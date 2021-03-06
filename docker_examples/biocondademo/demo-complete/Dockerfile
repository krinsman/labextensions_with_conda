FROM ubuntu:16.04
LABEL maintainer="William Krinsman <krinsman@berkeley.edu>"

# Base Ubuntu packages.
ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8
# Make sure the Ubuntu image is up-to-date.
RUN \
    apt-get update          &&  \
    apt-get --yes upgrade   &&  \
    apt-get --yes install       \
        bzip2                   \
        curl                    \
        git                     \
        libffi-dev              \
        lsb-release             \
        tzdata                  \
        vim                     \
        wget

# Set timezone to Berkeley
ENV TZ=America/Los_Angeles
RUN \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime  &&  \
    echo $TZ > /etc/timezone

# Install conda (via miniconda), clean up, update.
RUN \
    wget -q -O /tmp/miniconda3.sh https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh    &&  \
    bash /tmp/miniconda3.sh -f -b -p /opt/anaconda                     &&  \
    rm -rf /tmp/miniconda3.sh                                          &&  \
    /opt/anaconda/bin/conda update --yes conda
# Set up BASH settings to work with conda:
RUN \
    echo ". /opt/anaconda/etc/profile.d/conda.sh" >> ~/.bashrc         && \
    echo "conda activate" >> ~/.bashrc                                 && \
    # Create an alias so that running notebook from the container isn't such a pain.
    echo "alias jupyter=\"jupyter notebook --ip=0.0.0.0 --port=8888 --allow-root\"" >> ~/.bashrc
# Add YAML file from directory to the Docker container.                       
COPY environment.yml .
# Create a new conda environment from the YAML file.
RUN /opt/anaconda/bin/conda env create -f environment.yml
# Add conda to the path
ENV PATH=/opt/anaconda/bin:$PATH
WORKDIR /tmp
# Add the shell script in the directory to the Docker container
COPY reproduce.sh .
# Make it executable
RUN chmod +x reproduce.sh
