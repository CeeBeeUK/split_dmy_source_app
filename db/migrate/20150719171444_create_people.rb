class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.date :date_of_birth

      t.timestamps null: false
    end
  end
end
