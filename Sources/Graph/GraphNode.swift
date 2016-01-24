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
A Node in a graph
*/
public protocol GraphNode : Hashable, Equatable {
  
    typealias Content : Hashable, Equatable
    
    /**
     The wrapped content of the node.
     This is the information that the graph holds.
     E.g. in a graph of strings, this is a string
     */
    var content: Content {get}
    
    /// The list of neighbours of this Node in the graph
    var children: [Self] {get}
}

public extension GraphNode {
    
    var hashValue: Int { return self.content.hashValue }
}

public func ==<Node1 : GraphNode, Node2 : GraphNode where Node1.Content == Node2.Content>(lhs: Node1, rhs: Node2) -> Bool
{
    return lhs.content == rhs.content
}
