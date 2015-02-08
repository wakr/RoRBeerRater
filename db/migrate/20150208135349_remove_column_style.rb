class RemoveColumnStyle < ActiveRecord::Migration
  def self.up
    remove_column :beers, :style
  end
end
