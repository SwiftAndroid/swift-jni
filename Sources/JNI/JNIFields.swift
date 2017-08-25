//
//  JNIFields.swift
//  JNI
//
//  Created by flowing erik on 01.08.17.
//

import CJNI

public extension JNI {
     public func GetStaticField<T: JavaParameterConvertible>(_ fieldName: String, on javaClass: JavaClass) throws -> T {
        let env = self._env
        let fieldID = env.pointee.pointee.GetStaticFieldID(env, javaClass, fieldName, T.asJNIParameterString)
        try checkAndThrowOnJNIError()
        return try T.fromStaticField(of: javaClass, id: fieldID!)
    }

    public func GetField<T: JavaParameterConvertible>(_ fieldName: String, from javaObject: JavaObject) throws -> T {
        let env = self._env
        let javaClass = try GetObjectClass(obj: javaObject)
        let fieldID = env.pointee.pointee.GetFieldID(env, javaClass, fieldName, T.asJNIParameterString)
        try checkAndThrowOnJNIError()
        return try T.fromField(of: javaObject, id: fieldID!)
    }
}
