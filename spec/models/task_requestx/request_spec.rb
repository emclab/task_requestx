require 'spec_helper'

module TaskRequestx
  describe Request do
    it "should be OK" do
      c = FactoryGirl.build(:task_requestx_request)
      c.should be_valid
    end
    
    it "should reject nil request_date" do
      c = FactoryGirl.build(:task_requestx_request, :request_date => nil)
      c.should_not be_valid
    end
    
    it "should reject nil expected_finish_date" do
      c = FactoryGirl.build(:task_requestx_request, :expected_finish_date => nil)
      c.should_not be_valid
    end
    
    it "should reject nil request_content" do
      c = FactoryGirl.build(:task_requestx_request, :request_content => nil)
      c.should_not be_valid
    end
    
    it "should reject nil task_id" do
      c = FactoryGirl.build(:task_requestx_request, :task_id => nil)
      c.should_not be_valid
    end
    
    it "should reject 0 request_status_id" do
      c = FactoryGirl.build(:task_requestx_request, :request_status_id => 0)
      c.should_not be_valid
    end
    
    it "should reject nil name" do
      c = FactoryGirl.build(:task_requestx_request, :name=> nil)
      c.should_not be_valid
    end
    
    it "should reject duplicate name for the same task" do
      c1 = FactoryGirl.create(:task_requestx_request, :name=> 'nil')
      c = FactoryGirl.build(:task_requestx_request, :name=> 'Nil')
      c.should_not be_valid
    end
    
    it "should OK with duplicate name for 2 tasks" do
      c1 = FactoryGirl.create(:task_requestx_request, :name=> 'nil')
      c = FactoryGirl.build(:task_requestx_request, :name=> 'nil', :task_id => c1.task_id + 1)
      c.should be_valid
    end
  end
end
