class CreateDataPoints < ActiveRecord::Migration
  def change
    create_table :data_points do |t|
      t.string :text
      t.integer :tweet_id
      t.string :time_posted
      t.string :twitter_user_name
      t.integer :twitter_user_id
      t.string :target
      t.integer :mood_metric_id

      t.timestamps
    end
  end
end
