class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string      :full_text
      t.float       :latitude
      t.float       :longitude
      t.datetime    :tweeted_on
      t.timestamps
    end
  end
end
