import CJNI

public extension JNI {
    func NewGlobalRef(_ object: JavaObject) -> JavaObject? {
        let env = self._env
        return env.pointee.pointee.NewGlobalRef(env, object)
    }

    func DeleteGlobalRef(_ globalRef: JavaObject) {
        let env = self._env
        env.pointee.pointee.DeleteGlobalRef(env, globalRef)
    }

    func NewLocalRef(_ ref: JavaObject) -> JavaObject? {
        let env = self._env
        return env.pointee.pointee.NewLocalRef(env, ref)
    }

    func DeleteLocalRef(_ localRef: JavaObject) {
        let env = self._env
        env.pointee.pointee.DeleteLocalRef(env, localRef)
    }

    func PushLocalFrame(_ capacity: JavaInt) -> JavaInt {
        let env = self._env
        return env.pointee.pointee.PushLocalFrame(env, capacity)
    }

    func PopLocalFrame(_ result: JavaObject) -> JavaObject {
        let env = self._env
        return env.pointee.pointee.PopLocalFrame(env, result)!
    }

    func EnsureLocalCapacity(_ capacity: JavaInt) -> JavaInt {
        let env = self._env
        return env.pointee.pointee.EnsureLocalCapacity(env, capacity)
    }

    func IsSameObject(_ ref1: JavaObject, _ ref2: JavaObject) -> JavaBoolean {
        let env = self._env
        return env.pointee.pointee.IsSameObject(env, ref1, ref2)
    }

    func IsInstanceOf(_ obj: JavaObject, _ targetClass: JavaClass) -> JavaBoolean {
        let env = self._env
        return env.pointee.pointee.IsInstanceOf(env, obj, targetClass)
    }

    func NewWeakGlobalRef(_ obj: JavaObject) -> JavaWeakReference {
        let env = self._env
        return env.pointee.pointee.NewWeakGlobalRef(env, obj)!
    }

    func DeleteWeakGlobalRef(_ obj: JavaWeakReference) {
        let env = self._env
        env.pointee.pointee.DeleteWeakGlobalRef(env, obj)
    }

    /* added in 1: JNI.6 */
    func GetObjectRefType(_ obj: JavaObject) -> JavaObjectRefType {
        let env = self._env
        return env.pointee.pointee.GetObjectRefType(env, obj)
    }
}
