ARG bpy_install_path="/root/.local/lib/python3.10/site-packages"

###########################
######## Stage 1/2 ########
###########################
FROM ubuntu:20.04 AS build-stage

# to load global "bpy_install_path" value in this stage
ARG bpy_install_path

RUN export DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y nano git
RUN DEBIAN_FRONTEND=noninteractive apt install -y software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt install -y python3.10
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1


RUN apt update
RUN apt install -y build-essential git subversion cmake libx11-dev libxxf86vm-dev libxcursor-dev libxi-dev libxrandr-dev libxinerama-dev libglew-dev

WORKDIR /blender-git/lib
#COPY ./linux_centos7_x86_64/ /blender-git/lib/linux_centos7_x86_64/
RUN svn checkout https://svn.blender.org/svnroot/bf-blender/trunk/lib/linux_centos7_x86_64; exit 0
WORKDIR /blender-git/lib/linux_centos7_x86_64
RUN svn cleanup
RUN svn up


WORKDIR /blender-git/
RUN git clone https://github.com/blender/blender.git -b blender-v3.1-release --depth 1

WORKDIR /blender-git/blender/
RUN make update
RUN make bpy

WORKDIR /blender-git/build_linux_bpy
# See `python3.10 -m site` for site-package pathes

RUN mkdir -p ${bpy_install_path}
RUN cmake . -DWITH_INSTALL_PORTABLE=ON -DCMAKE_INSTALL_PREFIX=${bpy_install_path}
#RUN cmake . -DWITH_PYTHON_INSTALL=OFF -DWITH_AUDASPACE=OFF -DWITH_PYTHON_MODULE=ON -DWITH_INSTALL_PORTABLE=ON -DCMAKE_INSTALL_PREFIX=${bpy_install_path}
RUN make install


###########################
######## Stage 2/2 ########
###########################
FROM scratch AS export-stage
# to load global "bpy_install_path" value in this stage
ARG bpy_install_path
COPY --from=build-stage ${bpy_install_path} /