// swift-tools-version:5.5
/*
Files only need in this project
ggml.h
ggml.c
ggml-alloc.h
ggml-alloc.c
ggml-backend.h
ggml-backend.c
ggml-backend-impl.h
ggml-common.h
ggml-impl.h
ggml-kompute.h
ggml-kompute.cpp
ggml-metal.h
ggml-metal.m
ggml-metal.metal
ggml-metal-impl.h
ggml-opencl.h
ggml-opencl.cpp
ggml-quants.h
ggml-quants.c
ggml-sycl.h
ggml-sycl.cpp
ggml-vulkan.h
ggml-vulkan.cpp
gguf.h
gguf.cpp
ggml-threading.h
ggml-threading.cpp
ggml-cpu-impl.h
ggml-cpu.h
ggml-cpu.c
whisper.h
whisper.cpp
*/
import PackageDescription

let package = Package(
    name: "whisper",
    platforms: [
        .macOS(.v12),
        .iOS(.v14),
        .watchOS(.v4),
        .tvOS(.v14)
    ],
    products: [
        .library(name: "whisper", targets: ["whisper"]),
    ],
    targets: [
        .target(
            name: "whisper",
            path: ".",
            exclude: [
               "bindings",
               "cmake",
               "coreml",
               "examples",
               "extra",
               "models",
               "samples",
               "tests",
               "CMakeLists.txt",
               "ggml-cuda.cu",
               "ggml-cuda.h",
               "Makefile"
            ],
            sources: [
                "ggml.c",
                "whisper.cpp",
                "ggml-alloc.c",
                "ggml-backend.c",
                "ggml-quants.c",
                "ggml-metal.m"
            ],
            resources: [.process("ggml-metal.metal")],
            publicHeadersPath: "spm-headers",
            cSettings: [
                .unsafeFlags(["-Wno-shorten-64-to-32", "-O3", "-DNDEBUG"]),
                .define("GGML_USE_ACCELERATE"),
                .unsafeFlags(["-fno-objc-arc"]),
                .define("GGML_USE_METAL")
                // NOTE: NEW_LAPACK will required iOS version 16.4+
                // We should consider add this in the future when we drop support for iOS 14
                // (ref: ref: https://developer.apple.com/documentation/accelerate/1513264-cblas_sgemm?language=objc)
                // .define("ACCELERATE_NEW_LAPACK"),
                // .define("ACCELERATE_LAPACK_ILP64")
            ],
            linkerSettings: [
                .linkedFramework("Accelerate")
            ]
        )
    ],
    cxxLanguageStandard: .cxx11
)
