class CreateStyles < ActiveRecord::Migration
  def change

    drop_table :styles

    create_table :styles do |t|
      t.string :name
      t.text :description

      t.timestamps null: false
    end
  end
end
