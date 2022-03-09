//
//  ContainerTestCase.swift
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

final class ContainerTestCase: XCTestCase {
   private let dependency = FakeDependency()
   private var container: Container!

   // MARK: - Lifecycle

   override func setUp() {
      super.setUp()

      container = Container()
   }

   override func tearDown() {
      super.tearDown()

      container = nil
   }

   // MARK: - Test Cases

   func test_container_registersThenResolvesDependency() throws {
      container.register(self.dependency, as: Dependency.self)
      let dependency: Dependency = try container.tryResolve()
      XCTAssertTrue(dependency === self.dependency)
   }

   func test_container_registersThenResolvesTaggedDependency() throws {
      container.register(self.dependency, as: Dependency.self, taggedBy: DependencyTag.fake)
      let dependency: Dependency = try container.tryResolve(taggedBy: DependencyTag.fake)
      XCTAssertTrue(dependency === self.dependency)
   }

   func test_container_registersThenResolvesDependency_usingMethodAsFactory() throws {
      container.register(factory: makeDependency)
      let dependency: Dependency = try container.tryResolve()
      XCTAssertTrue(dependency === dependency)
   }

   func test_container_resolvesDependencyFromParent() throws {
      container.register(self.dependency)
      let container = Container(parent: container)
      let dependency: FakeDependency = try container.tryResolve()
      XCTAssertTrue(dependency === self.dependency)
   }

   func test_container_throwsNoRegistrationError() {
      do {
         _ = try container.tryResolve() as Dependency
         XCTFail("Unexpected resolved dependency")
      } catch let ContainerError.cannotFindRegistration(type, tag) {
         XCTAssertEqual(type, "Dependency")
         XCTAssertNil(tag)
      } catch {
         XCTFail("Unexpected error thrown \(error)")
      }
   }

   // MARK: - Factory

   private func makeDependency() -> Dependency {
      return dependency
   }
}
