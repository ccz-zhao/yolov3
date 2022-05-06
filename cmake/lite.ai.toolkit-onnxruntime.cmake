############################## Source Files of LiteHub Based on ONNXRuntime #################################
# 1. glob sources files
file(GLOB ONNXRUNTIME_CORE_SRCS ${LITE_AI_ROOT_DIR}/include/lite/ort/core/*.cpp)
file(GLOB ONNXRUNTIME_CV_SRCS ${LITE_AI_ROOT_DIR}/include/lite/ort/cv/*.cpp)
file(GLOB ONNXRUNTIME_NLP_SRCS ${LITE_AI_ROOT_DIR}/include/lite/ort/nlp/*.cpp)
file(GLOB ONNXRUNTIME_ASR_SRCS ${LITE_AI_ROOT_DIR}/include/lite/ort/asr/*.cpp)
# 2. glob headers files
file(GLOB ONNXRUNTIME_CORE_HEAD ${LITE_AI_ROOT_DIR}/include/lite/ort/core/*.h)
file(GLOB ONNXRUNTIME_CV_HEAD ${LITE_AI_ROOT_DIR}/include/lite/ort/cv/*.h)
file(GLOB ONNXRUNTIME_NLP_HEAD ${LITE_AI_ROOT_DIR}/include/lite/ort/nlp/*.h)
file(GLOB ONNXRUNTIME_ASR_HEAD ${LITE_AI_ROOT_DIR}/include/lite/ort/asr/*.h)

set(ORT_SRCS
        ${ONNXRUNTIME_CV_SRCS}
        ${ONNXRUNTIME_NLP_SRCS}
        ${ONNXRUNTIME_ASR_SRCS}
        ${ONNXRUNTIME_CORE_SRCS})

# 3. copy
message("Installing Lite.AI.ToolKit Headers for ONNXRuntime Backend ...")
# "INSTALL" can copy all files from the list to the specified path.
# "COPY" only copies one file to a specified path
file(INSTALL ${ONNXRUNTIME_CORE_HEAD} DESTINATION ${BUILD_LITE_AI_DIR}/include/lite/ort/core)
file(INSTALL ${ONNXRUNTIME_CV_HEAD} DESTINATION ${BUILD_LITE_AI_DIR}/include/lite/ort/cv)
file(INSTALL ${ONNXRUNTIME_ASR_HEAD} DESTINATION ${BUILD_LITE_AI_DIR}/include/lite/ort/asr)
file(INSTALL ${ONNXRUNTIME_NLP_HEAD} DESTINATION ${BUILD_LITE_AI_DIR}/include/lite/ort/nlp)
