add_library(JNI SHARED
    Array+JavaParameterConvertible.swift
    JavaParameterConvertible+Objects.swift
    JavaParameterConvertible+Primitives.swift
    JavaParameterConvertible.swift
    JNI.swift
    JNIClassManipulation.swift
    JNIExceptions.swift
    JNIFields.swift
    JNIMethods.swift
    JNIObjects.swift
    JNIRefs.swift
    JNIStrings.swift
    SwiftJNI.swift
)

set_target_properties(JNI PROPERTIES
    INTERFACE_LINK_DIRECTORIES $<TARGET_LINKER_FILE_DIR:JNI>
    INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})

target_compile_options(JNI PUBLIC
    SHELL: -I ${SwiftJNI_SOURCE_DIR}/Sources/CJNI)

# TODO Add ${SwiftJNI_SOURCE_DIR}/Sources/CJNI to interface include dirs?
