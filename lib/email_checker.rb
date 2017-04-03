class EmailChecker
  def initialize(emails)
    @emails = emails || "" #prevent nil value
    @emails = @emails.split(/,|;/).map(&:strip).uniq
    @valid = []
    @invalid = []
    @emails.each do |e|
      if e.match(/^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i)
        @valid << e
      else
        @invalid << e
      end
    end
  end

  def valid
    @valid
  end
  
  def invalid
    @invalid
  end
  
  def valid?
    if self.valid.count == 1
      true
    else
      false
    end
  end
end
