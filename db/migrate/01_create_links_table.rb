class CreateLinksTable < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string  :href
      t.string  :found_on
      t.string  :full_path
      t.text    :content
      t.integer :page_id
    end
  end
end
