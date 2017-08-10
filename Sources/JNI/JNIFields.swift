//
//  JNIFields.swift
//  JNI
//
//  Created by flowing erik on 01.08.17.
//

import CJNI

enum GetFieldError: Error {
    case InvalidParameters
}

public extension JNI {
     public func GetStaticField<T: JavaParameterConvertible>(_ fieldName: String, on javaClass: JavaClass) throws -> T {
        let env = self._env
        guard let fieldID = env.pointee.pointee.GetStaticFieldID(env, javaClass, fieldName, T.asJNIParameterString) else {
            throw GetFieldError.InvalidParameters
        }
        return try T.fromStaticField(of: javaClass, id: fieldID)
    }

    public func GetField<T: JavaParameterConvertible>(_ fieldName: String, from javaObject: JavaObject) throws -> T {
        let env = self._env
        guard let javaClass = GetObjectClass(obj: javaObject),
              let fieldID = env.pointee.pointee.GetFieldID(env, javaClass, fieldName, T.asJNIParameterString) else {
            throw GetFieldError.InvalidParameters
        }
        return try T.fromField(of: javaObject, id: fieldID)
    }
}
