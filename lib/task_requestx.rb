require "task_requestx/engine"

module TaskRequestx
  mattr_accessor :task_class, :show_task_path, :task_name_in_index, :task_name_in_edit
  
  def self.task_class
    @@task_class.constantize
  end
end
