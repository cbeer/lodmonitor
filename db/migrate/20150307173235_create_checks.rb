class CreateChecks < ActiveRecord::Migration
  def change
    create_table :checks do |t|
      t.string :type
      t.references :resource
      t.integer :status
      t.text :data
      t.text :content

      t.timestamps null: false
    end
  end
end
