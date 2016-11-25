MIN = 1000

class Queue
    constructor: ->
        @queue = []
        @offset = 0

    getSize: ->
        return (@queue.length - @offset)

    isEmpty: ->
        return (@getSize() < 1)

    enqueue: (item) ->
        @queue.push(item)

    enqueueMulti: (items) ->
        for item in items
            @queue.push(item)

    dequeue: ->
        if @isEmpty()
            return undefined

        item = @queue[@offset]
        @offset += 1

        if @offset > MIN
            @queue = @queue.slice(@offset)
            @offset = 0

        return item

    peek: ->
        return (@isEmpty() ? undefined : @queue[@offset])

module.exports = {
    Queue
}
