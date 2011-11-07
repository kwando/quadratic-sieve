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
