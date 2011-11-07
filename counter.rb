require 'thread'
class Counter
  def initialize(init=0)
    @value = init
    @mutex = Mutex.new
  end
  def next
    @mutex.synchronize{ @value += 1 }
  end
  def value
    @mutex.synchronize{ @value }
  end
end