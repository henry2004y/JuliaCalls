mkdir build && cd build
# To get CMAKE_PREFIX_PATH, use: julia -E "using CxxWrap; CxxWrap.prefix_path()"
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=/home/hongyang/.julia/artifacts/b9c99d2b2538a54bc5b916d41c98a1668c141ac0 ../
cmake --build . --config Release
