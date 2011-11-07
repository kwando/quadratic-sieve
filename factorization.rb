class Factorization
  def initialize(factorbase)
    @factorbase = factorbase
    @factors = Hash.new(0)
  end
  def add(b,e)
    if @factors.include? b
      if (@factors[b] = @factors[b]+e) == 0
        @factors.delete(b)
      end
    else
      @factors[b] = e
    end
    self
  end
  def add_factor(b,e)
    if @factors.include? b
      if (@factors[b] = @factors[b]+e) == 0
        @factors.delete(b)
      end
    else
      @factors[b] = e
    end
    self
  end
  def * f
    result = Factorization.new(@factorbase)
    @factors.each do |b,e|
      result.add(b,e)
    end
    f.factors.each do |b,e|
      result.add(b,e)
    end
    result
  end
  def ** exp
    res=Factorization.new(@factorbase)
    for b,e in factors
      res.add(b,e*exp)
    end
    res
  end
  def to_i
    @factors.inject(1){|a,f| a*(f[0]**f[1])}
  end
  def to_s
    return 1 if @factors.empty?
    @factors.inject([]){|a,f| a << "#{f[0]}^#{f[1]}"}.join(' * ')
  end
  def to_bin(separator='')
    Array.new(factorbase.size){|i| (factors[factorbase[i]] || 0)%2 }.join(separator)
  end
  def hash
    to_bin.hash
  end
  def inspect
    "#{to_i} = #{to_s}"
  end
  def [] key
    @factors[key]
  end
  def []= key,value
    @factors[key] = value
  end
  def sqrt
    res = Factorization.new(factorbase)
    factors.each do |b,e|
      raise 'error' if e % 2 > 0
      res.add(b, e / 2)
    end
    res
  end
  protected
  def factors
    @factors
  end
  def factorbase
    @factorbase
  end
end