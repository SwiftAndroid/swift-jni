public extension JNI {
	public func NewString(unicodeChars: UnsafePointer<jchar>, len: jsize) -> jstring {
	    let env = self._env
	    return env.memory.memory.NewString(env, unicodeChars, len)
	}

	public func GetStringLength(string: jstring) -> jsize {
	    let env = self._env
	    return env.memory.memory.GetStringLength(env, string)
	}

	public func GetStringChars(string: jstring, isCopy: UnsafeMutablePointer<jboolean>) -> UnsafePointer<jchar> {
	    let env = self._env
	    return env.memory.memory.GetStringChars(env, string, isCopy)
	}

	public func ReleaseStringChars(string: jstring, chars: UnsafePointer<jchar>) {
	    let env = self._env
	    env.memory.memory.ReleaseStringChars(env, string, chars)
	}

	public func NewStringUTF(bytes: String) -> jstring {
	    let env = self._env
	    return env.memory.memory.NewStringUTF(env, bytes)
	}

	public func GetStringUTFLength(string: jstring) -> jsize {
	    let env = self._env
	    return env.memory.memory.GetStringUTFLength(env, string)
	}

	public func GetStringUTFChars(string: jstring, isCopy: UnsafeMutablePointer<jboolean>) -> String {
	    let env = self._env
	    return env.memory.memory.GetStringUTFChars(env, string, isCopy)
	}

	public func ReleaseStringUTFChars(string: jstring, utf: String) {
	    let env = self._env
	    env.memory.memory.ReleaseStringUTFChars(env, string, utf)
	}

	public func GetStringRegion(str: jstring, start: jsize, len: jsize, buf: UnsafeMutablePointer<jchar>) {
	    let env = self._env
	    env.memory.memory.GetStringRegion(env, str, start, len, buf)
	}

	public func GetStringUTFRegion(str: jstring, start: jsize, len: jsize, buf: UnsafeMutablePointer<char>) {
	    let env = self._env
	    return env.memory.memory.GetStringUTFRegion(env, str, start, len, buf)
	}

	public func GetStringCritical(string: jstring, isCopy: UnsafeMutablePointer<jboolean>) -> UnsafePointer<jchar> {
	    let env = self._env
	    return env.memory.memory.GetStringCritical(env, string, isCopy)
	}

	public func ReleaseStringCritical(string: jstring, carray: UnsafePointer<jchar>) {
	    let env = self._env
	    env.memory.memory.ReleaseStringCritical(env, string, carray)
	}
}