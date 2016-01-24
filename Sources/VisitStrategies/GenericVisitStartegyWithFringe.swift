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

public class GenericVisitStartegyWithFringe<Node : GraphNode> : GraphVisitStrategy {
    
    /// Function usable to select the next node to visit from the fringe
    public typealias FringeSelectionFunction = [[Node]] -> Int
    
    /// Nodes that have been already visited
    private var visitedNodes = Set<Node>()
    
    /// Fringe of the visit, with full path of how the node was reached
    private var fringe = Array<[Node]>()
    
    /// Fringe lookup set, for faster `is in` test
    private var fringeLookup = Set<Node>()
    
    /// The function used to select the next node to visit from the fringe
    private let fringeSelectionFunction : FringeSelectionFunction
    
    /// Creates a generic visit strategy with the given fringe selection function
    /// - param fringeSelectionFunction: this function will be called when the fringe is not empty and there is the need
    ///     to select the next path from the fringe. It has to return a valid index in the fringe. The path at that index
    ///     will be used as the next node to visit
    public init(root: Node, fringeSelectionFunction : FringeSelectionFunction) {
        self.fringeSelectionFunction = fringeSelectionFunction
        self.fringe.append([root])
    }
    
    public func next() -> [Node]? {
        if let path = removeFirstFromFringe() {
            let node = path.last!
            self.visitedNodes.insert(node)
            node.children
                .filter { !visitedNodes.contains($0) && !fringeLookup.contains($0) &&  $0 != node}
                .forEach { self.addToFringe($0, previousPath: path) }
            return path
        }
        return .None
    }
    
    /// Adds an element to the fringe
    private func addToFringe(node: Node, previousPath: [Node]) {
        self.fringe.append(previousPath + [node])
        self.fringeLookup.insert(node)
    }
    
    /// Removes and returns the first element in the fringe
    private func removeFirstFromFringe() -> [Node]? {
        if(self.fringe.isEmpty) {
            return .None
        }
        let index = self.fringeSelectionFunction(self.fringe)
        let nodes = self.fringe[index]
        self.fringe.removeAtIndex(index)
        self.fringeLookup.remove(nodes.last!)
        return nodes
    }
    
}