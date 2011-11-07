require './factorization'
# def primes(n)
#   primes = []
#   i = 0
#   File.open('prim_2_24.txt','r') do |f|
#     catch(:done) do
#       loop do
#         f.gets.scan(/\b\d+\b/).each do |p|
#           throw :done if primes.size >= n
#           primes << p.to_i
#         end
#       end
#     end
#   end
#   return primes
# end

def gcd(a,b)
  return a if b == 0
  gcd(b, a % b)
end

def smooth?(int,primes)
  res = Factorization.new(primes)
  prod = 1
  for p in primes
    e = 0
    a = int
    while a % p == 0 do
      e += 1
      a = a / p
    end
    if e > 0
      prod *= p**e
      res[p] = e
    end
  end
  # puts res.join(' * ')
  [prod == int, res]
end

class Relation
  attr_reader :r, :factorization
  def initialize(r,factorization,mod)
    @r,@factorization,@mod = r,factorization,mod
  end
  def to_s
    "#{@r}^2 = #{@r**2} = #{@factorization} mod #{@mod}"
  end
  def eql? o
    if o.is_a? Relation
      return hash == o.hash
    end
    false
  end
  def hash
    @factorization.to_bin.hash
  end
end

def primes n
  primes = []
  i = 2
  loop do
    prime = true
    primes.each do |p|
      if i % p == 0
        prime = false
        break
      end
    end
    if prime
      primes << i
      return primes if primes.size >= n
    end
    i += 1
  end
end