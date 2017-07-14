import CJNI

public extension JNI {

	public func AllocObject(targetClass: JavaClass) -> JavaObject {
	    let env = self._env
		return env.pointee.pointee.AllocObject(env, targetClass)!
	}

	public func NewObject(targetClass: JavaClass, _ methodID: JavaMethodID, _ args: JavaParameter...) -> JavaObject {
        return self.NewObjectA(targetClass: targetClass, methodID, args)
	}

    @available(*, unavailable, message:"CVaListPointer unavailable, use NewObject or NewObjectA")
	public func NewObjectV(targetClass: JavaClass, _ methodID: JavaMethodID, _ args: CVaListPointer) -> JavaObject {
         let env = self._env
        return env.pointee.pointee.NewObjectV(env, targetClass, methodID, args)!
	}

	public func NewObjectA(targetClass: JavaClass, _ methodID: JavaMethodID, _ args: [JavaParameter]) -> JavaObject {
	    let env = self._env
        var mutableArgs = args
        return env.pointee.pointee.NewObjectA(env, targetClass, methodID, &mutableArgs)!
	}

	public func GetObjectClass(obj: JavaObject) -> JavaClass? {
	    let env = self._env
        let result = env.pointee.pointee.GetObjectClass(env, obj)
        return (result != nil) ? result : .none
	}

}
