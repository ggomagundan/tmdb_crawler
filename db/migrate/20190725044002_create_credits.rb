class CreateCredits < ActiveRecord::Migration[5.2]
  def change
    create_table :credits, id: false do |t|
      t.string :id, limit: 36, primary_key: true, null: false
      t.string :character
      t.string :credit_id
      t.integer :video_id
      t.integer :people_id
      t.integer :gender
      t.string :job
      t.string :profile_url

      t.timestamps
    end

    add_index :credits, :video_id
  end
end
