import CJNI

public var jni: JNI! // this gets set "OnLoad" so should always exist

@_cdecl("JNI_OnLoad")
public func JNI_OnLoad(jvm: UnsafeMutablePointer<JavaVM>, reserved: UnsafeMutableRawPointer) -> JavaInt {
    guard let localJNI = JNI(jvm: jvm) else {
         fatalError("Couldn't initialise JNI")
    }

    jni = localJNI // set the global for use elsewhere
    return JNI_VERSION_1_6
}

public func JNI_DetachCurrentThread() {
    _ = jni._jvm.pointee.pointee.DetachCurrentThread(jni._jvm)
}

extension JavaBoolean : ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) {
        self = value ? JavaBoolean(JNI_TRUE) : JavaBoolean(JNI_FALSE)
    }
}

// SwiftJNI Public API
public extension JNI {
    func RegisterNatives(javaClass: JavaClass, methods: [JNINativeMethod]) -> Bool {
        let _env = self._env
		let env = _env.pointee.pointee
        let result = env.RegisterNatives(_env, javaClass, methods, JavaInt(methods.count))
        return (result == 0)
    }

    func ThrowNew(message: String) {
        let _env = self._env
        let env = _env.pointee.pointee
        _ = env.ThrowNew(_env, env.FindClass(_env, "java/lang/Exception"), message)
    }

    // MARK: Arrays

    func GetLength(_ array: JavaArray) -> Int {
        let _env = self._env
        let result = _env.pointee.pointee.GetArrayLength(_env, array)
        return Int(result)
    }

    func NewIntArray(count: Int) throws -> JavaArray? {
        let _env = self._env
        let result = _env.pointee.pointee.NewIntArray(_env, jsize(count))
        try checkAndThrowOnJNIError()
        return result
    }

    func NewByteArray(count: Int) throws -> JavaArray? {
        let _env = self._env
        let result = _env.pointee.pointee.NewByteArray(_env, jsize(count))
        try checkAndThrowOnJNIError()
        return result
    }

    func GetByteArrayRegion(array: JavaByteArray, startIndex: Int = 0, numElements: Int = -1) -> [UInt8] {
        let _env = self._env
        var count = numElements

        if numElements < 0 {
            count = GetLength(array)
        }

        var result = [JavaByte](repeating: 0, count: count)
        _env.pointee.pointee.GetByteArrayRegion(_env, array, jsize(startIndex), jsize(count), &result)

        // Conversion from Int8 (JavaByte) to UInt8: bitPattern-constructor ensures
        // that negative Int8 values do not cause a crash when trying convert them to UInt8
        return result.map { UInt8(bitPattern: $0) }
    }

    func SetByteArrayRegion(array: JavaByteArray, startIndex: Int = 0, from sourceElements: UnsafeBufferPointer<UInt8>) {
        let _env = self._env
        var newElements = sourceElements.map { JavaByte($0) } // make mutable copy
        _env.pointee.pointee.SetArrayRegion(_env, array, jsize(startIndex), jsize(newElements.count), &newElements)
    }

    func GetIntArrayRegion(array: JavaIntArray, startIndex: Int = 0, numElements: Int = -1) -> [JavaInt] {
        let _env = self._env
        var count = numElements

        if numElements < 0 {
            count = GetLength(array)
        }

        var result = [JavaInt](repeating: 0, count: count)
        _env.pointee.pointee.GetIntArrayRegion(_env, array, jsize(startIndex), jsize(count), &result)
        return result
    }

    func SetIntArrayRegion(array: JavaIntArray, startIndex: Int = 0, from sourceElements: [Int]) {
        let _env = self._env
        var newElements = sourceElements.map { JavaInt($0) } // make mutable copy
        _env.pointee.pointee.SetArrayRegion(_env, array, jsize(startIndex), jsize(newElements.count), &newElements)
    }

    func NewFloatArray(count: Int) throws -> JavaArray? {
        let _env = self._env
        let result = _env.pointee.pointee.NewFloatArray(_env, jsize(count))
        try checkAndThrowOnJNIError()
        return result
    }

    func GetFloatArrayRegion(array: JavaFloatArray, startIndex: Int = 0, numElements: Int = -1) -> [Float] {
        let _env = self._env
        var count = numElements

        if numElements < 0 {
            count = GetLength(array)
        }

        var result = [JavaFloat](repeating: 0, count: count)
        _env.pointee.pointee.GetFloatArrayRegion(_env, array, jsize(startIndex), jsize(count), &result)
        return result.map { Float($0) }
    }

    func SetFloatArrayRegion(array: JavaFloatArray, startIndex: Int = 0, from sourceElements: [Float]) {
        let _env = self._env
        var newElements = sourceElements.map { JavaFloat($0) } // make mutable copy
        _env.pointee.pointee.SetArrayRegion(_env, array, jsize(startIndex), jsize(newElements.count), &newElements)
    }

    func GetStrings(from array: JavaObjectArray) throws -> [String] {
        let _env = self._env
        let count = jni.GetLength(array)

        let strings: [String] = try (0 ..< count).map { i in
            let jString: JavaString? = _env.pointee.pointee.GetObjectArrayElement(_env, array, jsize(i))
            let chars = _env.pointee.pointee.GetStringUTFChars(_env, jString, nil)
            try checkAndThrowOnJNIError()
            defer { _env.pointee.pointee.ReleaseStringUTFChars(_env, jString, chars) }

            return String(cString: chars!)
        }

        return strings
    }

    func GetObjectArrayElement(in array: JavaObjectArray, at index: Int) throws -> JavaObject {
        let _env = self._env
        let count = jni.GetLength(array)
        if (index >= count) {
            throw JNIError()
        }
        let jObj = _env.pointee.pointee.GetObjectArrayElement(_env, array, jsize(index))
        try checkAndThrowOnJNIError()
        return jObj!
    }
}

func checkAndThrowOnJNIError() throws {
    if jni.ExceptionCheck() { throw JNIError() }
}

/// Prints information about the error to the console and clears the pending exception so we can continue making JNI calls
struct JNIError: Error {
    init() {
        jni.ExceptionDescribe()
        jni.ExceptionClear()
    }
}

#if os(Android)
@discardableResult
@_silgen_name("__android_log_write")
public func androidPrint(_ prio: Int32, _ tag: UnsafePointer<CChar>, _ text: UnsafePointer<CChar>) -> Int32

func print(_ string: String) {
    androidPrint(5, "SwiftJNI", string)
}
#endif
