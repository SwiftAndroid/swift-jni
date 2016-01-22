import CJNI

public extension JNI {

	public func AllocObject(targetClass: jclass) -> jobject {
	    let env = self._env
	    return env.memory.memory.AllocObject(env, targetClass)
	}

	public func NewObject(targetClass: jclass, methodID: jmethodID, args: jvalue...) -> jobject {
	    return self.NewObjectA(targetClass, methodID: methodID, args: args)
	}

    @available(*, unavailable, message="CVaListPointer unavailable, use NewObject or NewObjectA")
	public func NewObjectV(targetClass: jclass, methodID: jmethodID, args: CVaListPointer) -> jobject {
	    // let env = self._env
	    // return env.memory.memory.NewObjectV(env, targetClass, methodID, args)
        return jobject()
	}

	public func NewObjectA(targetClass: jclass, methodID: jmethodID, args: [jvalue]) -> jobject {
	    let env = self._env
        var mutableArgs = args
	    return env.memory.memory.NewObjectA(env, targetClass, methodID, &mutableArgs)
	}

	public func GetObjectClass(obj: jobject) -> jclass? {
	    let env = self._env
        let result = env.memory.memory.GetObjectClass(env, obj)
        return (result != nil) ? result : .None
	}
	
}
