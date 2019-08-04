# frozen_string_literal: true

class OptimalDiscountCalculator
  attr_reader :license_set

  SERVICE_PRICE = 8.to_f

  DISCOUNTS_MAP = {
    1 => 0, 2 => 5, 3 => 10, 4 => 15, 5 => 25, 6 => 30, 7 => 35
  }.freeze

  # License structure
  License = Struct.new(:name, :quantity)

  # Combination results
  Result = Struct.new(:license_set, :set_discount, :license_discount,
                      :license_price, :final_set_price)

  def initialize(_license_set)
    @license_set = [License.new('Service One', 1),
                    License.new('Service Two', 2),
                    License.new('Service Three', 2),
                    License.new('Service Four', 2),
                    License.new('Service Five', 2),
                    License.new('Service Six', 1)]

    raise ArgumentError, 'Empty license set' if @license_set.nil? || @license_set.empty?
  end

  def calculate
    results =
      combinations.map do |combination|
        set_discount = DISCOUNTS_MAP[combination.length].to_f
        license_discount = set_discount * SERVICE_PRICE / 100
        license_price = SERVICE_PRICE - license_discount
        Result.new(combination.map(&:name).join(', '), set_discount,
                   license_discount, license_price,
                   license_count * license_price)
      end
    results.min_by(&:final_set_price)
  end

  # Returns all possible license combinations
  def combinations
    @combinations ||= begin
      comb = []
      (2..(license_set.length)).each do |num|
        comb += license_set.combination(num).to_a
      end
      comb
    end
  end

  # Returns a hashmap grouped by license quantity
  # e.g:
  #
  # {
  #   1 => %i[service_one service_six],
  #   2 => %i[service_two service_three service_four service_five]
  # }
  def group_by_quantity
    @group_by_quantity ||= license_set.keys.group_by { |key| license_set[key] }
  end

  def license_count
    license_set.map(&:quantity).inject(:+)
  end
end
