class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.date :posted

      t.timestamps null: false
    end
  end
end
