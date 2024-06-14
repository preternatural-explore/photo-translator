//
// Copyright (c) Vatsal Manot
//

import Swallow
import SwallowMacrosClient
import XCTest

final class _GenericRuntimeConversionsTests: XCTestCase {
    fileprivate struct Foo: Hashable, Identifiable {
        let id: Int
    }
    
    func testIdentifierIndexingArrayToArray() throws {
        let conversion = _GenericRuntimeConversions.IdentifierIndexingArray_Array.self
        
        let lhs: IdentifierIndexingArrayOf<Foo> = [Foo(id: 0), Foo(id: 1), Foo(id: 2)]
        let rhs = try conversion.__convert(source: lhs, to: Array<Foo>.self)
        
        XCTAssert(lhs == IdentifierIndexingArrayOf(rhs))
    }
}
