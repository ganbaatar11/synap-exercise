class CreateEventLeagueJoins < ActiveRecord::Migration
  def change
    create_table :event_league_joins do |t|
      t.references :league, index: true, null: false
      t.references :event, index: true, null: false
    end
  end
end
