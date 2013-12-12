# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :template_taskx_task, :class => 'TemplateTaskx::Task' do
    project_id 1
    brief_note "MyText"
    assigned_to_id 1
    cancelled false
    completed false
    expedite false
    skipped false
    finish_date "2013-11-06"
    start_date "2013-11-06"
    task_status_id "My status String"
    template_item_id 1
    last_updated_by_id 1
  end
end
