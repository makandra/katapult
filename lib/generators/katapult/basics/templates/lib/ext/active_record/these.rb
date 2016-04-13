ActiveRecord::Base.class_eval do

  def self.these(arg)
    where(id: arg.collect_ids)
  end

end
