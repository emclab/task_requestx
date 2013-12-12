require 'spec_helper'

module TaskRequestx
  describe RequestsController do
    before(:each) do
      controller.should_receive(:require_signin)
      @project_num_time_gen = FactoryGirl.create(:engine_config, :engine_name => 'fixed_task_projectx', :engine_version => nil, :argument_name => 'project_num_time_gen', :argument_value => ' FixedTaskProjectx::Project.last.nil? ? (Time.now.strftime("%Y%m%d") + "-"  + 112233.to_s + "-" + rand(100..999).to_s) :  (Time.now.strftime("%Y%m%d") + "-"  + (FixedTaskProjectx::Project.last.project_num.split("-")[-2].to_i + 555).to_s + "-" + rand(100..999).to_s)')
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
    end
    
    render_views
    before(:each) do
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
      #@task_status = FactoryGirl.create(:commonx_misc_definition, :for_which => 'task_status')
      @task = FactoryGirl.create(:template_taskx_task, :project_id => @proj.id, :template_item_id => @tt.id)
      @task1 = FactoryGirl.create(:template_taskx_task, :project_id => @proj1.id, :template_item_id => @tt1.id)
    end
      
    describe "GET 'index'" do
      
      it "returns all task reqeusts" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'task_requestx_requests', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "TaskRequestx::Request.order('request_date DESC')")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        status = FactoryGirl.create(:commonx_misc_definition, :for_which => 'task_status')
        qs = FactoryGirl.create(:task_requestx_request, :last_updated_by_id => @u.id, :task_id => @task.id, :request_status_id => status.id)
        qs1 = FactoryGirl.create(:task_requestx_request, :last_updated_by_id => @u.id, :task_id => @task1.id, :request_status_id => status.id, :name => 'newname')
        get 'index' , {:use_route => :task_requestx}
        assigns(:requests).should =~ [qs,qs1] 
      end
      
      it "should only return request for the task" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'task_requestx_requests', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "TaskRequestx::Request.order('request_date DESC')")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        status = FactoryGirl.create(:commonx_misc_definition, :for_which => 'task_status')
        qs = FactoryGirl.create(:task_requestx_request, :last_updated_by_id => @u.id, :task_id => @task.id, :request_status_id => status.id)
        qs1 = FactoryGirl.create(:task_requestx_request, :last_updated_by_id => @u.id, :task_id => @task1.id, :request_status_id => status.id, :name => 'new name')
        get 'index' , {:use_route => :task_requestx, :task_id => @task1.id}
        assigns(:requests).should eq([qs1]) 
      end
      
      it "should redirect for no right" do
        user_access = FactoryGirl.create(:user_access, :action => 'no-index', :resource => 'task_requestx_requests', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "TaskRequestx::Request.order('request_date DESC')")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        status = FactoryGirl.create(:commonx_misc_definition, :for_which => 'task_status')
        qs = FactoryGirl.create(:task_requestx_request, :last_updated_by_id => @u.id, :task_id => @task.id, :request_status_id => status.id)
        qs1 = FactoryGirl.create(:task_requestx_request, :last_updated_by_id => @u.id, :task_id => @task1.id, :request_status_id => status.id, :name => 'new name')
        get 'index' , {:use_route => :task_requestx, :task_id => @task1.id}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right! for action=index and resource=task_requestx/requests")
      end
    end
  
    describe "GET 'new'" do
      it "should be success" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'task_requestx_requests', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        status = FactoryGirl.create(:commonx_misc_definition, :for_which => 'task_status')
        get 'new' , {:use_route => :task_requestx, :task_id => @task1.id}
        response.should be_success
      end
      
      it "should redirect if no right" do
        user_access = FactoryGirl.create(:user_access, :action => 'no-create', :resource => 'task_requestx_requests', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        status = FactoryGirl.create(:commonx_misc_definition, :for_which => 'task_status')
        get 'new' , {:use_route => :task_requestx, :task_id => @task.id}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Access Right! for action=new and resource=task_requestx/requests")
      end
    end
  
    describe "GET 'create'" do
      it "create successfully" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'task_requestx_requests', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        status = FactoryGirl.create(:commonx_misc_definition, :for_which => 'task_status')
        qs = FactoryGirl.attributes_for(:task_requestx_request, :last_updated_by_id => @u.id,  :request_status_id => status.id)
        get 'create' , {:use_route => :task_requestx, :request => qs, :task_id => @task1.id}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!") 
      end
      
      it "should render 'new' for data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'task_requestx_requests', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        status = FactoryGirl.create(:commonx_misc_definition, :for_which => 'task_status')
        qs = FactoryGirl.attributes_for(:task_requestx_request, :last_updated_by_id => @u.id,  :request_status_id => status.id, :name => nil)
        get 'create' , {:use_route => :task_requestx, :request => qs, :task_id => @task1.id}
        response.should render_template("new")
      end
    end
  
    describe "GET 'edit'" do
      it "returns success" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'task_requestx_requests', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        status = FactoryGirl.create(:commonx_misc_definition, :for_which => 'task_status')
        qs = FactoryGirl.create(:task_requestx_request, :last_updated_by_id => @u.id,  :request_status_id => status.id)
        get 'edit' , {:use_route => :task_requestx, :task_id => @task1.id, :id => qs.id}
        response.should be_success
      end
    end
  
    describe "GET 'update'" do
      it "should update" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'task_requestx_requests', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        status = FactoryGirl.create(:commonx_misc_definition, :for_which => 'task_status')
        qs = FactoryGirl.create(:task_requestx_request, :last_updated_by_id => @u.id,  :request_status_id => status.id)
        get 'update' , {:use_route => :task_requestx, :id => qs.id, :task_id => @task1.id, :request => {:name => 'new new'}}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!") 
      end
      
      it "should render 'edit' for data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'task_requestx_requests', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        status = FactoryGirl.create(:commonx_misc_definition, :for_which => 'task_status')
        qs = FactoryGirl.create(:task_requestx_request, :last_updated_by_id => @u.id,  :request_status_id => status.id)
        get 'update' , {:use_route => :task_requestx, :id => qs.id, :task_id => @task1.id, :request => {:name => ''}}
        response.should render_template("edit")
      end
    end
  
    describe "GET 'show'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'show', :resource => 'task_requestx_requests', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:employee] = true
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        status = FactoryGirl.create(:commonx_misc_definition, :for_which => 'task_status')
        qs = FactoryGirl.create(:task_requestx_request, :last_updated_by_id => @u.id,  :request_status_id => status.id)
        get 'show' , {:use_route => :task_requestx, :id => qs.id, :task_id => @task1.id}
        response.should
      end
    end
  
  end
end
