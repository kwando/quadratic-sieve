#! /usr/bin/ruby
require './lib'
include Math


B = ARGV[1].to_i > 0 ? ARGV[1].to_i : 500
puts "generating factor base (#{B})"
F = primes(B)
# N = 182275519598130020422753
# N = 392742364277
# N = 112120391182534608975671
N = ARGV[0].to_i


check = Hash.new(false)
relations = RelationCollection.new
target_nbr_of_relations = F.size

next_k = Counter.new

start_time = Time.new
print "finding relations "
STDOUT.flush
workers = []
1.times{
  workers << Thread.new{
  catch(:done) do
  loop do
    k = next_k.next
    0.upto(100) do |j|
      r = sqrt(k*N).floor + j
      r2 = (r**2) % N
      factorization = Factorization.factorize(r2,F)
      if factorization
        relations << Relation.new(r,factorization,N)
        printf("\b"*30 + "finding relations %0.1f%%",(relations.size.to_f/target_nbr_of_relations*100))
        STDOUT.flush
        throw :done if relations.size >= target_nbr_of_relations
      end
    end
  end
  end
  }  
}
workers.each{|w| w.join }

print "\n"

File.open 'relations.txt','w' do |f|
  f.puts "#{relations.size} #{F.size}"
  relations.each do |r|
    f.puts r.factorization.to_bin(' ')
  end
end

puts "run gaussion elimination"
`./GaussBin relations.txt solution.txt`

puts "trying results"
File.open 'solution.txt','r' do |f|
  f.gets
  while line = f.gets do
    row = line.scan(/0|1/).collect{|a|a.to_i}
    n = 0
    fact = Factorization.new(F)
    r = 1
    for i in row
      if i>0
        r *= relations[n].r
        fact*=relations[n].factorization
      end
      n += 1
    end
    a = r%N
    b = fact.sqrt.to_i%N
    res = N.gcd(b-a)
    if res > 1 and res < N
      p = N/res
      q = N/p
      if p*q == N
        puts 'factorization complete', "#{N} = #{p} * #{q}"
        break
      end
    end
  end
end
printf "Total time %.2f s\n",Time.new - start_time
