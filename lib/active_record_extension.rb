module ActiveRecordExtension

  extend ActiveSupport::Concern

  # add your instance methods here

  # add your static(class) methods here
  class_methods do
  #E.g: Order.top_ten
    def pool
      all.map(&:id)
    end

    def load_random
      offset(rand(self.count)).first
    end
  end
end

# include the extension
ActiveRecord::Base.send(:include, ActiveRecordExtension)