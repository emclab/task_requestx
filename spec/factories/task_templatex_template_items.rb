# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task_templatex_template_item, :class => 'TaskTemplatex::TemplateItem' do
    template_id 1
    task_definition_id 1
    execution_order 1
    execution_sub_order 1
    start_before_previous_completed false
    brief_note "My brief note Text"
    need_request false
  end
end
