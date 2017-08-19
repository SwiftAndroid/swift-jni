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
    static func fromStaticField(of javaClass: JavaClass, id: jfieldID) throws -> Self
    static func fromField(of javaObject: JavaObject, id: jfieldID) throws -> Self
}

extension Bool: JavaParameterConvertible {
    public static var asJNIParameterString: String { return "Z" }

    public func toJavaParameter() -> JavaParameter {
        return JavaParameter(bool: (self) ? 1 : 0)
    }

    public static func fromStaticField(of javaClass: JavaClass, id: jfieldID) throws -> Bool {
        return try jni.GetStaticBooleanField(of: javaClass, id: id) == JNI_TRUE
    }

    public static func fromMethod(calling methodID: JavaMethodID, on object: JavaObject, args: [JavaParameter]) throws -> Bool {
        return try jni.CallBooleanMethod(methodID, on: object, parameters: args) == JNI_TRUE
    }

    public static func fromStaticMethod(calling methodID: JavaMethodID, on javaClass: JavaClass, args: [JavaParameter]) throws -> Bool {
        return try jni.CallStaticBooleanMethod(javaClass: javaClass, method: methodID, parameters: args) == JNI_TRUE
    }

    public static func fromField(of javaObject: JavaObject, id: jfieldID) throws -> Bool {
        return jni.GetBooleanField(of: javaObject, id: id) == 1
    }
}

extension Int: JavaParameterConvertible {
    public static var asJNIParameterString: String { return "I" }

    public func toJavaParameter() -> JavaParameter {
        return JavaParameter(int: JavaInt(self))
    }

    public static func fromStaticField(of javaClass: JavaClass, id: jfieldID) throws -> Int {
        let result = try jni.GetStaticIntField(of: javaClass, id: id)
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

    public static func fromField(of javaObject: JavaObject, id: jfieldID) throws -> Int {
        return Int(jni.GetIntField(of: javaObject, id: id))
    }
}

extension Double: JavaParameterConvertible {
    public static var asJNIParameterString: String { return "D" }

    public func toJavaParameter() -> JavaParameter {
        return JavaParameter(double: JavaDouble(self))
    }

    public static func fromStaticField(of javaClass: JavaClass, id: jfieldID) throws -> Double {
        let result = try jni.GetStaticDoubleField(of: javaClass, id: id)
        return Double(result)
    }

    public static func fromMethod(calling methodID: JavaMethodID, on object: JavaObject, args: [JavaParameter]) throws -> Double {
        return try jni.CallDoubleMethod(methodID, on: object, parameters: args)
    }

    public static func fromStaticMethod(calling methodID: JavaMethodID, on javaClass: JavaClass, args: [JavaParameter]) throws -> Double {
        return try jni.CallStaticDoubleMethod(methodID, on: javaClass, parameters: args)
    }

    public static func fromField(of javaObject: JavaObject, id: jfieldID) throws -> Double {
        return Double(jni.GetDoubleField(of: javaObject, id: id))
    }
}

extension String: JavaParameterConvertible {
    private static let javaClassname = "java/lang/String"
    public static let asJNIParameterString = "L\(javaClassname);"

    public func toJavaParameter() -> JavaParameter {
        let stringAsObject = jni.NewStringUTF(self)
        return JavaParameter(object: stringAsObject)
    }

    public static func fromStaticField(of javaClass: JavaClass, id: jfieldID) throws -> String {
        let jobject: JavaObject = try jni.GetStaticObjectField(of: javaClass, id: id)
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

    public static func fromField(of javaObject: JavaObject, id: jfieldID) throws -> String {
        guard let javaStringObject = jni.GetObjectField(of: javaObject, id: id) else {
            throw FieldIDNotFound()
        }
        return jni.GetString(from: javaStringObject)
    }
}
