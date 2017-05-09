module MigrationTemp

  def self.migrate
    lists = List.all
    puts "Going to update #{lists.count} lists"

    lists.each do |l|
      puts "Rec. id #{l.id}, occasion_data: #{l.occasion_data} / #{l.occasion_data.class}"
      if l.occasion_data.is_a?(Hash)
        puts "____skipping (hash)"
      next
      end

      value = l.occasion_data
      puts "____updating record id #{l.id}, value #{value}"
      l.occasion_data = {}
      l.occasion_data[:other] = value
      puts "____occasion_data: #{l.occasion_data}"
      l.save
    end
  end

end