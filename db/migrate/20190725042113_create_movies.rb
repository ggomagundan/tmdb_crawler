class CreateMovies < ActiveRecord::Migration[5.2]
  def change
    create_table :movies, id: false do |t|
      t.string :id, limit: 36, primary_key: true, null: false
      t.date :release_date      # release_date
      t.string :original_title  # original_title
      t.string :title           # title

      t.timestamps
    end
  end
end
