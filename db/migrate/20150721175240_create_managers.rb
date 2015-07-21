class CreateManagers < ActiveRecord::Migration
  def change
    create_table :managers do |t|
      t.date :date_of_birth

      t.timestamps null: false
    end
  end
end
