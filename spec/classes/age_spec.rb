require 'rails_helper'

describe Age do
  let(:date_said)            { Date.new(2016, 5, 14).strftime("%Y-%m-%d") }
  let(:born_one_year_ago)    { Date.new(2015, 5, 14) }
  let(:born_three_years_ago) { Date.new(2013, 5, 14) }
  let(:born_ten_years_ago)   { Date.new(2006, 5, 14) }

  describe "##calculate" do
    it "returns the age in months when kid is less than 2 years old" do
      results = Age.new(born_one_year_ago, date_said).calculate

      expect(results).to eq '12 months old'
    end

    it "returns the age in years and months when kid is 2 - 9 years old" do
      results = Age.new(born_three_years_ago, date_said).calculate

      expect(results).to eq '3 years 0 months old'
    end

    it "returns the age in years when kid is greater than 9 years old" do
      results = Age.new(born_ten_years_ago, date_said).calculate

      expect(results).to eq '10 years old'
    end
  end
end
