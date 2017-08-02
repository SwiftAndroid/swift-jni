//
//  JavaParameterConvertible.swift
//  JNI
//
//  Created by flowing erik on 19.07.17.
//

import CJNI

public protocol JavaParameterConvertible {
    typealias JavaMethod = ((JavaParameterConvertible...) throws -> Self)
    static var asJNIParameterString: String { get }
    func toJavaParameter() -> JavaParameter

    static func fromMethod(calling methodID: JavaMethodID, on object: JavaObject, args: [JavaParameter]) throws -> Self
    static func fromStaticMethod(calling methodID: JavaMethodID, on javaClass: JavaClass, args: [JavaParameter]) throws -> Self
}

extension Bool: JavaParameterConvertible {
    public static var asJNIParameterString: String { return "Z" }

    public func toJavaParameter() -> JavaParameter {
        return JavaParameter(bool: (self) ? 1 : 0)
    }

    public static func fromMethod(calling methodID: JavaMethodID, on object: JavaObject, args: [JavaParameter]) throws -> Bool {
        return try jni.CallBooleanMethod(methodID, on: object, parameters: args) == JNI_TRUE
    }

    public static func fromStaticMethod(calling methodID: JavaMethodID, on javaClass: JavaClass, args: [JavaParameter]) throws -> Bool {
        return try jni.CallStaticBooleanMethod(javaClass: javaClass, method: methodID, parameters: args) == JNI_TRUE
    }
}

extension Int: JavaParameterConvertible {
    public static var asJNIParameterString: String { return "I" }

    public func toJavaParameter() -> JavaParameter {
        return JavaParameter(int: JavaInt(self))
    }

    public static func fromMethod(calling methodID: JavaMethodID, on object: JavaObject, args: [JavaParameter]) throws -> Int {
        let result = try jni.CallIntMethod(methodID, on: object, parameters: args)
        return Int(result)
    }

    public static func fromStaticMethod(calling methodID: JavaMethodID, on javaClass: JavaClass, args: [JavaParameter]) throws -> Int {
        let result = try jni.CallStaticIntMethod(methodID, on: javaClass, parameters: args)
        return Int(result)
    }
}

extension Double: JavaParameterConvertible {
    public static var asJNIParameterString: String { return "D" }

    public func toJavaParameter() -> JavaParameter {
        return JavaParameter(double: JavaDouble(self))
    }

    public static func fromMethod(calling methodID: JavaMethodID, on object: JavaObject, args: [JavaParameter]) throws -> Double {
        return try jni.CallDoubleMethod(methodID, on: object, parameters: args)
    }

    public static func fromStaticMethod(calling methodID: JavaMethodID, on javaClass: JavaClass, args: [JavaParameter]) throws -> Double {
        return try jni.CallStaticDoubleMethod(methodID, on: javaClass, parameters: args)
    }
}

extension String: JavaParameterConvertible {
    private static let javaClassname = "java/lang/String"
    public static let asJNIParameterString = "L\(javaClassname);"

    public func toJavaParameter() -> JavaParameter {
        let stringAsObject = jni.NewStringUTF(self)
        return JavaParameter(object: stringAsObject)
    }

    public static func fromMethod(calling methodID: JavaMethodID, on object: JavaObject, args: [JavaParameter]) throws -> String {
        let jObject = try jni.CallObjectMethod(methodID, on: object, parameters: args)
        return jni.GetString(from: jObject)
    }

    public static func fromStaticMethod(calling methodID: JavaMethodID, on javaClass: JavaClass, args: [JavaParameter]) throws -> String {
        let jObject = try jni.CallStaticObjectMethod(methodID, on: javaClass, parameters: args)
        return jni.GetString(from: jObject)
    }
}
