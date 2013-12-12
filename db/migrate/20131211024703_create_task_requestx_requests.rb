class CreateTaskRequestxRequests < ActiveRecord::Migration
  def change
    create_table :task_requestx_requests do |t|
      t.string :name
      t.integer :task_id
      t.date :request_date
      t.boolean :expedite, :default => false
      t.date :expected_finish_date
      t.text :request_content
      t.boolean :need_delivery, :default => false
      t.text :what_to_deliver
      t.text :delivery_instruction
      t.integer :requested_by_id
      t.integer :last_updated_by_id
      t.boolean :completed, :default => false
      t.boolean :cancelled, :default => false
      t.integer :request_status_id

      t.timestamps
    end
    
    add_index :task_requestx_requests, :task_id
    add_index :task_requestx_requests, :name
    add_index :task_requestx_requests, :requested_by_id
    add_index :task_requestx_requests, :expedite
    add_index :task_requestx_requests, :cancelled
    add_index :task_requestx_requests, :completed
    add_index :task_requestx_requests, :request_status_id
  end
end
