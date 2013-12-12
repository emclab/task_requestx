require_dependency "task_requestx/application_controller"

module TaskRequestx
  class RequestsController < ApplicationController
    before_filter :require_employee
    before_filter :load_parent_record
    
    def index
      @title = t('Task Requests')      
      @requests = params[:task_requestx_requests][:model_ar_r]
      @requests = @requests.where(:task_id => params[:task_id]) if @task
      @requests = @requests.page(params[:page]).per_page(@max_pagination)
      @erb_code = find_config_const('request_index_view', 'task_requestx')
    end
  
    def new
      @title = t('New Task Request')
      @request = TaskRequestx::Request.new
    end
  
    def create
      @request = TaskRequestx::Request.new(params[:request], :as => :role_new)
      @request.last_updated_by_id = session[:user_id]
      @request.requested_by_id = session[:user_id]
      if @request.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        flash.now[:error] = t('Data Error. Not Saved!')
        render 'new'
      end
    end
  
    def edit
      @title = t('Edit Task Request')
      @request = TaskRequestx::Request.find_by_id(params[:id])
    end
  
    def update
      @request = TaskRequestx::Request.find_by_id(params[:id])
      @request.last_updated_by_id = session[:user_id]
      if @request.update_attributes(params[:request], :as => :role_update)
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      else
        flash.now[:error] = t('Data Error. Not Updated!')
        render 'edit'
      end
    end
  
    def show
      @title = t('Task Request Info')
      @request = TaskRequestx::Request.find_by_id(params[:id])
      @erb_code = find_config_const('request_show_view', 'task_requestx')
    end
    
    protected
    def load_parent_record
      @task = TaskRequestx.task_class.find_by_id(params[:task_id]) if params[:task_id].present? && params[:task_id].to_i > 0
      @request = TaskRequestx::Request.find_by_id(params[:id]) if params[:id].present?
      @task = TaskRequestx.task_class.find_by_id(TaskRequestx::Request.find_by_id(params[:id]).task_id) if params[:id].present?
    end
  end
end
