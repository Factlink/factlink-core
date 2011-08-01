class Seeder

  # Exports the current database to a custom seed file

  attr_accessor :dump_dir

  def initialize
    dir = "db/init"

    self.dump_dir = File.expand_path("#{Rails.root}/" + "#{dir}/")
    
    unless Dir.exist?(self.dump_dir)
      Dir.mkdir(self.dump_dir)
    end
    
  end
  
  def export_to_file(file_name)
    
    file = get_file(file_name)
    
    if File.exists?(file)
      puts "File #{file_name} already exists. Please choose another file name."
      return nil
    else
      puts "opening file: #{file}"
      # Dump the exports to the file
      File.open(file, 'w') do |f|
        [Fact, FactRelation].each do |klass|
          klass.all.each do |obj|
            f.write obj.export
          end
        end
      end
      
      puts "Done writing file #{file_name}.\n\n"      
    end
  end

  def get_file(file)
    # file is frozen string, can't be modified: so duplicate
    file_name = file.dup
    
    unless File.extname(file_name) == ".rb"
      file_name << ".rb"
    end
    
    return File.join(self.dump_dir, file_name)
  end

  def help    
    puts "# Factlink Database Seeder #\n\n"
    puts "The following commands are available:\n\n"
    puts "rake db:seed\t\t\t# Seeds the regular database"
    puts "rake db:export file=filename\t# Exports the current database to the file filename found in db/dumps/"
    puts "rake db:import file=filename\t# Import the dump to the database"
    puts "rake db:clean\t\t\t# Truncates the database"
    puts "rake db:help\t\t\t# Show this help file\n\n"
  end

end