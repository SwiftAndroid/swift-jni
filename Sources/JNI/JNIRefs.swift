import CJNI

public extension JNI {
    public func NewGlobalRef(obj: JavaObject) -> JavaObject {
        let env = self._env
        return env.pointee.pointee.NewGlobalRef(env, obj)!
    }

    public func DeleteGlobalRef(globalRef: JavaObject) {
        let env = self._env
        env.pointee.pointee.DeleteGlobalRef(env, globalRef)
    }

    public func NewLocalRef(ref: JavaObject) -> JavaObject {
        let env = self._env
        return env.pointee.pointee.NewLocalRef(env, ref)!
    }

    public func DeleteLocalRef(localRef: JavaObject) {
        let env = self._env
        env.pointee.pointee.DeleteLocalRef(env, localRef)
    }

    public func PushLocalFrame(capacity: JavaInt) -> JavaInt {
        let env = self._env
        return env.pointee.pointee.PushLocalFrame(env, capacity)
    }

    public func PopLocalFrame(result: JavaObject) -> JavaObject {
        let env = self._env
        return env.pointee.pointee.PopLocalFrame(env, result)!
    }

    public func EnsureLocalCapacity(capacity: JavaInt) -> JavaInt {
        let env = self._env
        return env.pointee.pointee.EnsureLocalCapacity(env, capacity)
    }

    public func IsSameObject(ref1: JavaObject, _ ref2: JavaObject) -> JavaBoolean {
        let env = self._env
        return env.pointee.pointee.IsSameObject(env, ref1, ref2)
    }

    public func IsInstanceOf(obj: JavaObject, _ targetClass: JavaClass) -> JavaBoolean {
        let env = self._env
        return env.pointee.pointee.IsInstanceOf(env, obj, targetClass)
    }

    public func NewWeakGlobalRef(obj: JavaObject) -> JavaWeakReference {
        let env = self._env
        return env.pointee.pointee.NewWeakGlobalRef(env, obj)!
    }

    public func DeleteWeakGlobalRef(obj: JavaWeakReference) {
        let env = self._env
        env.pointee.pointee.DeleteWeakGlobalRef(env, obj)
    }

    /* added in 1: JNI.6 */
    public func GetObjectRefType(obj: JavaObject) -> JavaObjectRefType {
        let env = self._env
        return env.pointee.pointee.GetObjectRefType(env, obj)
    }
}
