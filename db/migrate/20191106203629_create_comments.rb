class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.integer :photo_id
      t.text :body
      t.integer :author_id

      t.timestamps
    end
  end
end
