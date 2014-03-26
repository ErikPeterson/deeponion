class AddContentToPages < ActiveRecord::Migration
  def up
  	add_column :pages, :content, :text
  end
  def down
  	remove_column :pages, :content 
  end
end
