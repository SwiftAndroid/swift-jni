import CJNI

public extension JNI {
    func ExceptionCheck() -> Bool {
        let env = self._env
        return env.pointee.pointee.ExceptionCheck(env) == true
    }

    func ExceptionDescribe() {
        let env = self._env
        env.pointee.pointee.ExceptionDescribe(env)
    }

    func ExceptionClear() {
        let env = self._env
        env.pointee.pointee.ExceptionClear(env)
    }

    func ExceptionOccurred() -> JavaThrowable {
        let env = self._env
        return env.pointee.pointee.ExceptionOccurred(env)!
    }

    func Throw(obj: JavaThrowable) -> JavaInt {
        let env = self._env
        return env.pointee.pointee.Throw(env, obj)
    }

    func ThrowNew(targetClass: JavaClass, _ message: String) -> JavaInt {
        let env = self._env
        return env.pointee.pointee.ThrowNew(env, targetClass, message)
    }

    func FatalError(msg: String) {
        let env = self._env
        env.pointee.pointee.FatalError(env, msg)
    }
}
