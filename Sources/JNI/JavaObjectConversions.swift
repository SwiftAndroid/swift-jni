import Android

// Under C++ interop the NDK's jni.h maps each Java reference type to a distinct
// pointer-to-C++-class (`jobject` == `_jobject *`, `jclass` == `_jclass *`, …),
// whereas the high-level SwiftJNI API represents every handle as an opaque
// `UnsafeMutableRawPointer` (`JavaObject`). These helpers bridge the two at each
// JNI call boundary, and are public so consumers can build `JavaParameter(l:)`
// values and pass handles into the raw JNI functions.

public extension UnsafeMutableRawPointer {
    var asJObject: jobject { assumingMemoryBound(to: _jobject.self) }
    var asJClass: jclass { assumingMemoryBound(to: _jclass.self) }
    var asJString: jstring { assumingMemoryBound(to: _jstring.self) }
    var asJThrowable: jthrowable { assumingMemoryBound(to: _jthrowable.self) }
    var asJArray: jarray { assumingMemoryBound(to: _jarray.self) }
    var asJObjectArray: jobjectArray { assumingMemoryBound(to: _jobjectArray.self) }
    var asJBooleanArray: jbooleanArray { assumingMemoryBound(to: _jbooleanArray.self) }
    var asJByteArray: jbyteArray { assumingMemoryBound(to: _jbyteArray.self) }
    var asJCharArray: jcharArray { assumingMemoryBound(to: _jcharArray.self) }
    var asJShortArray: jshortArray { assumingMemoryBound(to: _jshortArray.self) }
    var asJIntArray: jintArray { assumingMemoryBound(to: _jintArray.self) }
    var asJLongArray: jlongArray { assumingMemoryBound(to: _jlongArray.self) }
    var asJFloatArray: jfloatArray { assumingMemoryBound(to: _jfloatArray.self) }
    var asJDoubleArray: jdoubleArray { assumingMemoryBound(to: _jdoubleArray.self) }
}

public extension UnsafeMutablePointer {
    /// Erase a typed `jXxx` pointer back to the opaque `JavaObject` handle.
    var asJavaObject: JavaObject { UnsafeMutableRawPointer(self) }
}
