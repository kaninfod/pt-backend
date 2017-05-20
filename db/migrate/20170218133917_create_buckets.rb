class CreateBuckets < ActiveRecord::Migration[5.0]
  def change
    create_table :buckets do |t|
      t.integer :user
      t.integer :photo_id

      t.timestamps
    end
  end
end
