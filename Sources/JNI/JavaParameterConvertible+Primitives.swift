// Bool

extension Bool: JavaParameterConvertible, JavaInitializableFromMethod, JavaInitializableFromField {
    public static let asJNIParameterString = "Z"

    public func toJavaParameter() -> JavaParameter {
        return JavaParameter(bool: (self) ? 1 : 0)
    }

    public static func fromStaticField(_ fieldID: JavaFieldID, of javaClass: JavaClass) throws -> Bool {
        return try jni.GetStaticBooleanField(of: javaClass, id: fieldID) == JNI_TRUE
    }

    public static func fromMethod(calling methodID: JavaMethodID, on object: JavaObject, args: [JavaParameter]) throws -> Bool {
        return try jni.CallBooleanMethod(methodID, on: object, parameters: args) == JNI_TRUE
    }

    public static func fromStaticMethod(calling methodID: JavaMethodID, on javaClass: JavaClass, args: [JavaParameter]) throws -> Bool {
        return try jni.CallStaticBooleanMethod(javaClass: javaClass, method: methodID, parameters: args) == JNI_TRUE
    }

    public static func fromField(_ fieldID: JavaFieldID, on javaObject: JavaObject) throws -> Bool {
        return try jni.GetBooleanField(of: javaObject, id: fieldID) == JNI_TRUE
    }
}


// Int

extension Int: JavaParameterConvertible, JavaInitializableFromMethod, JavaInitializableFromField {
    public static var asJNIParameterString = "I"

    public func toJavaParameter() -> JavaParameter {
        return JavaParameter(int: JavaInt(self))
    }

    public static func fromStaticField(_ fieldID: JavaFieldID, of javaClass: JavaClass) throws -> Int {
        let result = try jni.GetStaticIntField(of: javaClass, id: fieldID)
        return Int(result)
    }

    public static func fromMethod(calling methodID: JavaMethodID, on object: JavaObject, args: [JavaParameter]) throws -> Int {
        let result = try jni.CallIntMethod(methodID, on: object, parameters: args)
        return Int(result)
    }

    public static func fromStaticMethod(calling methodID: JavaMethodID, on javaClass: JavaClass, args: [JavaParameter]) throws -> Int {
        let result = try jni.CallStaticIntMethod(methodID, on: javaClass, parameters: args)
        return Int(result)
    }

    public static func fromField(_ fieldID: JavaFieldID, on javaObject: JavaObject) throws -> Int {
        return try Int(jni.GetIntField(of: javaObject, id: fieldID))
    }
}


// Double

extension Double: JavaParameterConvertible, JavaInitializableFromMethod, JavaInitializableFromField {
    public static let asJNIParameterString = "D"

    public func toJavaParameter() -> JavaParameter {
        return JavaParameter(double: JavaDouble(self))
    }

    public static func fromStaticField(_ fieldID: JavaFieldID, of javaClass: JavaClass) throws -> Double {
        return try Double(jni.GetStaticDoubleField(of: javaClass, id: fieldID))
    }

    public static func fromMethod(calling methodID: JavaMethodID, on object: JavaObject, args: [JavaParameter]) throws -> Double {
        return try jni.CallDoubleMethod(methodID, on: object, parameters: args)
    }

    public static func fromStaticMethod(calling methodID: JavaMethodID, on javaClass: JavaClass, args: [JavaParameter]) throws -> Double {
        return try jni.CallStaticDoubleMethod(methodID, on: javaClass, parameters: args)
    }

    public static func fromField(_ fieldID: JavaFieldID, on javaObject: JavaObject) throws -> Double {
        return try jni.GetDoubleField(of: javaObject, id: fieldID)
    }
}


// Float

extension Float: JavaParameterConvertible, JavaInitializableFromMethod, JavaInitializableFromField {
    public static let asJNIParameterString = "F"

    public func toJavaParameter() -> JavaParameter {
        return JavaParameter(float: JavaFloat(self))
    }

    public static func fromStaticField(_ fieldID: JavaFieldID, of javaClass: JavaClass) throws -> Float {
        return try Float(jni.GetStaticFloatField(of: javaClass, id: fieldID))
    }

    public static func fromMethod(calling methodID: JavaMethodID, on object: JavaObject, args: [JavaParameter]) throws -> Float {
        return try jni.CallFloatMethod(methodID, on: object, parameters: args)
    }

    public static func fromStaticMethod(calling methodID: JavaMethodID, on javaClass: JavaClass, args: [JavaParameter]) throws -> Float {
        return try jni.CallStaticFloatMethod(methodID, on: javaClass, parameters: args)
    }

    public static func fromField(_ fieldID: JavaFieldID, on javaObject: JavaObject) throws -> Float {
        return try jni.GetFloatField(of: javaObject, id: fieldID)
    }
}

// Int64 aka JavaLong

extension Int64: JavaParameterConvertible, JavaInitializableFromMethod, JavaInitializableFromField {
    public static let asJNIParameterString = "J"

    public func toJavaParameter() -> JavaParameter {
        return JavaParameter(long: Int64(self))
    }

    public static func fromStaticField(_ fieldID: JavaFieldID, of javaClass: JavaClass) throws -> Int64 {
        return try Int64(jni.GetStaticInt64Field(of: javaClass, id: fieldID))
    }

    public static func fromMethod(calling methodID: JavaMethodID, on object: JavaObject, args: [JavaParameter]) throws -> Int64 {
        return try jni.CallInt64Method(methodID, on: object, parameters: args)
    }

    public static func fromStaticMethod(calling methodID: JavaMethodID, on javaClass: JavaClass, args: [JavaParameter]) throws -> Int64 {
        return try jni.CallStaticInt64Method(methodID, on: javaClass, parameters: args)
    }

    public static func fromField(_ fieldID: JavaFieldID, on javaObject: JavaObject) throws -> Int64 {
        return try jni.GetInt64Field(of: javaObject, id: fieldID)
    }
}
