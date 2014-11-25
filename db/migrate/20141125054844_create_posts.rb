class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :post_name
      t.text :post_description

      t.timestamps
    end
  end
end
