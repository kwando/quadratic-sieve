require './factorization'
require './relation'
require './counter'
require './relation_collection'

# checks whether the number n is smooth with respect to the factorbase
# def smooth?(n,factorbase)
#   factorization = Factorization.new(factorbase)
#   prod = 1 # factorization check
#   for p in factorbase
#     e = 0
#     a = n
#     while a % p == 0 do
#       e += 1
#       a = a / p
#     end
#     if e > 0
#       prod *= p**e # just a checksum
#       factorization.add(p,e)
#     end
#   end
#   return false unless prod == n
#   factorization
# end

# Generates the first n prime numbers
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


class Numeric
  # Extend all numeric types with a GCD operation
  def gcd(b)
    return self if b == 0
    b.gcd(self % b)
  end
end