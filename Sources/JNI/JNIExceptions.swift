public extension JNI {
    func ExceptionCheck() -> Bool {
        return self._env.pointee.ExceptionCheck() == .true
    }

    func ExceptionDescribe() {
        self._env.pointee.ExceptionDescribe()
    }

    func ExceptionClear() {
        self._env.pointee.ExceptionClear()
    }

    func ExceptionOccurred() -> JavaThrowable {
        return self._env.pointee.ExceptionOccurred()!.asJavaObject
    }

    func Throw(obj: JavaThrowable) -> JavaInt {
        return self._env.pointee.Throw(obj.asJThrowable)
    }

    func ThrowNew(targetClass: JavaClass, _ message: String) -> JavaInt {
        return self._env.pointee.ThrowNew(targetClass.asJClass, message)
    }

    func FatalError(msg: String) {
        self._env.pointee.FatalError(msg)
    }
}
