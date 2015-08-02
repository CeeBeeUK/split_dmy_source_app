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

      context 'when object created with date' do
        let(:model) { Manager.new(date_of_birth: Date.new(1992, 1, 21)) }

        it 'sets the date' do
          expect(model.date_of_birth).to eq Date.new(1992, 1, 21)
        end

        describe 'splits the partials' do
          it 'sets the day' do
            expect(model.date_of_birth_day).to eq 21
          end

          it 'sets the month' do
            expect(model.date_of_birth_month).to eq 1
          end

          it 'sets the year' do
            expect(model.date_of_birth_year).to eq 1992
          end
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
          before do
            model.date_of_birth_day = 32
            model.valid?
          end

          it 'sets the value' do
            expect(model.date_of_birth_day).to eq 32
          end

          it 'adds an error message' do
            expect(model.errors[:date_of_birth_day]).to eq ['is not a valid day']
          end
        end

        describe 'below accepted range' do
          before { model.date_of_birth_day = 0 }

          it 'sets the value' do
            expect(model.date_of_birth_day).to eq 0
          end

          it 'makes the model invalid' do
            expect(model).to be_invalid
          end
        end
      end

      describe 'when sent text' do
        before { model.date_of_birth_day = 'first' }

        it 'returns nil' do
          expect(model.date_of_birth_day).to eq 'first'
        end

        it 'makes the model invalid' do
          expect(model).to be_invalid
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
          before { model.date_of_birth_month = 13 }

          it 'sets the value' do
            expect(model.date_of_birth_month).to eq 13
          end

          it 'makes the model invalid' do
            expect(model).to be_invalid
          end
        end

        describe 'below accepted range' do
          before { model.date_of_birth_month = 0 }

          it 'sets the value' do
            expect(model.date_of_birth_month).to eq 0
          end

          it 'makes the model invalid' do
            expect(model).to be_invalid
          end
        end
      end

      describe 'when sent text' do
        describe 'that is a valid long month' do
          I18n.t('date.month_names').each_with_index do |month, _index|
            it "sending #{month} sets the month to #{month}" do
              model.date_of_birth_month = month
              expect(model.date_of_birth_month).to eq month unless month.nil?
            end
          end
        end
        describe 'that is a valid short month' do
          I18n.t('date.abbr_month_names').each_with_index do |month, _index|
            it "sending #{month} sets the month to #{month}" do
              model.date_of_birth_month = month
              expect(model.date_of_birth_month).to eq month unless month.nil?
            end
          end
        end
        describe 'that is not a valid month' do
          before {model.date_of_birth_month = 'first' }

          it 'returns the text' do
            expect(model.date_of_birth_month).to eq 'first'
          end

          it 'makes the model invalid' do
            expect(model).to be_invalid
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
            before { model.date_of_birth_year = 3334 }
            it 'returns nil' do
              expect(model.date_of_birth_year).to be 3334
            end

            it 'makes the model invalid' do
              expect(model).to be_invalid
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
        before { model.date_of_birth_year = 'Nineteen Sixty One' }

        it 'sets the value' do
          expect(model.date_of_birth_year).to eq 'Nineteen Sixty One'
        end

        it 'makes the model invalid' do
          expect(model).to be_invalid
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
