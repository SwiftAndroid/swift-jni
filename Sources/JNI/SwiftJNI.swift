public import jni

public var jni: JNI! // this gets set "OnLoad" so should always exist

#if !STATIC_SWIFT_STDLIB
@_cdecl("JNI_OnLoad")
public func JNI_Onload(_ vm: UnsafeMutablePointer<JavaVM>, _ reserved: UnsafeMutableRawPointer?) -> JavaInt {
    return SwiftJNI_OnLoad(vm, reserved)
}
#endif

// Can be called manually from another call to JNI_OnLoad
// e.g. from the user's JNI_OnLoad function defined in the same static library
public func SwiftJNI_OnLoad(_ vm: UnsafeMutablePointer<JavaVM>, _ reserved: UnsafeMutableRawPointer?) -> JavaInt {
    guard let localJNI = JNI(jvm: vm) else {
         fatalError("Couldn't initialise JNI")
    }

    jni = localJNI // set the global for use elsewhere
    return JNI_VERSION_1_6
}

public func JNI_DetachCurrentThread() {
    _ = jni._jvm.pointee.DetachCurrentThread()
}

public extension JavaBoolean {
    static let `true` = JavaBoolean(JNI_TRUE)
    static let `false` = JavaBoolean(JNI_FALSE)
}

// SwiftJNI Public API
public extension JNI {
    func RegisterNatives(javaClass: JavaClass, methods: [JNINativeMethod]) -> Bool {
        let result = self._env.pointee.RegisterNatives(javaClass.asJClass, methods, JavaInt(methods.count))
        return (result == 0)
    }

    func ThrowNew(message: String) {
        let _env = self._env
        _ = _env.pointee.ThrowNew(_env.pointee.FindClass("java/lang/Exception")!, message)
    }

    // MARK: Arrays

    func GetLength(_ array: JavaArray) -> Int {
        let result = self._env.pointee.GetArrayLength(array.asJArray)
        return Int(result)
    }

    func NewIntArray(count: Int) throws -> JavaArray? {
        let result = self._env.pointee.NewIntArray(jsize(count))
        try checkAndThrowOnJNIError()
        return result?.asJavaObject
    }

    func NewByteArray(count: Int) throws -> JavaByteArray? {
        let result = self._env.pointee.NewByteArray(jsize(count))
        try checkAndThrowOnJNIError()
        return result?.asJavaObject
    }

    func NewBooleanArray(count: Int) throws -> JavaBooleanArray? {
        let result = self._env.pointee.NewBooleanArray(jsize(count))
        try checkAndThrowOnJNIError()
        return result?.asJavaObject
    }

    func GetBooleanArrayRegion(array: JavaBooleanArray, startIndex: Int = 0, numElements: Int = -1) -> [Bool] {
        let _env = self._env
        var count = numElements

        if numElements < 0 {
            count = GetLength(array)
        }

        var result = [JavaBoolean](repeating: 0, count: count)
        _env.pointee.GetBooleanArrayRegion(array.asJBooleanArray, jsize(startIndex), jsize(count), &result)

        return result.map { $0 == .true }
    }

    func SetBooleanArrayRegion(array: JavaBooleanArray, startIndex: Int = 0, from sourceElements: [Bool]) {
        let _env = self._env
        var newElements = sourceElements.map { $0 ? JavaBoolean.true : .false } // make mutable copy
        _env.pointee.SetBooleanArrayRegion(array.asJBooleanArray, jsize(startIndex), jsize(newElements.count), &newElements)
    }

    func GetByteArrayRegion(array: JavaByteArray, startIndex: Int = 0, numElements: Int = -1) -> [UInt8] {
        let _env = self._env
        var count = numElements

        if numElements < 0 {
            count = GetLength(array)
        }

        var result = [JavaByte](repeating: 0, count: count)
        _env.pointee.GetByteArrayRegion(array.asJByteArray, jsize(startIndex), jsize(count), &result)

        // Conversion from Int8 (JavaByte) to UInt8: bitPattern-constructor ensures
        // that negative Int8 values do not cause a crash when trying convert them to UInt8
        return result.map { UInt8(bitPattern: $0) }
    }

