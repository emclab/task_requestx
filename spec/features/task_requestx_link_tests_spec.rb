require 'spec_helper'

describe "LinkTests" do
  describe "GET /task_requestx_link_tests" do
    mini_btn = 'btn btn-mini '
    ActionView::CompiledTemplates::BUTTONS_CLS =
        {'default' => 'btn',
         'mini-default' => mini_btn + 'btn',
         'action'       => 'btn btn-primary',
         'mini-action'  => mini_btn + 'btn btn-primary',
         'info'         => 'btn btn-info',
         'mini-info'    => mini_btn + 'btn btn-info',
         'success'      => 'btn btn-success',
         'mini-success' => mini_btn + 'btn btn-success',
         'warning'      => 'btn btn-warning',
         'mini-warning' => mini_btn + 'btn btn-warning',
         'danger'       => 'btn btn-danger',
         'mini-danger'  => mini_btn + 'btn btn-danger',
         'inverse'      => 'btn btn-inverse',
         'mini-inverse' => mini_btn + 'btn btn-inverse',
         'link'         => 'btn btn-link',
         'mini-link'    => mini_btn +  'btn btn-link'
        }
    before(:each) do
      @project_num_time_gen = FactoryGirl.create(:engine_config, :engine_name => 'fixed_task_projectx', :engine_version => nil, :argument_name => 'project_num_time_gen', :argument_value => ' FixedTaskProjectx::Project.last.nil? ? (Time.now.strftime("%Y%m%d") + "-"  + 112233.to_s + "-" + rand(100..999).to_s) :  (Time.now.strftime("%Y%m%d") + "-"  + (FixedTaskProjectx::Project.last.project_num.split("-")[-2].to_i + 555).to_s + "-" + rand(100..999).to_s)')
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      @payment_terms_config = FactoryGirl.create(:engine_config, :engine_name => 'fixed_task_projectx', :engine_version => nil, :argument_name => 'task_index_view', 
                              :argument_value => Authentify::AuthentifyUtility.find_config_const('task_index_view', 'fixed_task_projectx')) 
      @payment_terms_config = FactoryGirl.create(:engine_config, :engine_name => 'fixed_task_projectx', :engine_version => nil, :argument_name => 'task_show_view', 
                              :argument_value => Authentify::AuthentifyUtility.find_config_const('task_show_view', 'fixed_task_projectx')) 
      
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      @proj_type = FactoryGirl.create(:simple_typex_type)
      @proj_type1 = FactoryGirl.create(:simple_typex_type, :name => 'newnew')
      @tt = FactoryGirl.create(:task_templatex_template, :active => true, :last_updated_by_id => @u.id, :type_id => @proj_type.id)
      @tt1 = FactoryGirl.create(:task_templatex_template, :name => 'a new name', :active => true, :last_updated_by_id => @u.id, :type_id => @proj_type1.id)
      @task_def = FactoryGirl.create(:commonx_misc_definition, :for_which => 'task_definition', :active => true)
      @task_def1 = FactoryGirl.create(:commonx_misc_definition, :name => 'a new task name', :for_which => 'task_definition', :active => true)
      @cust = FactoryGirl.create(:kustomerx_customer)
      @proj = FactoryGirl.create(:fixed_task_projectx_project, :task_template_id => @tt.id, :customer_id => @cust.id)
      @proj1 = FactoryGirl.create(:fixed_task_projectx_project, :task_template_id => @tt1.id, :name => 'a new name', :project_num => 'something new', :customer_id => @cust.id)
      @item = FactoryGirl.create(:task_templatex_template_item, :template_id => @tt.id, :task_definition_id => @task_def.id)
      @item1 = FactoryGirl.create(:task_templatex_template_item, :template_id => @tt1.id, :task_definition_id => @task_def1.id)
      @task_status = FactoryGirl.create(:commonx_misc_definition, :for_which => 'task_status', :active => true)
      @task = FactoryGirl.create(:template_taskx_task, :project_id => @proj.id, :template_item_id => @tt.id)
      @task1 = FactoryGirl.create(:template_taskx_task, :project_id => @proj1.id, :template_item_id => @tt1.id)
      
      ua1 = FactoryGirl.create(:user_access, :action => 'index', :resource => 'task_requestx_requests', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "TaskRequestx::Request.where(:cancelled => false).order('created_at')")
      ua1 = FactoryGirl.create(:user_access, :action => 'create', :resource => 'task_requestx_requests', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      ua1 = FactoryGirl.create(:user_access, :action => 'update', :resource => 'task_requestx_requests', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'show', :resource =>'task_requestx_requests', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      ua41 = FactoryGirl.create(:user_access, :action => 'create_task_definition', :resource => 'commonx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
                                :sql_code => "")  
      ua41 = FactoryGirl.create(:user_access, :action => 'create_task_status', :resource => 'commonx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
                                :sql_code => "") 
      ua41 = FactoryGirl.create(:user_access, :action => 'index_task_status', :resource => 'commonx_misc_definitions', :role_definition_id => @role.id, :rank => 1,
                                :sql_code => "Commonx::MiscDefinition.where(:for_which => 'task_status')")   
      ua41 = FactoryGirl.create(:user_access, :action => 'create_task_request', :resource => 'commonx_logs', :role_definition_id => @role.id, :rank => 1,
                                :sql_code => "")
                                                          
      visit '/'
      #save_and_open_page
      fill_in "login", :with => @u.login
      fill_in "password", :with => 'password'
      click_button 'Login' 
    end
    it "works! (now write some real specs)" do
      qs = FactoryGirl.create(:task_requestx_request, :last_updated_by_id => @u.id, :task_id => @task.id, :request_status_id => @task_status.id)
      visit requests_path(:task_id => @task.id)
      save_and_open_page
      page.should have_content('Task Requests')
      click_link 'New Task Request'
      save_and_open_page
      page.should have_content('New Task Request')
      visit requests_path
      click_link qs.id.to_s
      page.should have_content('Task Request Info')
      click_link 'New Log'
      page.should have_content('Log')
      #save_and_open_page
      visit requests_path(:task_id => @task.id)      
      click_link 'Edit'
      #save_and_open_page
      page.should have_content('Edit Task Request')
    end
  end
end
