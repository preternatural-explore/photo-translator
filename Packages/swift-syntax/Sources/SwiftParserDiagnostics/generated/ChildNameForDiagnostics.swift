//// Automatically generated by generate-swift-syntax
//// Do not edit directly!
//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2023 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

import SwiftSyntax

private func childNameForDiagnostics(_ keyPath: AnyKeyPath) -> String? {
  switch keyPath {
  case \AccessorDeclSyntax.attributes:
    return "attributes"
  case \AccessorDeclSyntax.modifier:
    return "modifiers"
  case \AccessorDeclSyntax.parameters:
    return "parameter"
  case \AccessorParametersSyntax.name:
    return "name"
  case \ActorDeclSyntax.attributes:
    return "attributes"
  case \ActorDeclSyntax.modifiers:
    return "modifiers"
  case \ActorDeclSyntax.genericParameterClause:
    return "generic parameter clause"
  case \ActorDeclSyntax.inheritanceClause:
    return "inheritance clause"
  case \ActorDeclSyntax.genericWhereClause:
    return "generic where clause"
  case \ArrayElementSyntax.expression:
    return "value"
  case \AssociatedTypeDeclSyntax.attributes:
    return "attributes"
  case \AssociatedTypeDeclSyntax.modifiers:
    return "modifiers"
  case \AssociatedTypeDeclSyntax.inheritanceClause:
    return "inheritance clause"
  case \AssociatedTypeDeclSyntax.genericWhereClause:
    return "generic where clause"
  case \AttributeSyntax.attributeName:
    return "name"
  case \AvailabilityLabeledArgumentSyntax.label:
    return "label"
  case \AvailabilityLabeledArgumentSyntax.value:
    return "value"
  case \BreakStmtSyntax.label:
    return "label"
  case \ClassDeclSyntax.attributes:
    return "attributes"
  case \ClassDeclSyntax.modifiers:
    return "modifiers"
  case \ClassDeclSyntax.genericParameterClause:
    return "generic parameter clause"
  case \ClassDeclSyntax.inheritanceClause:
    return "inheritance clause"
  case \ClassDeclSyntax.genericWhereClause:
    return "generic where clause"
  case \ClosureParameterClauseSyntax.parameters:
    return "parameters"
  case \ClosureParameterSyntax.attributes:
    return "attributes"
  case \ClosureParameterSyntax.modifiers:
    return "modifiers"
  case \ClosureParameterSyntax.type:
    return "type"
  case \ClosureShorthandParameterSyntax.name:
    return "name"
  case \ClosureSignatureSyntax.attributes:
    return "attributes"
  case \CodeBlockSyntax.statements:
    return "statements"
  case \ContinueStmtSyntax.label:
    return "label"
  case \DeinitializerDeclSyntax.attributes:
    return "attributes"
  case \DeinitializerDeclSyntax.modifiers:
    return "modifiers"
  case \DictionaryElementSyntax.key:
    return "key"
  case \DictionaryElementSyntax.value:
    return "value"
  case \DictionaryTypeSyntax.key:
    return "key type"
  case \DictionaryTypeSyntax.value:
    return "value type"
  case \DifferentiabilityWithRespectToArgumentSyntax.arguments:
    return "arguments"
  case \DoStmtSyntax.body:
    return "body"
  case \DocumentationAttributeArgumentSyntax.label:
    return "label"
  case \EnumCaseDeclSyntax.attributes:
    return "attributes"
  case \EnumCaseDeclSyntax.modifiers:
    return "modifiers"
  case \EnumCaseDeclSyntax.elements:
    return "elements"
  case \EnumCaseElementSyntax.parameterClause:
    return "associated values"
  case \EnumCaseParameterClauseSyntax.parameters:
    return "parameters"
  case \EnumCaseParameterSyntax.modifiers:
    return "modifiers"
  case \EnumCaseParameterSyntax.type:
    return "type"
  case \EnumCaseParameterSyntax.defaultValue:
    return "default value"
  case \EnumDeclSyntax.attributes:
    return "attributes"
  case \EnumDeclSyntax.modifiers:
    return "modifiers"
  case \EnumDeclSyntax.genericParameterClause:
    return "generic parameter clause"
  case \EnumDeclSyntax.inheritanceClause:
    return "inheritance clause"
  case \EnumDeclSyntax.genericWhereClause:
    return "generic where clause"
  case \ExtensionDeclSyntax.attributes:
    return "attributes"
  case \ExtensionDeclSyntax.modifiers:
    return "modifiers"
  case \ExtensionDeclSyntax.inheritanceClause:
    return "inheritance clause"
  case \ExtensionDeclSyntax.genericWhereClause:
    return "generic where clause"
  case \ForStmtSyntax.body:
    return "body"
  case \FunctionCallExprSyntax.calledExpression:
    return "called expression"
  case \FunctionCallExprSyntax.arguments:
    return "arguments"
  case \FunctionCallExprSyntax.trailingClosure:
    return "trailing closure"
  case \FunctionCallExprSyntax.additionalTrailingClosures:
    return "trailing closures"
  case \FunctionDeclSyntax.attributes:
    return "attributes"
  case \FunctionDeclSyntax.modifiers:
    return "modifiers"
  case \FunctionDeclSyntax.genericParameterClause:
    return "generic parameter clause"
  case \FunctionDeclSyntax.signature:
    return "function signature"
  case \FunctionDeclSyntax.genericWhereClause:
    return "generic where clause"
  case \FunctionParameterClauseSyntax.parameters:
    return "parameters"
  case \FunctionParameterSyntax.attributes:
    return "attributes"
  case \FunctionParameterSyntax.modifiers:
    return "modifiers"
  case \FunctionParameterSyntax.secondName:
    return "internal name"
  case \FunctionParameterSyntax.type:
    return "type"
  case \FunctionParameterSyntax.defaultValue:
    return "default value"
  case \GenericParameterSyntax.eachKeyword:
    return "parameter pack specifier"
  case \GenericParameterSyntax.name:
    return "name"
  case \GenericParameterSyntax.inheritedType:
    return "inherited type"
  case \GuardStmtSyntax.conditions:
    return "condition"
  case \GuardStmtSyntax.body:
    return "body"
  case \IfConfigClauseSyntax.condition:
    return "condition"
  case \IfExprSyntax.body:
    return "body"
  case \IfExprSyntax.elseBody:
    return "else body"
  case \ImplementsAttributeArgumentsSyntax.type:
    return "type"
  case \ImplementsAttributeArgumentsSyntax.declName:
    return "declaration name"
  case \ImportDeclSyntax.attributes:
    return "attributes"
  case \ImportDeclSyntax.modifiers:
    return "modifiers"
  case \ImportPathComponentSyntax.name:
    return "name"
  case \InitializerDeclSyntax.attributes:
    return "attributes"
  case \InitializerDeclSyntax.modifiers:
    return "modifiers"
  case \InitializerDeclSyntax.genericParameterClause:
    return "generic parameter clause"
  case \InitializerDeclSyntax.signature:
    return "function signature"
  case \InitializerDeclSyntax.genericWhereClause:
    return "generic where clause"
  case \KeyPathExprSyntax.root:
    return "root"
  case \KeyPathSubscriptComponentSyntax.arguments:
    return "arguments"
  case \LabeledExprSyntax.label:
    return "label"
  case \LabeledExprSyntax.expression:
    return "value"
  case \LabeledSpecializeArgumentSyntax.label:
    return "label"
  case \LabeledSpecializeArgumentSyntax.value:
    return "value"
  case \LabeledStmtSyntax.label:
    return "label name"
  case \LayoutRequirementSyntax.type:
    return "constrained type"
  case \LayoutRequirementSyntax.size:
    return "size"
  case \LayoutRequirementSyntax.alignment:
    return "alignment"
  case \MacroDeclSyntax.attributes:
    return "attributes"
  case \MacroDeclSyntax.modifiers:
    return "modifiers"
  case \MacroDeclSyntax.genericParameterClause:
    return "generic parameter clause"
  case \MacroDeclSyntax.signature:
    return "macro signature"
  case \MacroDeclSyntax.definition:
    return "macro definition"
  case \MacroDeclSyntax.genericWhereClause:
    return "generic where clause"
  case \MacroExpansionDeclSyntax.attributes:
    return "attributes"
  case \MacroExpansionDeclSyntax.modifiers:
    return "modifiers"
  case \MemberAccessExprSyntax.base:
    return "base"
  case \MemberAccessExprSyntax.declName:
    return "name"
  case \MemberTypeSyntax.baseType:
    return "base type"
  case \MemberTypeSyntax.name:
    return "name"
  case \MetatypeTypeSyntax.baseType:
    return "base type"
  case \MultipleTrailingClosureElementSyntax.label:
    return "label"
  case \ObjCSelectorPieceSyntax.name:
    return "name"
  case \OperatorDeclSyntax.fixitySpecifier:
    return "fixity"
  case \OperatorPrecedenceAndTypesSyntax.precedenceGroup:
    return "precedence group"
  case \PatternBindingSyntax.typeAnnotation:
    return "type annotation"
  case \PlatformVersionSyntax.platform:
    return "platform"
  case \PlatformVersionSyntax.version:
    return "version"
  case \PoundSourceLocationArgumentsSyntax.fileName:
    return "file name"
  case \PoundSourceLocationArgumentsSyntax.lineNumber:
    return "line number"
  case \PoundSourceLocationSyntax.arguments:
    return "arguments"
  case \PrecedenceGroupDeclSyntax.attributes:
    return "attributes"
  case \PrecedenceGroupDeclSyntax.modifiers:
    return "modifiers"
  case \PrecedenceGroupNameSyntax.name:
    return "name"
  case \PrimaryAssociatedTypeSyntax.name:
    return "name"
  case \ProtocolDeclSyntax.attributes:
    return "attributes"
  case \ProtocolDeclSyntax.modifiers:
    return "modifiers"
  case \ProtocolDeclSyntax.primaryAssociatedTypeClause:
    return "primary associated type clause"
  case \ProtocolDeclSyntax.inheritanceClause:
    return "inheritance clause"
  case \ProtocolDeclSyntax.genericWhereClause:
    return "generic where clause"
  case \RepeatStmtSyntax.body:
    return "body"
  case \RepeatStmtSyntax.condition:
    return "condition"
  case \ReturnClauseSyntax.type:
    return "return type"
  case \SameTypeRequirementSyntax.leftType:
    return "left-hand type"
  case \SameTypeRequirementSyntax.rightType:
    return "right-hand type"
  case \SpecializeAvailabilityArgumentSyntax.availabilityLabel:
    return "label"
  case \SpecializeTargetFunctionArgumentSyntax.targetLabel:
    return "label"
  case \SpecializeTargetFunctionArgumentSyntax.declName:
    return "declaration name"
  case \StructDeclSyntax.attributes:
    return "attributes"
  case \StructDeclSyntax.modifiers:
    return "modifiers"
  case \StructDeclSyntax.genericParameterClause:
    return "generic parameter clause"
  case \StructDeclSyntax.inheritanceClause:
    return "inheritance clause"
  case \StructDeclSyntax.genericWhereClause:
    return "generic where clause"
  case \SubscriptCallExprSyntax.calledExpression:
    return "called expression"
  case \SubscriptCallExprSyntax.arguments:
    return "arguments"
  case \SubscriptCallExprSyntax.trailingClosure:
    return "trailing closure"
  case \SubscriptCallExprSyntax.additionalTrailingClosures:
    return "trailing closures"
  case \SubscriptDeclSyntax.attributes:
    return "attributes"
  case \SubscriptDeclSyntax.modifiers:
    return "modifiers"
  case \SubscriptDeclSyntax.genericParameterClause:
    return "generic parameter clause"
  case \SubscriptDeclSyntax.genericWhereClause:
    return "generic where clause"
  case \SwitchCaseSyntax.label:
    return "label"
  case \TernaryExprSyntax.condition:
    return "condition"
  case \TernaryExprSyntax.thenExpression:
    return "first choice"
  case \TernaryExprSyntax.elseExpression:
    return "second choice"
  case \TuplePatternElementSyntax.label:
    return "label"
  case \TupleTypeElementSyntax.firstName:
    return "name"
  case \TupleTypeElementSyntax.secondName:
    return "internal name"
  case \TypeAliasDeclSyntax.attributes:
    return "attributes"
  case \TypeAliasDeclSyntax.modifiers:
    return "modifiers"
  case \TypeAliasDeclSyntax.genericParameterClause:
    return "generic parameter clause"
  case \TypeAliasDeclSyntax.genericWhereClause:
    return "generic where clause"
  case \TypeInitializerClauseSyntax.value:
    return "type"
  case \VariableDeclSyntax.attributes:
    return "attributes"
  case \VariableDeclSyntax.modifiers:
    return "modifiers"
  default:
    return nil
  }
}

extension SyntaxProtocol {
  var childNameInParent: String? {
    guard let keyPath = self.keyPathInParent else {
      return nil
    }
    return childNameForDiagnostics(keyPath)
  }
}
