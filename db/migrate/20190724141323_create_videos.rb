class CreateVideos < ActiveRecord::Migration[5.2]
  def change
    create_table :videos, id: false do |t|
      t.string :id, limit: 36, primary_key: true, null: false
      t.integer :video_id      # id
      t.string :media_type    # media_type & for polymorphic type
      t.string :media_id      ## for polymorphic
      t.string :image_url     # poster_path
      t.text :overview        # overview
      t.timestamps
    end
  end
end
