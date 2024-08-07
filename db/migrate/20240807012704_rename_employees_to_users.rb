class RenameEmployeesToUsers < ActiveRecord::Migration[7.1]
  def change
    rename_table :employees, :users
  end
end
