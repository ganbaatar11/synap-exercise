class AddLeagueToPeople < ActiveRecord::Migration
  def change
    add_column :people, :league_id, :integer
  end
end
