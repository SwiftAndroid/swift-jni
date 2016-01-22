set(sources
    JNI.swift
    JNIArrays.swift.gyb
    JNIClassManipulation.swift
    JNIExceptions.swift
    JNIFields.swift.gyb
    JNIMethods.swift.gyb
    JNIObjects.swift
    JNIRefs.swift
    JNIStrings.swift
    SwiftJNI.swift
)

set(output_dir "${SWIFTLIB_DIR}/jni")

# Set correct paths to glibc headers
set(JNI_INCLUDE_PATH "${SWIFT_SDK_ANDROID_PATH}/usr/include")
if (NOT EXISTS "${JNI_INCLUDE_PATH}/jni.h")
  message(FATAL_ERROR "JNI header was not found at ${JNI_INCLUDE_PATH}.")
endif()

# Generate module.map
configure_file(module.map.in "${CMAKE_CURRENT_BINARY_DIR}/module.map" @ONLY)

add_custom_command_target(unused_var
    COMMAND
        "${CMAKE_COMMAND}" "-E" "make_directory" "${output_dir}"
    COMMAND
        "${CMAKE_COMMAND}" "-E" "copy_if_different"
        "${CMAKE_CURRENT_BINARY_DIR}/module.map"
        "${output_dir}/module.map"
    CUSTOM_TARGET_NAME "copy_jni_module"
    OUTPUT "${output_dir}/module.map" "${output_dir}"
    DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/module.map"
    COMMENT "Copying JNI module to ${output_dir}")

swift_install_in_component(stdlib
    FILES "${output_dir}/module.map"
    DESTINATION "lib/swift/jni")

add_swift_library(swiftJNI IS_SDK_OVERLAY
    ${sources}
    FILE_DEPENDS copy_jni_module "${output_dir}"
    TARGET_SDKS ANDROID
    INSTALL_IN_COMPONENT stdlib-experimental)
