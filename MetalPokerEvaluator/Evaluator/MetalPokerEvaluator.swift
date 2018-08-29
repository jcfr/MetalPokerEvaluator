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
            .makeFunction(name: "scoreKernel") else { return nil }
        guard let pipeline = try? device
            .makeComputePipelineState(function: function) else { return nil }
        self.pipeline = pipeline
    }
    
    func dispatchScoreCommand(
        handsBuffer: MTLBuffer,
        scoresBuffer: MTLBuffer,
        count: Int) -> MTLCommandBuffer? {
        
        // Initialize one-off command queue and encoder
        guard let commandBuffer = commandQueue
            .makeCommandBuffer() else { return nil }
        guard let commandEncoder = commandBuffer
            .makeComputeCommandEncoder() else { return nil }
        commandEncoder.setComputePipelineState(pipeline)

        // Set buffer pointers
        commandEncoder.setBuffer(handsBuffer, offset: 0, index: 0)
        commandEncoder.setBuffer(scoresBuffer, offset: 0, index: 1)
        
        // Set variables
        var threadCount = CUnsignedInt(count)
        commandEncoder.setBytes(
            &threadCount,
            length: MemoryLayout<CUnsignedInt>.size,
            index: 2
        )

        // Calculate optimal execution threadgroup size and grid size
        let w = pipeline.threadExecutionWidth
        // TODO: Benchmark larger threadgroups
        // let h = pipeline.maxTotalThreadsPerThreadgroup / w
        let threadsPerThreadgroup = MTLSize(
            width: w,
            height: 1,
            depth: 1
        )
        let threadgroupsPerGrid = MTLSize(
            width: (count + w - 1) / w,
            height: 1,
            depth: 1
        )

        // Dispatch execution request
        commandEncoder.dispatchThreadgroups(
            threadgroupsPerGrid,
            threadsPerThreadgroup: threadsPerThreadgroup)
        commandEncoder.endEncoding()
        commandBuffer.commit()
        
        // Return queued command buffer
        return commandBuffer
    }
    
    func makeHandsBuffer(hands: [CardMask]) -> MTLBuffer? {
        return commandQueue.device.makeBuffer(
            bytes: UnsafeRawPointer(hands),
            length: MemoryLayout<CardMask>.stride * hands.count,
            options: []
        )
    }
    
    func makeScoreBuffer(count: Int) -> MTLBuffer? {
        return commandQueue.device.makeBuffer(
            length: MemoryLayout<HandScore>.stride * count,
            options: []
        )
    }
    
    func makeScoresArray(scoresBuffer: MTLBuffer, count: Int) -> [HandScore] {
        let scoresPointer = scoresBuffer
            .contents()
            .assumingMemoryBound(to: HandScore.self)
        let scoresBufferPointer = UnsafeBufferPointer(
            start: scoresPointer,
            count: count
        )
        return [HandScore](scoresBufferPointer)
    }
    
    func score(hands: [CardMask]) -> [HandScore] {
        guard let handsBuffer = makeHandsBuffer(hands: hands) else { return [] }
        guard let scoresBuffer = makeScoreBuffer(count: hands.count) else { return [] }
        guard let commandBuffer = dispatchScoreCommand(
            handsBuffer: handsBuffer,
            scoresBuffer: scoresBuffer,
            count: hands.count
            ) else { return [] }
        commandBuffer.waitUntilCompleted()
        let scores = makeScoresArray(scoresBuffer: scoresBuffer, count: hands.count)
        return scores
    }
}
