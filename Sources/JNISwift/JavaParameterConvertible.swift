//
//  JavaParameterConvertible.swift
//  JNISwift
//
//  Created by flowing erik on 19.07.17.
//

import CJNI

public protocol JavaParameterConvertible {
    typealias JavaMethod = ((JavaParameterConvertible...) throws -> Self)
    static var asJNIParameterString: String { get }
    func toJavaParameter() -> JavaParameter
    static func fromStaticMethod(calling: JavaMethodID, on javaClass: JavaClass, args: [JavaParameter]) -> Self
}

extension Bool: JavaParameterConvertible {
    public static var asJNIParameterString: String { return "Z" }

    public func toJavaParameter() -> JavaParameter {
        return JavaParameter(bool: (self) ? 1 : 0)
    }

    public static func fromStaticMethod(calling: JavaMethodID, on javaClass: JavaClass, args: [JavaParameter]) -> Bool {
        return jni.CallStaticBooleanMethod(javaClass: javaClass, method: calling, parameters: args) == 1
    }
}

extension Int: JavaParameterConvertible {
    public static var asJNIParameterString: String { return "I" }

    public func toJavaParameter() -> JavaParameter {
        return JavaParameter(int: JavaInt(self))
    }

    public static func fromStaticMethod(calling: JavaMethodID, on javaClass: JavaClass, args: [JavaParameter]) -> Int {
        return Int(jni.CallStaticIntMethod(javaClass: javaClass, method: calling, parameters: args))
    }
}
