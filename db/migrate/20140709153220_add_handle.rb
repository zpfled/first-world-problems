class AddHandle < ActiveRecord::Migration
  def change
    add_column :tweets, :handle, :string, default: ""
  end
end
