class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.string :url
      t.text :checks
      t.references :host

      t.timestamps null: false
    end
  end
end
