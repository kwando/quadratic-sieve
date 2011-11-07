require 'thread'
# A dataclass holding relations. Threadsafe
class RelationCollection
  def initialize
    @uniqe = Hash.new(true)
    @relations = []
    @mutex = Mutex.new
  end
  def << relation
    b = relation.factorization.to_bin
    @mutex.synchronize do
      if @uniqe[b]
        @relations << relation
        @uniqe[b] = false
      end
      @relations.size
    end
  end
  def size
    return @relations.size
  end
  def each &block
    @mutex.synchronize{ @relations.each(&block) }
  end
  def [] index
    @mutex.synchronize{ @relations[index] }
  end
end