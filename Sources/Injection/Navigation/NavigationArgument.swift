//
//  NavigationArgument.swift
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

@propertyWrapper
public final class NavigationArgument<Context: NavigationContext> {
   @Injected
   private var context: Context

   // MARK: - Init

   public init(tag: Tag?) {
      _context = Injected(tag: tag)
   }

   public convenience init() {
      self.init(tag: nil)
   }

   // MARK: - Property Wrapper

   public var wrappedValue: Context.Argument {
      get {
         guard let argument = context.argument else {
            fatalError("Access to argument in \(Context.self) before it has been initialized")
         }

         return argument
      }
      set {
         context.argument = newValue
      }
   }

   public var projectedValue: Projection {
      Projection(
         injectedProjection: $context,
         onGetContext: { self.context },
         onSetContext: { self.context = $0 }
      )
   }
}
