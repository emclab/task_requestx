# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task_requestx_request, :class => 'TaskRequestx::Request' do
    name "MyString"
    task_id 1
    request_date "2013-12-10"
    expedite false
    expected_finish_date "2013-12-10"
    request_content "MyText"
    need_delivery false
    what_to_deliver "MyText"
    delivery_instruction "MyText"
    requested_by_id 1
    last_updated_by_id 1
    completed false
    cancelled false
    request_status_id 1
  end
end
