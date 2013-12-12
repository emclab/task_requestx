module TaskRequestx
  class Request < ActiveRecord::Base
    attr_accessor :task_name, :requested_by_name, :cancelled_noupdate, :completed_noupdate, :expedite_noupdate, :need_delivery_noupdate
    attr_accessible :name, :request_content, :request_date, :requested_by_id, :delivery_instruction, :expected_finish_date, :expedite, 
                    :last_updated_by_id, :need_delivery, :task_id, :what_to_deliver, :cancelled, :completed, :request_status_id, 
                    :task_name, :requested_by_name,
                    :as => :role_new
    attr_accessible :name, :request_content, :request_date, :requested_by_id, :delivery_instruction, :expected_finish_date, :expedite, 
                    :last_updated_by_id, :need_delivery, :task_id, :what_to_deliver, :cancelled, :completed, :request_status_id, 
                    :task_name, :requested_by_name, :cancelled_noupdate, :completed_noupdate, :expedite_noupdate, :need_delivery_noupdate,
                    :as => :role_update                    
    belongs_to :task, :class_name => TaskRequestx.task_class.to_s
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :requested_by, :class_name => 'Authentify::User'
    belongs_to :request_status, :class_name => 'Commonx::MiscDefinition'

    
    validates_presence_of :request_date, :expected_finish_date
    validates :request_content, :presence => true
    validates :task_id, :request_status_id, :presence => true,
                        :numericality => {:greater_than => 0}
    validates :name, :presence => true,
                     :uniqueness => {:scope => :task_id, :case_sensitive => false, :message => I18n.t('Duplicate Name!')}
  end
end
