import CJNI

public extension JNI {
    public func NewGlobalRef(_ object: JavaObject) -> JavaObject? {
        let env = self._env
        return env.pointee.pointee.NewGlobalRef(env, object)
    }

    public func DeleteGlobalRef(_ globalRef: JavaObject) {
        let env = self._env
        env.pointee.pointee.DeleteGlobalRef(env, globalRef)
    }

    public func NewLocalRef(_ ref: JavaObject) -> JavaObject? {
        let env = self._env
        return env.pointee.pointee.NewLocalRef(env, ref)
    }

    public func DeleteLocalRef(_ localRef: JavaObject) {
        let env = self._env
        env.pointee.pointee.DeleteLocalRef(env, localRef)
    }

    public func PushLocalFrame(_ capacity: JavaInt) -> JavaInt {
        let env = self._env
        return env.pointee.pointee.PushLocalFrame(env, capacity)
    }

    public func PopLocalFrame(_ result: JavaObject) -> JavaObject {
        let env = self._env
        return env.pointee.pointee.PopLocalFrame(env, result)!
    }

    public func EnsureLocalCapacity(_ capacity: JavaInt) -> JavaInt {
        let env = self._env
        return env.pointee.pointee.EnsureLocalCapacity(env, capacity)
    }

    public func IsSameObject(_ ref1: JavaObject, _ ref2: JavaObject) -> JavaBoolean {
        let env = self._env
        return env.pointee.pointee.IsSameObject(env, ref1, ref2)
    }

    public func IsInstanceOf(_ obj: JavaObject, _ targetClass: JavaClass) -> JavaBoolean {
        let env = self._env
        return env.pointee.pointee.IsInstanceOf(env, obj, targetClass)
    }

    public func NewWeakGlobalRef(_ obj: JavaObject) -> JavaWeakReference {
        let env = self._env
        return env.pointee.pointee.NewWeakGlobalRef(env, obj)!
    }

    public func DeleteWeakGlobalRef(_ obj: JavaWeakReference) {
        let env = self._env
        env.pointee.pointee.DeleteWeakGlobalRef(env, obj)
    }

    /* added in 1: JNI.6 */
    public func GetObjectRefType(_ obj: JavaObject) -> JavaObjectRefType {
        let env = self._env
        return env.pointee.pointee.GetObjectRefType(env, obj)
    }
}
