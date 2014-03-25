class CreateSitesTable < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string  :host_name
    end
  end
end
