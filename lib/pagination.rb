module Pagination

  extend ActiveSupport::Concern

  # add your instance methods here

  # add your static(class) methods here
  class_methods do
  #E.g: Order.top_ten

    def current_page=(page_no)
      @page_no = page_no
    end

    def current_page
      @page_no
    end
    
    def total_pages=(pages)
      @pages = pages
    end
    
    def total_pages
      @pages
    end

    #returns specified number of records and sets pagination related attributes
    def paginate(options={})
      page = options[:page].to_i if options[:page]
      page ||= 0
      per_page = options[:per_page].to_i if options[:per_page]
      per_page ||= 10
      self.current_page = page
      self.total_pages = self.count / per_page
      self.offset(per_page * page).limit(per_page).decorate
    end

  end
end

# include the extension
ActiveRecord::Base.send(:include, Pagination)