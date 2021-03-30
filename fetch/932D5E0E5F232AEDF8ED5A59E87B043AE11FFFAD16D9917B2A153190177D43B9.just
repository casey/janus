alias b := both

# build stuff
build:
    @ cd build && make && cd {{invocation_directory()}}

# init stuff
init:
    @ just clean
    @ mkdir build && cd build && cmake .. && cd {{invocation_directory()}}

# clean stuff
clean:
    @ rm -rf ./build

# run stuff
run:
    {{invocation_directory()}}/build/bin/kitti-depthmap ./res/0000000089.bin \
    ./res/0000000089.png ./res/calib_velo_to_cam.txt ./res/calib_cam_to_cam.txt
    
# build and run stuff
both:
    just build 
    just run
