import CJNI

public extension String {
    init(javaString: JavaString) throws {
        let env = jni._env
        let chars = env.pointee.pointee.GetStringUTFChars(env, javaString, nil)
        defer { env.pointee.pointee.ReleaseStringUTFChars(env, javaString, chars) }
        try checkAndThrowOnJNIError()

        self.init(cString: chars!)
    }
}

public extension JNI {
    func NewString(unicodeChars: UnsafePointer<JavaChar>, _ length: jsize) -> JavaString {
        let env = self._env
        return env.pointee.pointee.NewString(env, unicodeChars, length)!
    }

    func GetStringLength(_ jString: JavaString) -> jsize {
        let env = self._env
        return env.pointee.pointee.GetStringLength(env, jString)
    }

    func GetStringChars(_ jString: JavaString, _ isCopy: UnsafeMutablePointer<JavaBoolean>) -> UnsafePointer<JavaChar> {
        let env = self._env
        return env.pointee.pointee.GetStringChars(env, jString, isCopy)!
    }

    func ReleaseStringChars(_ jString: JavaString, _ chars: UnsafePointer<JavaChar>) {
        let env = self._env
        env.pointee.pointee.ReleaseStringChars(env, jString, chars)
    }

    func NewStringUTF(_ string: String) -> JavaString {
        let env = self._env
        return env.pointee.pointee.NewStringUTF(env, string)!
    }

    func GetStringUTFLength(_ jString: JavaString) -> jsize {
        let env = self._env
        return env.pointee.pointee.GetStringUTFLength(env, jString)
    }

    func GetStringUTFChars(_ jString: JavaString, _ isCopy: UnsafeMutablePointer<JavaBoolean>) -> String {
        let env = self._env
        return String(describing: env.pointee.pointee.GetStringUTFChars(env, jString, isCopy))
    }

    func ReleaseStringUTFChars(_ jString: JavaString, _ utf: String) {
        let env = self._env
        env.pointee.pointee.ReleaseStringUTFChars(env, jString, utf)
    }

    func GetStringRegion(_ jString: JavaString, _ start: jsize, _ length: jsize, _ buf: UnsafeMutablePointer<JavaChar>) {
        let env = self._env
        env.pointee.pointee.GetStringRegion(env, jString, start, length, buf)
    }

    func GetStringUTFRegion(_ jString: JavaString, _ start: jsize, _ length: jsize, _ buf: UnsafeMutablePointer<CChar>) {
        let env = self._env
        env.pointee.pointee.GetStringUTFRegion(env, jString, start, length, buf)
    }

    func GetStringCritical(_ jString: JavaString, _ isCopy: UnsafeMutablePointer<JavaBoolean>) -> UnsafePointer<JavaChar> {
        let env = self._env
        return env.pointee.pointee.GetStringCritical(env, jString, isCopy)!
    }

    func ReleaseStringCritical(_ jString: JavaString, _ cArray: UnsafePointer<JavaChar>) {
        let env = self._env
        env.pointee.pointee.ReleaseStringCritical(env, jString, cArray)
    }
}
