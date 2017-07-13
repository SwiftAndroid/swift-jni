import CJNI

public extension JNI {

	public func AllocObject(targetClass: jclass) -> jobject {
	    let env = self._env
        return env.pointee!.pointee.AllocObject(env, targetClass)!
	}

	public func NewObject(targetClass: jclass, _ methodID: jmethodID, _ args: jvalue...) -> jobject {
        return self.NewObjectA(targetClass: targetClass, methodID, args)
	}

    @available(*, unavailable, message:"CVaListPointer unavailable, use NewObject or NewObjectA")
	public func NewObjectV(targetClass: jclass, _ methodID: jmethodID, _ args: CVaListPointer) -> jobject {
         let env = self._env
        return env.pointee!.pointee.NewObjectV(env, targetClass, methodID, args)!
	}

	public func NewObjectA(targetClass: jclass, _ methodID: jmethodID, _ args: [jvalue]) -> jobject {
	    let env = self._env
        var mutableArgs = args
        return env.pointee!.pointee.NewObjectA(env, targetClass, methodID, &mutableArgs)!
	}

	public func GetObjectClass(obj: jobject) -> jclass? {
	    let env = self._env
        let result = env.pointee!.pointee.GetObjectClass(env, obj)
        return (result != nil) ? result : .none
	}
	
}
