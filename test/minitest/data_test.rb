require 'test_helper'

class Minitest::DataTest < Minitest::Test
  attr_accessor :reporter

  def run_test(test)
    output = StringIO.new("")

    self.reporter = Minitest::CompositeReporter.new
    reporter << Minitest::SummaryReporter.new(output)
    reporter << Minitest::ProgressReporter.new(output)

    reporter.start

    Minitest::Runnable.runnables.delete(test)
    test.run(reporter)
    reporter.report
  end

  def result_reporter
    reporter.reporters.first
  end

  def test_data_with_success
    test_case = Class.new(Minitest::Test) do
      data("empty string" => [true, ""],
           "plain string" => [false, "hello"])
      def test_empty(data)
        expected, target = data
        assert_equal(expected, target.empty?)
      end
    end

    run_test(test_case)

    assert_empty(result_reporter.results.first.to_s)
  end

  def test_data_with_fail
    test_case = Class.new(Minitest::Test) do
      data("empty string" => [true, "1"],
           "plain string" => [false, ""])
      def test_empty(data)
        expected, target = data
        assert_equal(expected, target.empty?)
      end
    end

    run_test(test_case)

    assert_match(/test_empty\(empty string\)/, result_reporter.results[0].to_s)
    assert_match(/test_empty\(plain string\)/, result_reporter.results[1].to_s)
  end


  def test_data_label_with_success
    test_case = Class.new(Minitest::Test) do
      data("empty string", [true, ""])
      data("plain string", [false, "hello"])
      def test_empty(data)
        expected, target = data
        assert_equal(expected, target.empty?)
      end
    end

    run_test(test_case)

    assert_empty(result_reporter.results.first.to_s)
  end

  def test_data_label_with_fail
    test_case = Class.new(Minitest::Test) do
      data("empty string", [true, "1"])
      data("plain string", [false, ""])
      def test_empty(data)
        expected, target = data
        assert_equal(expected, target.empty?)
      end
    end

    run_test(test_case)

    assert_match(/test_empty\(empty string\)/, result_reporter.results[0].to_s)
    assert_match(/test_empty\(plain string\)/, result_reporter.results[1].to_s)
  end

  def test_data_block_with_success
    test_case = Class.new(Minitest::Test) do
      data do
        data_set = {}
        data_set["empty string"] = [true, ""]
        data_set["plain string"] = [false, "hello"]
        data_set
      end
      def test_empty(data)
        expected, target = data
        assert_equal(expected, target.empty?)
      end
    end

    run_test(test_case)

    assert_empty(result_reporter.results.first.to_s)
  end

  def test_data_block_with_fail
    test_case = Class.new(Minitest::Test) do
      data do
        data_set = {}
        data_set["empty string"] = [true, "1"]
        data_set["plain string"] = [false, ""]
        data_set
      end
      def test_empty(data)
        expected, target = data
        assert_equal(expected, target.empty?)
      end
    end

    run_test(test_case)

    assert_match(/test_empty\(empty string\)/, result_reporter.results[0].to_s)
    assert_match(/test_empty\(plain string\)/, result_reporter.results[1].to_s)
  end
end
