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

  describe 'split dmy methods' do
    describe 'handles pre-set dates' do
      describe 'passes them to the new accessors' do

        before(:each) { model.date_of_birth = '1991-1-21' }

        it 'sets the _day' do
          expect(model.date_of_birth_day).to eq 21
        end
      end
        describe 'allows clearing of preset data' do

        before(:each) { model.date_of_birth = '1991-1-21' }

        it 'by setting all values to nil' do
          model.date_of_birth_day = nil
          model.date_of_birth_month = nil
          model.date_of_birth_year = nil
          expect(model.date_of_birth).to be_nil
        end

        describe 'by setting' do
          it 'day to nil' do
            model.date_of_birth_day = nil
            expect(model.date_of_birth).to be_nil
          end
          it 'month to nil' do
            model.date_of_birth_month = nil
            expect(model.date_of_birth).to be_nil
          end
          it 'year to nil' do
            model.date_of_birth_year = nil
            expect(model.date_of_birth).to be_nil
          end
        end
      end
    end

    describe '_day' do
      describe 'when sent numbers' do
        describe 'between 1 and 31 is valid' do
          it 'sets the value' do
            (1..31).each do |i|
              model.date_of_birth_day = i
              expect(model.date_of_birth_day).to eq i
            end
          end
        end

        describe 'above accepted range' do
          it 'sets the value as nil' do
            model.date_of_birth_day = 32
            expect(model.date_of_birth_day).to be_nil
          end
        end

        describe 'below accepted range' do
          it 'sets the value as nil' do
            model.date_of_birth_day = 0
            expect(model.date_of_birth_day).to be_nil
          end
        end
      end

      describe 'when sent text' do
        it 'returns nil' do
          model.date_of_birth_day = 'first'
          expect(model.date_of_birth_day).to be_nil
        end
      end

      describe 'when sent nil' do
        it 'returns nil' do
          model.date_of_birth_day = nil
          expect(model.date_of_birth_day).to be_nil
        end
      end
    end

    describe '_month' do
      describe 'when sent numbers' do
        describe 'between 1 and 31 is valid' do
          it 'sets the value' do
            (1..12).each do |i|
              model.date_of_birth_month = i
              expect(model.date_of_birth_month).to eq i
            end
          end
        end

        describe 'above accepted range' do
          it 'sets the value as nil' do
            model.date_of_birth_month = 13
            expect(model.date_of_birth_month).to be_nil
          end
        end

        describe 'below accepted range' do
          it 'sets the value as nil' do
            model.date_of_birth_month = 0
            expect(model.date_of_birth_month).to be_nil
          end
        end
      end

      describe 'when sent text' do
        describe 'that is a valid long month' do
          I18n.t('date.month_names').each_with_index do |month, index|
            it "sending #{month} sets the month to #{month}" do
              model.date_of_birth_month = month
              expect(model.date_of_birth_month).to eq index unless month.nil?
            end
          end
        end
        describe 'that is a valid short month' do
          I18n.t('date.abbr_month_names').each_with_index do |month, index|
            it "sending #{month} sets the month to #{month}" do
              model.date_of_birth_month = month
              expect(model.date_of_birth_month).to eq index unless month.nil?
            end
          end
        end
        describe 'that is not a valid month' do
          it 'returns nil' do
            model.date_of_birth_day = 'first'
            expect(model.date_of_birth_day).to be_nil
          end
        end
      end

      describe 'when sent nil' do
        it 'returns nil' do
          model.date_of_birth_month = nil
          expect(model.date_of_birth_month).to be_nil
        end
      end
    end

    describe '_year' do
      describe 'when sent numbers' do
        describe 'numerically' do
          describe 'in the acceptable range' do
            it 'sets the value' do
              model.date_of_birth_year = 1961
              expect(model.date_of_birth_year).to eq 1961
            end
          end
          describe 'outside the acceptable range' do
            it 'returns nil' do
              model.date_of_birth_year = 3334
              expect(model.date_of_birth_year).to be_nil
            end
          end
        end
        describe 'as text' do
          it 'accepts and converts them' do
            model.date_of_birth_year = '1961'
            expect(model.date_of_birth_year).to eq '1961'
          end
        end
      end

      describe 'when sent text' do
        it 'returns nil' do
          model.date_of_birth_year = 'Nineteen Sixty One'
          expect(model.date_of_birth_year).to be_nil
        end
      end

      describe 'when sent nil' do
        it 'returns nil' do
          model.date_of_birth_year = nil
          expect(model.date_of_birth_year).to be_nil
        end
      end
    end

    describe 'set themselves but do not set date' do
      describe '#date_of_birth_day' do
        it 'can be set and returned' do
          model.date_of_birth_day = 1
          expect(model.date_of_birth_day).to eq 1
          expect(model.date_of_birth).to be nil
        end
      end

      describe '#date_of_birth_month' do
        it 'can be set and returned' do
          model.date_of_birth_month = 10
          expect(model.date_of_birth_month).to eq 10
          expect(model.date_of_birth).to be nil
        end
      end

      describe '#date_of_birth_year' do
        it 'can be set and returned' do
          model.date_of_birth_year = 10
          expect(model.date_of_birth_year).to eq 10
          expect(model.date_of_birth).to be nil
        end
      end
    end
    describe 'set the date field by calling validate_date' do
      context 'when all are completed' do
        before(:each) { model.date_of_birth = nil }

        it 'with year last' do
          model.date_of_birth_day = 21
          model.date_of_birth_month = 1
          model.date_of_birth_year = 1961
          expect(model.date_of_birth).to eql Date.new(1961, 1, 21)
        end

        it 'with month last' do
          model.date_of_birth_year = 1961
          model.date_of_birth_day = 21
          model.date_of_birth_month = 1
          expect(model.date_of_birth).to eql Date.new(1961, 1, 21)
        end

        it 'with day last' do
          model.date_of_birth_month = 1
          model.date_of_birth_year = 1961
          model.date_of_birth_day = 21
          expect(model.date_of_birth).to eql Date.new(1961, 1, 21)
        end
      end
    end
  end
end
