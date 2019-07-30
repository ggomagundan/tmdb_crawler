class CreateTvEpisodes < ActiveRecord::Migration[5.2]
  def change
    create_table :tv_episodes, id: false do |t|
      t.string :id, limit: 36, primary_key: true, null: false
      t.string :name
      t.string :tv_show_id
      t.integer :episode_id
      t.date :air_date
      t.integer :episode_number
      t.integer :season_number
      t.string :image_url

      t.timestamps
    end

    add_index :tv_episodes, :tv_show_id
  end
end
