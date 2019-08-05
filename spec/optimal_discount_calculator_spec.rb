# frozen_string_literal: true

require './optimal_discount_calculator.rb'

describe 'calculator' do
  it 'gets the best discount' do
    license_set = [OptimalDiscountCalculator::License.new('Service One', 1),
                   OptimalDiscountCalculator::License.new('Service Two', 2),
                   OptimalDiscountCalculator::License.new('Service Three', 2),
                   OptimalDiscountCalculator::License.new('Service Four', 2),
                   OptimalDiscountCalculator::License.new('Service Five', 2),
                   OptimalDiscountCalculator::License.new('Service Six', 1)]
    calc = OptimalDiscountCalculator.new(license_set)
    result = calc.calculate
    expect(result.final_set_price).to eql(56.0)
    expect(result.set_discount).to eql(30.0)
  end
end
