class AddAdminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin, :bollean
  end
end
