class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :follower_id
      t.integer :author_id

      t.timestamps
    end
    
    add_index :subscriptions, :follower_id
    add_index :subscriptions, :author_id
    add_index :subscriptions, [:follower_id, :author_id], unique: true
  end
end
