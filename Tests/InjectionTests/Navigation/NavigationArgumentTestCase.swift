//
//  NavigationArgumentTestCase.swift
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

final class NavigationArgumentTestCase: XCTestCase {
   // MARK: - Lifecycle

   override func setUpWithError() throws {
      try super.setUpWithError()

      makeContainer()
   }

   // MARK: - Test Cases

   func test_navigationArgument_passesValueBetweenObjects() {
      let source = Source()
      let destination = Destination()
      source.argument = 42
      XCTAssertEqual(destination.argument, 42)
   }

   func test_navigationArgumentProjection_assignsContext() {
      let context = SourceToDestinationNavigationContext()
      context.argument = 43
      let source = Source()
      source.$argument.context = context
      XCTAssertEqual(source.argument, 43)
   }

   // MARK: - Helper

   private func makeContainer() {
      let container = Container()
      container.register(SourceToDestinationNavigationContext.shared)
      Container.shared = container
   }
}

private final class SourceToDestinationNavigationContext: NavigationContext {
   private static weak var _shared: SourceToDestinationNavigationContext?

   static var shared: SourceToDestinationNavigationContext {
      if let _shared = _shared {
         return _shared
      }

      let _shared = SourceToDestinationNavigationContext()
      self._shared = _shared
      return _shared
   }

   var argument: Int?
}

private final class Source {
   @NavigationArgument<SourceToDestinationNavigationContext>
   var argument
}

private final class Destination {
   @NavigationArgument<SourceToDestinationNavigationContext>
   var argument
}
