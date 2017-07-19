//
//  Array+JavaParameterConvertible.swift
//  JNISwift
//
//  Created by flowing erik on 19.07.17.
//

extension Array where Element == JavaParameterConvertible {
    func methodSignature(returnType: JavaParameterConvertible.Type) -> String {
        let argumentTypes = String.from(parameters: self)
        return argumentTypes.asJNIParameterString(with: returnType)
    }
}

extension Array where Element == JavaParameterConvertible.Type {
    func methodSignature(returnType: JavaParameterConvertible.Type) -> String {
        let argumentTypes = String.from(types: self)
        return argumentTypes.asJNIParameterString(with: returnType)
    }
}

private extension String {
    static func from(parameters: [JavaParameterConvertible]) -> String {
        return parameters.reduce("", { (result, parameter) -> String in
            return result + type(of: parameter).asJNIParameterString
        })
    }

    static func from(types: [JavaParameterConvertible.Type]) -> String {
        return types.reduce("", { (result, type) -> String in
            return result + type.asJNIParameterString
        })
    }

    func asJNIParameterString(with returnType: JavaParameterConvertible.Type) -> String {
        return "(" + self + ")" + returnType.asJNIParameterString
    }
}

