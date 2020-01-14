import CJNI

public extension JNI {
	// func DefineClass(name: String, _ loader: JavaObject, _ buffer: UnsafePointer<JavaByte>, _ bufferLength: jsize) -> JavaClass {
	//     let env = self._env
    //     return env.pointee.pointee.DefineClass(env, name, loader, buffer, bufferLength)!
	// }

	func FindClass(name: String) throws -> JavaClass {
	    let env = self._env
        let result = env.pointee.pointee.FindClass(env, name.replacingFullstopsWithSlashes())
        try checkAndThrowOnJNIError()
        return result!
	}

	func FromReflectedMethod(method: JavaObject) -> JavaMethodID {
	    let env = self._env
        return env.pointee.pointee.FromReflectedMethod(env, method)!
	}

    func FromReflectedField(field: JavaObject) -> JavaFieldID {
	    let env = self._env
        return env.pointee.pointee.FromReflectedField(env, field)!
	}

	func ToReflectedMethod(targetClass: JavaClass, _ methodID: JavaMethodID, _ isStatic: JavaBoolean) -> JavaObject {
	    let env = self._env
        return env.pointee.pointee.ToReflectedMethod(env, targetClass, methodID, isStatic)!
	}

	func GetSuperclass(targetClass: JavaClass) -> JavaClass {
	    let env = self._env
        return env.pointee.pointee.GetSuperclass(env, targetClass)!
	}

	func IsAssignableFrom(classA: JavaClass, _ classB: JavaClass) -> JavaBoolean {
	    let env = self._env
	    return env.pointee.pointee.IsAssignableFrom(env, classA, classB)
	}

    func ToReflectedField(targetClass: JavaClass, _ fieldID: JavaFieldID, _ isStatic: JavaBoolean) -> JavaObject {
	    let env = self._env
        return env.pointee.pointee.ToReflectedField(env, targetClass, fieldID, isStatic)!
	}
}
