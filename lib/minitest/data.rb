require "minitest/data/version"
require "minitest"

module Minitest
  module Data
    module Test
      class << self
        def prepended(klass)
          klass.extend(ClassMethods)
        end
      end

      module ClassMethods
        @@data = {}
        @@data_set = {}

        def data(*arguments, &block)
          case arguments.size
          when 0
            raise ArgumentError, "no block is given" unless block_given?
            data_set = block.call
          when 1
            data_set = arguments[0]
          when 2
            data_set = { arguments[0] => arguments[1] }
          else
            message = "wrong number arguments(#{arguments.size} for 1..2)"
            raise ArgumentError, message
          end

          @@data.merge!(data_set)
        end

        def method_added(name)
          unless @@data.empty?
            @@data_set[name] = @@data
            @@data = {}
          end
        end

        def data_set
          @@data_set
        end

        def data_exist?(method_name)
          @@data_set.key?(method_name)
        end

        def run_one_method(klass, method_name, reporter)
          if klass.data_exist?(method_name.to_sym)
            reporter.prerecord(klass, method_name)

            data = klass.data_set[method_name.to_sym]
            data.each do |label, value|
              reporter.record Minitest.run_one_method(klass, method_name, label, value)
            end
          else
            super
          end
        end
      end

      attr_accessor :data_label, :data_attribute

      def location
        label_string = ""
        label_string = "(#{self.data_label})" if self.data_label
        loc = " [#{self.failure.location}]" unless passed? or error?
        "#{self.class}##{self.name}#{label_string}#{loc}"
      end

      def run
        with_info_handler do
          time_it do
            capture_exceptions do
              before_setup; setup; after_setup

              if data_attribute
                self.send self.name, data_attribute
              else
                self.send self.name
              end
            end

            Minitest::Test::TEARDOWN_METHODS.each do |hook|
              capture_exceptions do
                self.send hook
              end
            end
          end
        end

        self
      end
    end


    class << self
      def prepended(klass)
        class << klass
          prepend ClassMethods
        end
      end
    end

    module ClassMethods
      def run_one_method(klass, method_name, label = nil, value = nil)
        if label
          test_klass = klass.new(method_name)
          test_klass.data_label = label
          test_klass.data_attribute = value

          result = test_klass.run
          raise "#{klass}#run _must_ return self" unless klass === result
          result
        else
          super(klass, method_name)
        end
      end
    end
  end
end

Minitest::Test.prepend(Minitest::Data::Test)
Minitest.prepend(Minitest::Data)
