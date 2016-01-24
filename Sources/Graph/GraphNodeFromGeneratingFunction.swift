//
//The MIT License (MIT)
//
//Copyright (c) 2015 Marco Conti<marcoconti83@gmail.com>
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.
//

import Foundation

/**
 A node in the graph that returns its children by applying a function to the current content. 
 The function is passed to its children, so they can also generate children in the same way
 */
public struct GraphNodeFromGeneratingFunction<T where T : Hashable, T: Equatable> : GraphNode {
    
    public typealias Content = T
    
    public typealias ChildrenGenerator = Content -> [Content]
    
    // function to generate children content
    let childrenGenerator : ChildrenGenerator
    
    public var children : [GraphNodeFromGeneratingFunction<T>] {
        return self.childrenGenerator(self.content).map { GraphNodeFromGeneratingFunction(nodeContent: $0, childrenGenerator: self.childrenGenerator) }
    }
    
    /*
    Returns a node in a graph that is fully specified by the graph edges
    - param childrenGenerator: the function used to generate the content of children nodes
    - param nodeContent: the content of the present node
    */
    public init(nodeContent: T, childrenGenerator : ChildrenGenerator) {
        self.content = nodeContent
        self.childrenGenerator = childrenGenerator
    }
    
    public let content : T
    
}