class CreateReactions < ActiveRecord::Migration[6.1]
  def change
    create_table :reactions do |t|
      # カラム名変更
      t.references :from_user, null: false, foreign_key: {to_table: :users}
      t.references :to_user, null: false, foreign_key: {to_table: :users}
      t.integer :status, null: false
      t.timestamps
    end
  end
end
