# This migration comes from template_taskx (originally 20131107015611)
class CreateTemplateTaskxTasks < ActiveRecord::Migration
  def change
    create_table :template_taskx_tasks do |t|
      t.integer :project_id
      t.text :brief_note
      t.integer :assigned_to_id
      t.boolean :cancelled, :default => false
      t.boolean :completed, :default => false
      t.boolean :expedite, :default => false
      t.boolean :skipped, :default => false
      t.date :finish_date
      t.date :start_date
      t.string :task_status_id
      t.integer :template_item_id
      t.integer :last_updated_by_id

      t.timestamps
    end
  end
end
