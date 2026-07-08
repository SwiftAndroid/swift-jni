public extension JNI {
    func NewGlobalRef(_ object: JavaObject) -> JavaObject? {
        let env = self._env
        return env.pointee.NewGlobalRef(object.asJObject)?.asJavaObject
    }

    func DeleteGlobalRef(_ globalRef: JavaObject) {
        let env = self._env
        env.pointee.DeleteGlobalRef(globalRef.asJObject)
    }

    func NewLocalRef(_ ref: JavaObject) -> JavaObject? {
        let env = self._env
        return env.pointee.NewLocalRef(ref.asJObject)?.asJavaObject
    }

    func DeleteLocalRef(_ localRef: JavaObject) {
        let env = self._env
        env.pointee.DeleteLocalRef(localRef.asJObject)
    }

    func PushLocalFrame(_ capacity: JavaInt) -> JavaInt {
        let env = self._env
        return env.pointee.PushLocalFrame(capacity)
    }

    func PopLocalFrame(_ result: JavaObject) -> JavaObject {
        let env = self._env
        return env.pointee.PopLocalFrame(result.asJObject)!.asJavaObject
    }

    func EnsureLocalCapacity(_ capacity: JavaInt) -> JavaInt {
        let env = self._env
        return env.pointee.EnsureLocalCapacity(capacity)
    }

    func IsSameObject(_ ref1: JavaObject, _ ref2: JavaObject) -> JavaBoolean {
        let env = self._env
        return env.pointee.IsSameObject(ref1.asJObject, ref2.asJObject)
    }

    func IsInstanceOf(_ obj: JavaObject, _ targetClass: JavaClass) -> JavaBoolean {
        let env = self._env
        return env.pointee.IsInstanceOf(obj.asJObject, targetClass.asJClass)
    }

    func NewWeakGlobalRef(_ obj: JavaObject) -> JavaWeakReference {
        let env = self._env
        return env.pointee.NewWeakGlobalRef(obj.asJObject)!.asJavaObject
    }

    func DeleteWeakGlobalRef(_ obj: JavaWeakReference) {
        let env = self._env
        env.pointee.DeleteWeakGlobalRef(obj.asJObject)
    }

    /* added in 1: JNI.6 */
    func GetObjectRefType(_ obj: JavaObject) -> JavaObjectRefType {
        let env = self._env
        return env.pointee.GetObjectRefType(obj.asJObject)
    }
}
