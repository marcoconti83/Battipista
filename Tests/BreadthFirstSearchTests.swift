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

import XCTest
import Battipista

/// Node within finite graph
private typealias TestNode = GraphNodeFromGraphEdges<String>

class BreadthFirstSearchTests: XCTestCase {
    
    func testThatItReturnsTheStartNode() {
        
        // given
        let node = TestNode(graphEdges: [:], nodeContent: "a")
        let sut = BreadthFirstSearch(root: node)
        
        // when
        let next = sut.next()?.last
        
        // then
        XCTAssertEqual(next?.content, "a")
    }

    func testThatVisitsInBreadthFirstOrder() {
        
        // given
        let node = TestNode(graphEdges: [
            "0" : ["1a","1b"],
            "1a" : ["2a", "2b"],
            "1b" : ["2c"],
            "2a" : ["3a"]
            ], nodeContent: "0")
        let sut = BreadthFirstSearch(root: node)
        
        // when
        let nodes = sut.map { $0.last!.content }
        
        
        // then
        XCTAssertEqual(nodes, ["0", "1a", "1b", "2a", "2b", "2c", "3a"])
    }
    
    func testThatItDoesNotRevisitNodesIfThereIsACycle() {
        
        // given
        let node = TestNode(graphEdges: [
            "0" : ["1a","1b"],
            "1a" : ["0"]
            ], nodeContent: "0")
        let sut = BreadthFirstSearch(root: node)
        
        // when
        let nodes = sut.map { $0.last!.content }
        
        
        // then
        XCTAssertEqual(nodes, ["0", "1a", "1b"])
    }
    
    func testThatItReturnsTheVisitHistory() {
        
        // given
        let node = TestNode(graphEdges: [
            "0" : ["1a","1b"],
            "1a" : ["2a"]
            ], nodeContent: "0")
        let sut = BreadthFirstSearch(root: node)
        
        // when
        let visitHistory = sut.map { $0.map { $0.content } }
        
        // then
        let expected = [
            ["0"],
            ["0","1a"],
            ["0","1b"],
            ["0","1a","2a"]
        ]
        XCTAssertEqual(visitHistory, expected)
        
    }
    
    func testThatItVisitAnInfiniteTreeByLevels() {
        
        // given
        let node = GraphNodeFromGeneratingFunction(nodeContent: "", childrenGenerator: {
            parent in return ["L","R"].map { parent + $0 }
        })
        let sut = BreadthFirstSearch(root: node)
        let levels = 4
        
        // when
        let generator = sut.generate()
        var generatedPaths = [[GraphNodeFromGeneratingFunction<String>]]()
        while generatedPaths.count < 100 { // safety count in case there is a bug and the test would never end
            guard let next = generator.next() where next.count < levels+1 else { break }
            generatedPaths.append(next)
        }
        
        // then
        let expectedCount :Int = Int(pow(2.0, Double(levels)))-1
        XCTAssertEqual(generatedPaths.count, expectedCount)
        
    }
}
