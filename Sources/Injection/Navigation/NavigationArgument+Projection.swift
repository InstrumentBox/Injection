//
//  NavigationArgument+Projection.swift
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

extension NavigationArgument {
   public final class Projection {
      private let _tag: Injected<Context>.Tag
      private let onGetContext: () -> Context
      private let onSetContext: (Context) -> Void

      // MARK: - Init

      init(
         tag: Injected<Context>.Tag,
         onGetContext: @escaping () -> Context,
         onSetContext: @escaping (Context) -> Void
      ) {
         self._tag = tag
         self.onGetContext = onGetContext
         self.onSetContext = onSetContext
      }

      // MARK: - Projection

      public var context: Context {
         get {
            onGetContext()
         }
         set {
            onSetContext(newValue)
         }
      }

      public var tag: Injection.Tag? {
         get {
            _tag.tag
         }
         set {
            _tag.tag = newValue
         }
      }
   }
}
