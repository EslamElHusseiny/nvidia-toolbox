FROM ubuntu:14.04
MAINTAINER Mostafa Abdulhamid <lambda.mostafa@gmail.com>

# Install Cuda
# Install OS dependencies for fully functional notebook server
RUN echo "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1404/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
    apt-get update && apt-get install -yq --no-install-recommends --force-yes \
    git \
    vim \
    wget \
    build-essential \
    python-dev \
    ca-certificates \
    bzip2 \
    unzip \
    libsm6 \
    pandoc \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-fonts-extra \
    texlive-fonts-recommended \
    sudo \
    libgfortran3 \
# Install Julia and iJulia
#    julia \
    libzmq3-dev \
    libssl-dev \
    python-zmq \
    software-properties-common \
    "cuda-toolkit-7.5" && \
#    libnettle4 && \
    wget -q -O - http://developer.download.nvidia.com/compute/cuda/repos/GPGKEY | apt-key add - && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    # Install java8
    (echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections) && \
    apt-get install -y oracle-java8-installer oracle-java8-set-default && \
    apt-get clean

ENV CUDA_VERSION 7.5
LABEL com.nvidia.cuda.version="7.5"

RUN echo "/usr/local/cuda/lib" >> /etc/ld.so.conf.d/cuda.conf && \
    echo "/usr/local/cuda/lib64" >> /etc/ld.so.conf.d/cuda.conf && \
    ldconfig && \
    echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

#################################################################
######################### ENV VARIABLES #########################
#TODO: change to user dosht
#ENV PATH /home/dosht/.cabal/bin:/opt/cabal/1.22/bin:/opt/ghc/7.8.4/bin:/opt/happy/1.19.4/bin:/opt/alex/3.1.3/bin:$PATH
ENV PATH="/usr/local/cuda/bin:${PATH}" \
    LD_LIBRARY_PATH="/usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}" \
    CONDA_DIR="/opt/conda" \
    SHELL="/bin/bash" \
    NB_USER="dosht" \
    NB_UID="1000" \
    JAVA_HOME="/usr/lib/jvm/java-8-oracle" \
    APACHE_SPARK_VERSION="1.6.0" \
    SPARK_HOME="/usr/local/spark" \
    THEANO_FLAGS='mode=FAST_RUN,device=gpu,nvcc.fastmath=True,cnmem=.75,floatX=float32'
ENV PATH="/root/.cabal/bin:/opt/cabal/1.22/bin:/opt/ghc/7.8.4/bin:/opt/happy/1.19.4/bin:/opt/alex/3.1.3/bin:$CONDA_DIR/bin:$JAVA_HOME/bin:$PATH" \
    PYTHONPATH="$SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.8.2.1-src.zip"

# Install conda
RUN mkdir -p $CONDA_DIR && \
    echo export PATH=$CONDA_DIR/bin:'$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-3.9.1-Linux-x86_64.sh && \
    echo "6c6b44acdd0bc4229377ee10d52c8ac6160c336d9cdd669db7371aa9344e1ac3 *Miniconda3-3.9.1-Linux-x86_64.sh" | sha256sum -c - && \
    /bin/bash /Miniconda3-3.9.1-Linux-x86_64.sh -f -b -p $CONDA_DIR && \
    rm Miniconda3-3.9.1-Linux-x86_64.sh && \
    $CONDA_DIR/bin/conda install --yes conda==3.14.1

# Install Jupyter notebook
RUN conda install --yes \
    'notebook=4.0*' \
    terminado \
    && conda clean -yt

# Spark dependencies
RUN wget -qO - http://d3kbcqa49mib13.cloudfront.net/spark-${APACHE_SPARK_VERSION}-bin-hadoop2.6.tgz | tar -xz -C /usr/local/ && \
    cd /usr/local && \
    ln -s spark-${APACHE_SPARK_VERSION}-bin-hadoop2.6 spark

RUN pip install toree && \
    jupyter toree install

## Now for a python2 environment
RUN conda create -p $CONDA_DIR/envs/python2 python=2.7 ipykernel numpy pandas scikit-learn scikit-image matplotlib scipy seaborn sympy cython patsy statsmodels cloudpickle dill numba bokeh && conda clean -yt

# Python packages
RUN conda install --yes numpy pandas scikit-learn scikit-image matplotlib scipy nltk seaborn sympy cython patsy statsmodels cloudpickle dill numba bokeh beautiful-soup theano && conda clean -yt
RUN pip install --no-cache-dir keras

#################################################################
################## Install other kernels ########################

# Install python 2 kernel
RUN $CONDA_DIR/envs/python2/bin/python \
    $CONDA_DIR/envs/python2/bin/ipython \
    kernelspec install-self --user

# Install bash kernel
RUN pip install --no-cache-dir bash_kernel && \
    python -m bash_kernel.install

# R
RUN conda config --add channels r && \
    conda install --yes r-irkernel r-plyr r-devtools r-rcurl r-dplyr r-ggplot2 r-caret rpy2 r-tidyr r-shiny r-rmarkdown r-forecast r-stringr r-rsqlite r-reshape2 r-nycflights13 r-randomforest && conda clean -yt

# RUN julia -e 'Pkg.add("IJulia")' && \
#     julia -e 'Pkg.add("Gadfly")' && julia -e 'Pkg.add("RDatasets")'

# Install Torch 7
RUN cd /opt && \
    wget https://raw.githubusercontent.com/torch/ezinstall/master/install-deps && \
    bash install-deps

RUN git clone https://github.com/torch/distro.git /opt/torch --recursive && \
    cd /opt/torch && ./install.sh

# Iinstall iTorch
RUN git clone https://github.com/facebook/iTorch.git /opt/iTorch && \
    cd /opt/iTorch && \
    . /opt/torch/install/bin/torch-activate && \
    sudo env "PATH=$PATH" luarocks make

WORKDIR /docker

###################################################
#################### TODO #########################
# 0. Add nginx
# 1. Add user dosht
# 2. Organize file stucture
# 3. Add iTorch - [in progress]
# 4. Add matlab
# 5. Add Octave
# 6. Add C++
# 7. Add Java
# 8. Add Common Lisp
# 9. Add cloujre
###################################################
#CMD bash
CMD jupyter notebook --port=8888 --ip=127.0.0.1
#CMD jupyter notebook --port=80 --ip=0.0.0.0
