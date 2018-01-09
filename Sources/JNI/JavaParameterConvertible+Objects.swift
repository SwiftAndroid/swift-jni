// JavaObject

extension JavaObject: JavaParameterConvertible {
    private static let javaClassname = "java/lang/Object"
    public static let asJNIParameterString = "L\(javaClassname);"

    public func toJavaParameter() -> JavaParameter {
        return JavaParameter(object: self)
    }

    public static func fromStaticField(_ fieldID: JavaFieldID, of javaClass: JavaClass) throws -> JavaObject {
        return try jni.GetStaticObjectField(of: javaClass, id: fieldID)
    }

    public static func fromMethod(calling methodID: JavaMethodID, on object: JavaObject, args: [JavaParameter]) throws -> JavaObject {
        return try jni.CallObjectMethod(methodID, on: object, parameters: args)
    }

    public static func fromStaticMethod(calling methodID: JavaMethodID, on javaClass: JavaClass, args: [JavaParameter]) throws -> JavaObject {
        return try jni.CallStaticObjectMethod(methodID, on: javaClass, parameters: args)
    }

    public static func fromField(_ fieldID: JavaFieldID, on javaObject: JavaObject) throws -> JavaObject {
        return try jni.GetObjectField(of: javaObject, id: fieldID)
    }
}


// String

extension String: JavaParameterConvertible {
    private static let javaClassname = "java/lang/String"
    public static let asJNIParameterString = "L\(javaClassname);"

    public func toJavaParameter() -> JavaParameter {
        let stringAsObject = jni.NewStringUTF(self)
        return JavaParameter(object: stringAsObject)
    }

    public static func fromStaticField(_ fieldID: JavaFieldID, of javaClass: JavaClass) throws -> String {
        let jobject: JavaObject = try jni.GetStaticObjectField(of: javaClass, id: fieldID)
        return jni.GetString(from: jobject)
    }

    public static func fromMethod(calling methodID: JavaMethodID, on object: JavaObject, args: [JavaParameter]) throws -> String {
        let jObject = try jni.CallObjectMethod(methodID, on: object, parameters: args)
        return jni.GetString(from: jObject)
    }

    public static func fromStaticMethod(calling methodID: JavaMethodID, on javaClass: JavaClass, args: [JavaParameter]) throws -> String {
        let jObject = try jni.CallStaticObjectMethod(methodID, on: javaClass, parameters: args)
        return jni.GetString(from: jObject)
    }

    public static func fromField(_ fieldID: JavaFieldID, on javaObject: JavaObject) throws -> String {
        let javaStringObject = try jni.GetObjectField(of: javaObject, id: fieldID)
        return jni.GetString(from: javaStringObject)
    }
}


// Context

public struct JavaContext: JavaParameterConvertible {
    private let object: JavaObject
    public init(_ object: JavaObject) {
        self.object = object
    }

    private static let javaClassname = "android/content/Context"
    public static let asJNIParameterString = "L\(javaClassname);"

    public func toJavaParameter() -> JavaParameter {
        return JavaParameter(object: self.object)
    }

    public static func fromStaticField(_ fieldID: JavaFieldID, of javaClass: JavaClass) throws -> JavaContext {
        let jobject: JavaObject = try jni.GetStaticObjectField(of: javaClass, id: fieldID)
        return self.init(jobject)
    }

    public static func fromMethod(calling methodID: JavaMethodID, on object: JavaObject, args: [JavaParameter]) throws -> JavaContext {
        let jObject = try jni.CallObjectMethod(methodID, on: object, parameters: args)
        return self.init(jObject)
    }

    public static func fromStaticMethod(calling methodID: JavaMethodID, on javaClass: JavaClass, args: [JavaParameter]) throws -> JavaContext {
        let jObject = try jni.CallStaticObjectMethod(methodID, on: javaClass, parameters: args)
        return self.init(jObject)
    }

    public static func fromField(_ fieldID: JavaFieldID, on javaObject: JavaObject) throws -> JavaContext {
        let javaStringObject = try jni.GetObjectField(of: javaObject, id: fieldID)
        return self.init(javaStringObject)
    }
}
