require 'rails_helper'
require_relative '../../spec/support/matchers/accessors_shared'

RSpec.describe Manager, type: :model do

  let(:model) { Manager.new }

  it 'has a date of birth field to extend' do
    expect(model).to respond_to :date_of_birth
  end

  it 'responds to date_of_birth' do
    expect(model).to have_attr_accessor :date_of_birth
  end

  ['date_of_birth_day', 'date_of_birth_month', 'date_of_birth_year'].each do |attr|
    describe 'responds to' do
      it "##{attr}" do
        expect(model).to have_attr_accessor(attr)
      end
    end
  end

  it 'allows setting of dob_day' do
    model.date_of_birth_day = 45
    expect(model.date_of_birth_day).to eq 45
  end

  it 'blah' do
    model.date_of_birth_day = '4'
    model.date_of_birth_month = '9'
    model.date_of_birth_year = 1975
    expect(model.date_of_birth).to eq Date.new(1975, 9, 4)
  end
end