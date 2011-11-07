class Factorization
  def self.factorize(n, factorbase)
    factorization = Factorization.new(factorbase)
    prod = 1 # factorization check
    for p in factorbase
      e = 0
      a = n
      while a % p == 0 do
        e += 1
        a = a / p
      end
      if e > 0
        prod *= p**e # just a checksum
        factorization.add(p,e)
      end
    end
    return false unless prod == n
    factorization
  end
  
  def initialize(factorbase)
    @factorbase = factorbase
    @factors = Hash.new(0) # zero is the default value of the hash
  end
  
  # add a factor to the factorization
  def add(b,e)
    if (@factors[b] = @factors[b]+e) == 0
      @factors.delete(b)
    end
    self
  end
  
  # multiplies this factoriztion with a other factorization
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
  
  def to_i
    @factors.inject(1){|a,f| a*(f[0]**f[1])}
  end
  
  def to_s
    return 1 if @factors.empty?
    @factors.inject([]){|a,f| a << "#{f[0]}^#{f[1]}"}.join(' * ')
  end
  
  # the binary representation of this factorization (coefficients are taken mod 2)
  def to_bin(separator='')
    Array.new(factorbase.size){|i| (factors[factorbase[i]] || 0) % 2 }.join(separator)
  end
  
  def empty?
    factors.empty?
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
    self.add(key)
    @factors[key] = value
  end
  
  # take the square root of this factorization
  def sqrt
    res = Factorization.new(factorbase)
    factors.each do |b,e|
      raise 'all exponents are not a power of 2' if e % 2 > 0
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