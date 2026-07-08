public extension JNI {
    func FindClass(name: String) throws -> JavaClass {
        let env = self._env
        let result = env.pointee.FindClass(name.replacingFullstopsWithSlashes())
        try checkAndThrowOnJNIError()
        return result!.asJavaObject
    }

    func FromReflectedMethod(method: JavaObject) -> JavaMethodID {
        let env = self._env
        return env.pointee.FromReflectedMethod(method.asJObject)!
    }

    func FromReflectedField(field: JavaObject) -> JavaFieldID {
        let env = self._env
        return env.pointee.FromReflectedField(field.asJObject)!
    }

    func ToReflectedMethod(targetClass: JavaClass, _ methodID: JavaMethodID, _ isStatic: JavaBoolean) -> JavaObject {
        let env = self._env
        return env.pointee.ToReflectedMethod(targetClass.asJClass, methodID, isStatic)!.asJavaObject
    }

    func GetSuperclass(targetClass: JavaClass) -> JavaClass {
        let env = self._env
        return env.pointee.GetSuperclass(targetClass.asJClass)!.asJavaObject
    }

    func IsAssignableFrom(classA: JavaClass, _ classB: JavaClass) -> JavaBoolean {
        let env = self._env
        return env.pointee.IsAssignableFrom(classA.asJClass, classB.asJClass)
    }

    func ToReflectedField(targetClass: JavaClass, _ fieldID: JavaFieldID, _ isStatic: JavaBoolean) -> JavaObject {
        let env = self._env
        return env.pointee.ToReflectedField(targetClass.asJClass, fieldID, isStatic)!.asJavaObject
    }
}
