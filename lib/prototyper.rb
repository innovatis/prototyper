require File.dirname(__FILE__) + '/prototyper/scaffold'
require File.dirname(__FILE__) + '/prototyper/generators'
require 'ripl'
require 'ripl/multi_line'
require 'ripl/irb'
require 'active_support/all'
require 'sinatra/base'

module Prototyper

  class App < Sinatra::Base
    get '/' do
      "Hi."
    end 
  end 
  
  class Scaffold
   
    include Prototyper::Generators
    
    attr_accessor :model_name, :namespace, :attributes
    
    def initialize(hsh={})
      @model_name = nil
      @namespace  = []
      @attributes = []
      hsh.each do |k,v|
        instance_variable_set("@#{k}", v)
      end 
    end 
   
    def namespaced_constant_name
      (namespace + [model_name]).map(&:camelize).join("::").singularize
    end 
   
    def method_missing(s,*)
      s
    end 
    
    def table_name
      model_name.underscore.downcase.pluralize
    end 
    
    def w
      generate_controller
      generate_presenter
      generate_model
      generate_migration
      generate_routes
      generate_navigation
    end 
   
    def q
      Kernel.exit!(0)
    end 
    
    ###### Uber-convenient convenience methods #################
    module Convenience
      def n(name)
        @model_name = name.to_s
      end 
     
      def ns(ns)
        ns = ns.kind_of?(Array) ? ns : [ns]
        @namespace = ns
      end 
      
      def attribute(name, type, index=false)
        @attributes << Attribute.new(name, type, index)
      end 
      
      def string(name, index=false)
        @attributes << Attribute.new(name, :string, index)
      end 
   
      def integer(name, index=false)
        @attributes << Attribute.new(name, :integer, index)
      end 
   
      def boolean(name, index=false)
        @attributes << Attribute.new(name, :boolean, index)
      end 
   
      def text(name, index=false)
        @attributes << Attribute.new(name, :text, index)
      end 
   
      def decimal(name, index=false)
        @attributes << Attribute.new(name, :decimal, index)
      end 
   
      def double(name, index=false)
        @attributes << Attribute.new(name, :double, index)
      end 
   
    end 
    include Convenience
    
    class Attribute
      attr_accessor :name, :type, :index
      def initialize(name, type, index=false)
        @name  = name
        @type  = type
        @index = index
      end 
      def indexed?; !! index; end
    end 
  end
end 

