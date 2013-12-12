TaskRequestx.task_class = 'TemplateTaskx::Task'
TaskRequestx.show_task_path = "template_taskx.task_path(r.rask_id, :parent_record_id => r.task_id, :parent_resource => 'template_taskx/tasks')"
TaskRequestx.task_name_in_index = 'TemplateTaskx::Task.find_by_id(r.task_id).template_item.task_definition.name'
TaskRequestx.task_name_in_edit = '@task.template_item.task_definition.name'