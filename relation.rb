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