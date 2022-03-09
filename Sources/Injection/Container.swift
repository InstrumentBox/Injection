//
//  Container.swift
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

public enum ContainerError: Error {
   case cannotFindRegistration(type: String, tag: Tag?)
   case typeMismatch(expected: String, given: String)
}

public final class Container {
   public static var current = Container()

   private var factories: [String: () -> Any] = [:]

   private let parent: Container?

   // MARK: - Init

   public init(parent: Container? = nil) {
      self.parent = parent
   }

   // MARK: - Registration

   public func register<Dependency>(
      taggedBy tag: Tag? = nil,
      factory: @escaping () -> Dependency
   ) {
      register(factory(), as: Dependency.self, taggedBy: tag)
   }

   public func register<Dependency>(
      _ dependency: @autoclosure @escaping () -> Dependency,
      taggedBy tag: Tag? = nil
   ) {
      register(dependency(), as: Dependency.self, taggedBy: tag)
   }

   public func register<Dependency>(
      _ dependency: @autoclosure @escaping () -> Dependency,
      as: Dependency.Type,
      taggedBy tag: Tag? = nil
   ) {
      let key = makeKey(type: Dependency.self, tag: tag)
      factories[key] = dependency
   }

   // MARK: - Resolving

   public func tryResolve<Dependency>(taggedBy tag: Tag? = nil) throws -> Dependency {
      let key = makeKey(type: Dependency.self, tag: tag)
      if let factory = factories[key] {
         let anyDependency = factory()
         guard let dependency = anyDependency as? Dependency else {
            throw ContainerError.typeMismatch(
               expected: "\(Dependency.self)",
               given: "\(type(of: anyDependency))"
            )
         }

         return dependency
      } else if let parent = parent {
         return try parent.tryResolve(taggedBy: tag)
      } else {
         throw ContainerError.cannotFindRegistration(type: "\(Dependency.self)", tag: tag)
      }
   }

   public func resolve<Dependency>(taggedBy tag: Tag? = nil) -> Dependency {
      do {
         return try tryResolve(taggedBy: tag)
      } catch let ContainerError.typeMismatch(expected, given) {
         fatalError("Can't resolve dependency: expected \(expected) but found \(given)")
      } catch let ContainerError.cannotFindRegistration(type, tag) {
         var message = "Can't resolve dependency: registration not found for \(type)"
         if let tag = tag {
            message += " tagged by \(tag)"
         }
         fatalError(message)
      } catch {
         fatalError("Can't resolve dependency: unknown error \(error)")
      }
   }

   // MARK: - Helper

   private func makeKey<Dependency>(type: Dependency.Type, tag: Tag?) -> String {
      var key = String(reflecting: Dependency.self)
      if let tag = tag {
         key += "_"
         key += tag.stringValue
      }
      return key
   }
}
