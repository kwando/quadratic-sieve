require 'thread'
# A dataclass holding relations. Threadsafe
class RelationCollection
  def initialize
    @uniqe = Hash.new(true)
    @relations = []
    @mutex = Mutex.new
  end
  
  # adds the relation to if it's binary representation is uniqe. Executes block if relation is added.
  def add relation, &block
    b = relation.factorization.to_bin
    @mutex.synchronize do
      if @uniqe[b]
        @relations << relation
        @uniqe[b] = false
      end
      yield if block_given? # executes the given code block
    end
  end
  
  def size
    @relations.size
  end
  
  def each &block
    @mutex.synchronize{ @relations.each(&block) }
  end
  
  def [] index
    @mutex.synchronize{ @relations[index] }
  end
end