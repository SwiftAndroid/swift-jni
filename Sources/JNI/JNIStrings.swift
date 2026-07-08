public extension String {
    init(javaString: JavaString) throws {
        let env = jni._env
        let chars = env.pointee.GetStringUTFChars(javaString.asJString, nil)
        defer { env.pointee.ReleaseStringUTFChars(javaString.asJString, chars) }
        try checkAndThrowOnJNIError()

        self.init(cString: chars!)
    }
}

public extension JNI {
    func NewString(unicodeChars: UnsafePointer<JavaChar>, _ length: JavaSize) -> JavaString {
        let env = self._env
        return env.pointee.NewString(unicodeChars, length)!.asJavaObject
    }

    func GetStringLength(_ jString: JavaString) -> JavaSize {
        let env = self._env
        return env.pointee.GetStringLength(jString.asJString)
    }

    func GetStringChars(_ jString: JavaString, _ isCopy: UnsafeMutablePointer<JavaBoolean>) -> UnsafePointer<JavaChar> {
        let env = self._env
        return env.pointee.GetStringChars(jString.asJString, isCopy)!
    }

    func ReleaseStringChars(_ jString: JavaString, _ chars: UnsafePointer<JavaChar>) {
        let env = self._env
        env.pointee.ReleaseStringChars(jString.asJString, chars)
    }

    func NewStringUTF(_ string: String) -> JavaString {
        let env = self._env
        return env.pointee.NewStringUTF(string)!.asJavaObject
    }

    func GetStringUTFLength(_ jString: JavaString) -> JavaSize {
        let env = self._env
        return env.pointee.GetStringUTFLength(jString.asJString)
    }

    func GetStringUTFChars(_ jString: JavaString, _ isCopy: UnsafeMutablePointer<JavaBoolean>) -> String {
        let env = self._env
        return String(describing: env.pointee.GetStringUTFChars(jString.asJString, isCopy))
    }

    func ReleaseStringUTFChars(_ jString: JavaString, _ utf: String) {
        let env = self._env
        env.pointee.ReleaseStringUTFChars(jString.asJString, utf)
    }

    func GetStringRegion(_ jString: JavaString, _ start: JavaSize, _ length: JavaSize, _ buf: UnsafeMutablePointer<JavaChar>) {
        let env = self._env
        env.pointee.GetStringRegion(jString.asJString, start, length, buf)
    }

    func GetStringUTFRegion(_ jString: JavaString, _ start: JavaSize, _ length: JavaSize, _ buf: UnsafeMutablePointer<CChar>) {
        let env = self._env
        env.pointee.GetStringUTFRegion(jString.asJString, start, length, buf)
    }

    func GetStringCritical(_ jString: JavaString, _ isCopy: UnsafeMutablePointer<JavaBoolean>) -> UnsafePointer<JavaChar> {
        let env = self._env
        return env.pointee.GetStringCritical(jString.asJString, isCopy)!
    }

    func ReleaseStringCritical(_ jString: JavaString, _ cArray: UnsafePointer<JavaChar>) {
        let env = self._env
        env.pointee.ReleaseStringCritical(jString.asJString, cArray)
    }
}
