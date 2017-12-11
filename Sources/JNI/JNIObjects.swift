import CJNI

struct CreateNewObjectForConstructorError: Error {}

public extension JNI {
	public func AllocObject(targetClass: JavaClass) -> JavaObject? {
        let env = self._env
        return env.pointee.pointee.AllocObject(env, targetClass)
    }

	public func NewObject(targetClass: JavaClass, _ methodID: JavaMethodID, _ args: [JavaParameter]) throws -> JavaObject {
        let env = self._env
        var mutableArgs = args
        guard let newObject = env.pointee.pointee.NewObject(env, targetClass, methodID, &mutableArgs) else {
            throw CreateNewObjectForConstructorError()
        }
        try checkAndThrowOnJNIError()
        return newObject
	}

	public func GetObjectClass(obj: JavaObject) -> JavaClass? {
        let env = self._env
        return env.pointee.pointee.GetObjectClass(env, obj)
	}
}
