class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people, id: false do |t|
      t.string :id, limit: 36, primary_key: true, null: false
      t.integer :tmdb_people_id
      t.string :name
      t.integer :gender
      t.string :profile_url

      t.timestamps
    end
  end
end
