//
//  JNIFields.swift
//  JNI
//
//  Created by flowing erik on 01.08.17.
//

import CJNI

enum StaticFieldError: Error {
    case InvalidParameters
}

public extension JNI {
     public func GetStaticField<T: JavaParameterConvertible>(_ fieldName: String, on javaClass: JavaClass) throws -> T {
        let env = self._env
        guard let fieldID = env.pointee.pointee.GetStaticFieldID(env, javaClass, fieldName, T.asJNIParameterString) else {
            throw StaticFieldError.InvalidParameters
        }
        return try T.fromStaticField(of: javaClass, id: fieldID)
    }
}
