//
//  InjectedTestCase.swift
//
//  Copyright © 2022 Aleksei Zaikin.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Injection
import XCTest

final class InjectedTestCase: XCTestCase {
   private static let dependency = FakeDependency()
   private static let taggedDependency = FakeDependency()

   // MARK: - Lifecycle

   override class func setUp() {
      super.setUp()

      let container = Container()
      container.register(dependency, as: Dependency.self)
      container.register(taggedDependency, as: Dependency.self, taggedBy: DependencyTag.fake)
      Container.shared = container
   }

   // MARK: - Test Cases

   func test_injected_resolvesDependency() {
      XCTAssertTrue(FakeDependency().dependency === InjectedTestCase.dependency)
   }

   func test_injected_resolvesTaggedDependency() {
      XCTAssertTrue(FakeDependency().taggedDependency === InjectedTestCase.taggedDependency)
   }

   func test_projectedValue_changesTag() {
      let dependency = FakeDependency()
      dependency.$dependency.tag = DependencyTag.fake
      XCTAssertTrue(dependency.dependency === InjectedTestCase.taggedDependency)
   }
}
