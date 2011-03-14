module Prototyper
  
  module Generators
    def path_for(component)
      path = ['app', component, namespace].flatten.map(&:underscore).join("/")
      `mkdir -p '#{path}'`
      path
    end 
    def generate_controller
      path = path_for('controllers')
      puts ">> Writing Controller into #{path}"
      File.open("#{path}/#{model_name.underscore.pluralize}_controller.rb", "w") do |f|
        f.puts <<-CODE
class #{namespaced_constant_name.pluralize}Controller < DashboardController
  inherit_resources
  present_with #{namespaced_constant_name.pluralize}Presenter
end
        CODE
      end 
    end 
    def generate_presenter
      path = path_for('presenters')
      puts ">> Writing Presenter into #{path}"
      File.open("#{path}/#{model_name.underscore.pluralize}_presenter.rb", "w") do |f|
        f.puts <<-CODE
class #{namespaced_constant_name.pluralize}Presenter < InnoPresenter::CorePresenter
  # def items
  
  # def columns
  
  # def filters
end
        CODE
      end 
    end 
    def generate_model
      path = path_for('models')
      puts ">> Writing Model into #{path}"
      File.open("#{path}/#{model_name.underscore.singularize}.rb", "w") do |f|
        f.puts <<-CODE
class #{namespaced_constant_name} < ActiveRecord::Base

end
        CODE
      end 
    end 
    def generate_migration
      puts ">> Writing Migration"
      columns = attributes.map do |a|
        "      t.#{a.type} :#{a.name}"
      end.join("\n")
      indices = attributes.select(&:indexed?).map do |a|
        "    add_index :#{model_name.underscore.pluralize}, :#{a.name}"
      end.join("\n")
      
      File.open("db/migrate/#{Time.now.strftime("%Y%m%d%H%M%S")}_prototype_#{table_name}.rb", "w") do |f|
        f.puts <<-CODE
class Prototype#{model_name.camelize.pluralize} < ActiveRecord::Migration
  def self.up
    create_table :#{table_name} do |t|
#{columns}    
      t.timestamps
    end 
#{indices}
  end

  def self.down
    drop_table :#{table_name}
  end
end
        CODE
      end 
    end 

    def generate_navigation
      puts ">> Writing Dashboard Nav"
      c = '    %li= link_to \'#{table_name.titleize}\', #{table_name}_url, :class => "exo-button #{current_if_path(/#{table_name}/)}"'
      File.open('app/views/dashboard/_menu.html.haml', 'a') { |f| f.puts c }
    end 

    def generate_routes
      if namespace.any?
        puts ">> SET UP THE ROUTES YOURSELF."
        return
      end 
      puts ">> Writing Routes"

      content = ["resources :#{table_name}\n"] 
      
      routefile = File.readlines("config/routes.rb")
      newfile = routefile[0..0] + content + routefile[1..-1]

      File.open("config/routes.rb", "w") do |f|
        f.puts newfile.join
      end
    end 
  end
end 
