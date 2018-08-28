import Metal

class MetalPokerEvaluator {
    
    let commandQueue: MTLCommandQueue
    let pipeline: MTLComputePipelineState
    
    init?() {
        guard let device = MTLCreateSystemDefaultDevice() else { return nil }
        guard let commandQueue = device.makeCommandQueue() else { return nil }
        self.commandQueue = commandQueue
        guard let library = device.makeDefaultLibrary() else { return nil }
        guard let function = library
            .makeFunction(name: "scoreKernal") else { return nil }
        guard let pipeline = try? device
            .makeComputePipelineState(function: function) else { return nil }
        self.pipeline = pipeline
    }
    
    func score(hands: [CardMask]) -> [HandScore] {
        guard let commandBuffer = commandQueue
            .makeCommandBuffer() else { return [] }
        guard let commandEncoder = commandBuffer
            .makeComputeCommandEncoder() else { return [] }
        let device = commandQueue.device
        guard let handsBuffer = device.makeBuffer(
            bytes: UnsafeRawPointer(hands),
            length: MemoryLayout<CardMask>.stride * hands.count,
            options: []
            ) else { return [] }
        guard let scoresBuffer = device.makeBuffer(
            length: MemoryLayout<HandScore>.stride * hands.count,
            options: []
            ) else { return [] }
        commandEncoder.setComputePipelineState(pipeline)
        commandEncoder.setBuffer(handsBuffer, offset: 0, index: 0)
        commandEncoder.setBuffer(scoresBuffer, offset: 0, index: 1)
        var threadCount = CUnsignedInt(hands.count)
        commandEncoder.setBytes(
            &threadCount,
            length: MemoryLayout<CUnsignedInt>.size,
            index: 2
        )
        let w = pipeline.threadExecutionWidth
        let threadsPerThreadgroup = MTLSize(
            width: w,
            height: 1,
            depth: 1
        )
        let threadgroupsPerGrid = MTLSize(
            width: (Int(threadCount) + w - 1) / w,
            height: 1,
            depth: 1
        )
        commandEncoder.dispatchThreadgroups(
            threadgroupsPerGrid,
            threadsPerThreadgroup: threadsPerThreadgroup
        )
        commandEncoder.endEncoding()
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
        let scores = UnsafeBufferPointer<HandScore>(
            start: scoresBuffer.contents()
                .assumingMemoryBound(to: HandScore.self),
            count: Int(threadCount)
        )
        return [HandScore](scores)
    }
}
