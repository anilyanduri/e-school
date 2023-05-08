class CreateEnrollments < ActiveRecord::Migration[7.0]
  def change
    create_table :enrollments do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :batch, null: false, foreign_key: true
      t.integer :status
      t.integer :progress

      t.timestamps
    end
  end
end
