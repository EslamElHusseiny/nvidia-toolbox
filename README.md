# Deeplearning Toolbox in a Docker Container with NVIDIA GPU

This is one docker container that includes everything you need as a data scientest to build expierements quickly. This contains simple tools like R, numpy and sklearn, and descent deeplearning libraries that run on GPUs like Thenao, Keras, Tensorflow and Torck, and finally Apache Spark 6 and you can choose to run it on cluster not just local. So let's get started...

## Requirements
1. A PC or a laptop with Nvidia GPU and linux
2. CUDA driver
2. Docker engine

## Installing the container

```bash
git clone git@github.com:dosht/nvidia-toolbox.git
cd nvidia-toolbox
./buildme
./runme
```

To verify installation open [http://localhost:8888/](http://localhost:8888/).

Now, click on new and see the available kernels. You will see Bash, Python2, Python3, R, Scala 2.10.4 (Spark 1.6) and iTorch.

## Jupyter for R
R is a free software environment for statistical computing and graphics. It compiles and runs on a wide variety of UNIX platforms, Windows and MacOS.
![Jupyter R](https://scontent-lhr3-1.xx.fbcdn.net/hphotos-xft1/v/t35.0-12/12809854_1011915482187816_351941862_o.jpg?oh=e9d61b5f24a847c501774867d081026f&oe=56DCC605)
## Jupyter for numpy, sklearn and nlp
To enable plotting in the notebook, you need to start you notebook at the first cell with:
```python
%pylab inline
```
![Jupyter for sklearn](https://scontent-lhr3-1.xx.fbcdn.net/hphotos-xft1/v/t35.0-12/12823175_1011915495521148_830131324_o.jpg?oh=c9fe0764f50319796d0680294e878416&oe=56DE0A0B)
## Jupyter for Theano, Keras and Tensorflow
![Jupyter Keras](https://scontent-lhr3-1.xx.fbcdn.net/hphotos-xfa1/v/t35.0-12/12810388_1011915485521149_1750620026_o.jpg?oh=0acce84df7757a75f66ae675c8354c41&oe=56DD9BCB)
## Jupyter for Torch
![Jupyter iTorck](https://scontent-lhr3-1.xx.fbcdn.net/hphotos-xpt1/v/t35.0-12/12809816_1011915492187815_211112466_o.jpg?oh=52bcbc9b9f28ddf049bfa8140eb64522&oe=56DDCF63)
## Jupyter for Apache Spark
![Jupyter Spark](https://scontent-lhr3-1.xx.fbcdn.net/hphotos-xfl1/v/t35.0-12/12837244_1011915488854482_1273084670_o.jpg?oh=7aade9f5a6fd8c349eac8f801e11cea2&oe=56DDBE02)
### Spark notebook magics

### Running Spark notebook on a cluster
