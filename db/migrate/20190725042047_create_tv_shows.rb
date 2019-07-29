class CreateTvShows < ActiveRecord::Migration[5.2]
  def change
    create_table :tv_shows, id: false do |t|
      t.string :id, limit: 36, primary_key: true, null: false
      t.date :first_air_date # first_air_date
      t.string :original_name # original_name
      t.string :name          # name

      t.timestamps
    end
  end
end
