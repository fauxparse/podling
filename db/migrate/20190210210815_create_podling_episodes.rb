class CreatePodlingEpisodes < ActiveRecord::Migration[5.2]
  def change
    create_table :podling_episodes do |t|
      t.string :title
      t.text :description
      t.integer :duration
      t.timestamp :published_at
      t.timestamp :deleted_at

      t.timestamps
    end
  end
end
