# Steps to build bpy

## Linux

1. Change directory to this path: `cd ./docker/bpy`
2. Create `bpy` image: `DOCKER_BUILDKIT=1 docker build -t bpy:latest --output out .`
   - See [here][1] to learn about `--output` and why we have two different stages
3. The `bpy` module will be at `./out` directory

## MacOS

1. Make sure you have:
   - `cmake`
   - Python executable at: `/Library/Frameworks/Python.framework/Versions/3.10/bin/python3.10`
     - Don't use homebrew. Download the Installer from https://www.python.org/downloads/macos/. This automatically change the default python system-wide to the latest version.
1. `mkdir blender-git; cd blender-git;`
1. `git clone https://github.com/blender/blender.git -b blender-v3.1-release --depth 1`
1. `cd blender-git/blender`
1. `make update`
   - It creates `blender-git/lib` folder
1. `make bpy`
1. Outputs:
   - `/Library/Frameworks/Python.framework/Versions/3.10/lib/python3.10/Resources/3.1/**`
   - `/Library/Frameworks/Python.framework/Versions/3.10/lib/python3.10/site-packages/bpy.so`
   - `blender-git/build_darwin_bpy/bin/Blender.app/Contents/Resources/**`
   - `blender-git/build_darwin_bpy/bin/Blender.app/Contents/PkgInfo`

[1]: https://docs.docker.com/engine/reference/commandline/build/#custom-build-outputs
