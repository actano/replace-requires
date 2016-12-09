/**
 * Created by christianbunse on 18/11/2016.
 */

/*

 Queue.js

 A function to represent a queue

 Created by Stephen Morley - http://code.stephenmorley.org/ - and released under
 the terms of the CC0 1.0 Universal legal code:

 http://creativecommons.org/publicdomain/zero/1.0/legalcode

 */

const MIN = 1000

/* Creates a new queue. A queue is a first-in-first-out (FIFO) data structure -
 * items are added to the end of the queue and removed from the front.
 */
class Queue {
  // initialise the queue and offset
  constructor() {
    this.queue = []
    this.offset = 0
  }

  // Returns the size of the queue.
  getSize() {
    return (this.queue.length - this.offset)
  }

  // Returns true if the queue is empty, and false otherwise.
  isEmpty() {
    return (this.getSize() < 1)
  }

  /* Enqueues the specified item. The parameter is:
   *
   * item - the item to enqueue
   */
  enqueue(item) {
    this.queue.push(item)
  }

  enqueueMulti(items) {
    items.forEach((item) => {
      this.queue.push(item)
    })
  }

  /* Dequeues an item and returns it. If the queue is empty, the value
   * 'undefined' is returned.
   */
  dequeue() {
    // if the queue is empty, return immediately
    if (this.isEmpty()) return undefined

    // store the item at the front of the queue
    const item = this.queue[this.offset]

    // increment the offset and remove the free space if necessary
    this.offset += 1
    // this.offset > MIN && this.offset * 2 >= this.queue.length
    if (this.offset > MIN) {
      console.log('restructuring queue')
      this.queue = this.queue.slice(this.offset)
      this.offset = 0
    }

    // return the dequeued item
    return item
  }

  /* Returns the item at the front of the queue (without dequeuing it). If the
   * queue is empty then undefined is returned.
   */
  peek() {
    return (this.isEmpty() ? undefined : this.queue[this.offset])
  }
}

export default Queue
