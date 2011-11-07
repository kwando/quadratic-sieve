require './lib'
start_time = Time.new # measuring time

# only jruby has "real" threads. Use one worker for all other implementations. 
nbr_of_threads = (RUBY_PLATFORM == 'java' ? 8 : 1) 

# determine size of factorbase
B = ARGV[1].to_i > 0 ? ARGV[1].to_i : 1000 

puts "generating factor base (#{B})"
F = primes(B)

N = ARGV[0].to_i


relations = RelationCollection.new
target_nbr_of_relations = F.size

kCounter = Counter.new

# creating relation finding threads
workers = []
nbr_of_threads.times{
  workers << Thread.new{
  catch(:done) do
    loop do
      k = kCounter.next
      0.upto(100) do |j|
        r = Math.sqrt(k*N).floor + j
        r2 = (r**2) % N
        factorization = Factorization.factorize(r2,F)
        if factorization
          relations.add Relation.new(r,factorization,N) do
            printf("\b"*30 + "finding relations %0.1f%%",
              ([relations.size.to_f/target_nbr_of_relations,1.0].min*100)
            )
            STDOUT.flush
          end
          # jump out of the nested loops if we found enough relations
          throw :done if relations.size >= target_nbr_of_relations
        end
      end
    end
  end
  }  
}
workers.each{|w| w.join } # wait until all threads are finished.

print "\n"

# write all relations to a file
File.open 'relations.txt','w' do |f|
  f.puts "#{relations.size} #{F.size}"
  relations.each do |r|
    f.puts r.factorization.to_bin(' ')
  end
end

# running gaussian elimination
puts "run gaussion elimination"
`./GaussBin relations.txt solution.txt`

# evaluation solutions
puts "trying results"
File.open 'solution.txt','r' do |f|
  f.gets
  while line = f.gets do
    row = line.scan(/0|1/).collect{ |a| a.to_i } # reads a solution line
    n = 0
    fact = Factorization.new(F)
    r = 1
    for i in row
      if i>0
        r *= relations[n].r
        fact*=relations[n].factorization # multiply all relations corresponding to a soluion
      end
      n += 1
    end
    a = r%N
    b = fact.sqrt.to_i%N
    res = N.gcd(b-a)
    if res > 1 and res < N
      p = N/res
      q = N/p
      
      if p*q == N # found a factorization?
        puts 'factorization complete', "#{N} = #{p} * #{q}"
        break
      end
    end
  end
end
printf("Total time %.2f s\n", Time.new - start_time)

# delete the intermediate files
File.delete('./solution.txt')
File.delete('./relations.txt')