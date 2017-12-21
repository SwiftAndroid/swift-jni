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
    static func fromStaticField(_ fieldID: JavaFieldID, of javaClass: JavaClass) throws -> Self
    static func fromField(_ fieldID: JavaFieldID, on javaObject: JavaObject) throws -> Self
}

extension Bool: JavaParameterConvertible {
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

extension Int: JavaParameterConvertible {
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

extension Double: JavaParameterConvertible {
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