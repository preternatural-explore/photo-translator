//
// Copyright (c) Vatsal Manot
//

import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxUtilities

public struct KeyAutogeneratedMacro: AttachedMacro {
    
}

extension KeyAutogeneratedMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let variableDeclaration = declaration.as(VariableDeclSyntax.self) else {
            return []
        }
        
        guard var binding: PatternBindingListSyntax.Element = variableDeclaration.bindings.first else {
            context.diagnose(
                Diagnostic(
                    node: Syntax(node),
                    message: DiagnosticMessage.missingAnnotation
                )
            )
            
            return []
        }
        
        guard let identifier = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text else {
            context.diagnose(
                Diagnostic(
                    node: Syntax(node),
                    message: DiagnosticMessage.notAnIdentifier
                )
            )
            
            return []
        }
        
        binding.pattern = PatternSyntax(IdentifierPatternSyntax(identifier: .identifier("defaultValue")))
        
        let isOptionalType = binding.typeAnnotation?.type.is(OptionalTypeSyntax.self) ?? false
        let hasDefaultValue = binding.initializer != nil
        
        guard isOptionalType || hasDefaultValue else {
            context.diagnose(Diagnostic(node: Syntax(node), message: DiagnosticMessage.noDefaultArgument))
            return []
        }
        
        return [
            """
            internal final class _KeyAutogenerated_\(raw: identifier): _HeterogenousDictionaryKeyType {
                static var \(binding)
            
                static var _swift_variableIdentifier: String {
                    "\(raw: try variableDeclaration.variableName.unwrap())"
                }
            }
            """
        ]
    }
}

extension KeyAutogeneratedMacro: AccessorMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AccessorDeclSyntax] {
        
        // Skip declarations other than variables
        guard let variableDeclaration = declaration.as(VariableDeclSyntax.self) else {
            return []
        }
        
        guard let binding = variableDeclaration.bindings.first else {
            context.diagnose(Diagnostic(node: Syntax(node), message: DiagnosticMessage.missingAnnotation))
            return []
        }
        
        guard let identifier = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text else {
            context.diagnose(Diagnostic(node: Syntax(node), message: DiagnosticMessage.notAnIdentifier))
            return []
        }
        
        return [
            """
            get {
                self[_KeyAutogenerated_\(raw: identifier).self]
            }
            """,
            """
            set {
                self[_KeyAutogenerated_\(raw: identifier).self] = newValue
            }
            """
        ]
    }
}

extension KeyAutogeneratedMacro {
    enum DiagnosticMessage: String, DiagnosticMessageConvertible {
        case noDefaultArgument = "No default value provided."
        case missingAnnotation = "No annotation provided."
        case notAnIdentifier = "Identifier is not valid."
        
        public func __conversion() throws -> any SwiftDiagnostics.DiagnosticMessage {
            AnyDiagnosticMessage(message: rawValue, severity: .error)
        }
    }
}