    func SetByteArrayRegion(array: JavaByteArray, startIndex: Int = 0, from sourceElements: Array<UInt8>) {
        let _env = self._env
        var newElements = sourceElements.map { JavaByte(bitPattern: $0) } // make mutable copy
        _env.pointee.SetByteArrayRegion(array.asJByteArray, jsize(startIndex), jsize(newElements.count), &newElements)
    }

    func GetIntArrayRegion(array: JavaIntArray, startIndex: Int = 0, numElements: Int = -1) -> [JavaInt] {
        let _env = self._env
        var count = numElements

        if numElements < 0 {
            count = GetLength(array)
        }

        var result = [JavaInt](repeating: 0, count: count)
        _env.pointee.GetIntArrayRegion(array.asJIntArray, jsize(startIndex), jsize(count), &result)
        return result
    }

    func SetIntArrayRegion(array: JavaIntArray, startIndex: Int = 0, from sourceElements: [Int]) {
        let _env = self._env
        var newElements = sourceElements.map { JavaInt($0) } // make mutable copy
        _env.pointee.SetIntArrayRegion(array.asJIntArray, jsize(startIndex), jsize(newElements.count), &newElements)
    }

    func NewFloatArray(count: Int) throws -> JavaArray? {
        let result = self._env.pointee.NewFloatArray(jsize(count))
        try checkAndThrowOnJNIError()
        return result?.asJavaObject
    }

    func GetFloatArrayRegion(array: JavaFloatArray, startIndex: Int = 0, numElements: Int = -1) -> [Float] {
        let _env = self._env
        var count = numElements

        if numElements < 0 {
            count = GetLength(array)
        }

        var result = [JavaFloat](repeating: 0, count: count)
        _env.pointee.GetFloatArrayRegion(array.asJFloatArray, jsize(startIndex), jsize(count), &result)
        return result.map { Float($0) }
    }

    func SetFloatArrayRegion(array: JavaFloatArray, startIndex: Int = 0, from sourceElements: [Float]) {
        let _env = self._env
        var newElements = sourceElements.map { JavaFloat($0) } // make mutable copy
        _env.pointee.SetFloatArrayRegion(array.asJFloatArray, jsize(startIndex), jsize(newElements.count), &newElements)
    }

    func GetStrings(from array: JavaObjectArray) throws -> [String] {
        let _env = self._env
        let count = jni.GetLength(array)

        let strings: [String] = try (0 ..< count).map { i in
            let jString: JavaString? = _env.pointee.GetObjectArrayElement(array.asJObjectArray, jsize(i))?.asJavaObject
            let chars = _env.pointee.GetStringUTFChars(jString?.asJString, nil)
            try checkAndThrowOnJNIError()
            defer { _env.pointee.ReleaseStringUTFChars(jString?.asJString, chars) }

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
        let jObj = _env.pointee.GetObjectArrayElement(array.asJObjectArray, jsize(index))
        try checkAndThrowOnJNIError()
        return jObj!.asJavaObject
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

public typealias JavaBoolean = jboolean
public typealias JavaByte = jbyte
public typealias JavaChar = jchar
public typealias JavaShort = jshort
public typealias JavaInt = jint
public typealias JavaLong = jlong
public typealias JavaFloat = jfloat
public typealias JavaDouble = jdouble
public typealias JavaSize = jint

public typealias JavaParameter = jvalue
public typealias JavaObjectRefType = jobjectRefType
public typealias JavaFieldID = jfieldID
public typealias JavaMethodID = jmethodID

public typealias JavaObject = UnsafeMutableRawPointer
public typealias JavaClass = JavaObject
public typealias JavaString = JavaObject
public typealias JavaArray = JavaObject
public typealias JavaObjectArray = JavaArray
public typealias JavaBooleanArray = JavaArray
public typealias JavaByteArray = JavaArray
public typealias JavaCharArray = JavaArray
public typealias JavaShortArray = JavaArray
public typealias JavaIntArray = JavaArray
public typealias JavaLongArray = JavaArray
public typealias JavaFloatArray = JavaArray
public typealias JavaDoubleArray = JavaArray
public typealias JavaThrowable = JavaObject
public typealias JavaWeakReference = JavaObject
