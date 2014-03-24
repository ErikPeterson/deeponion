class CreatePagesTable < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string  :href
      t.string  :title
      t.text  	:description
      t.integer :site_id
    end
  end
end
