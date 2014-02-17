class AddSentimentScoreToDataPoints < ActiveRecord::Migration
  def change
    add_column :data_points, :sentiment_score, :float
  end
end
