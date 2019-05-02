class UpdateUserAgain < ActiveRecord::Migration[5.2]
  def change
    remove_index :users, :password_digest
  end
end
