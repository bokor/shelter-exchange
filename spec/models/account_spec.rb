
  # context "Nested Attributes" do

  #   it "accepts nested attributes for comments" do
  #     Placement.count.should == 0
  #     Comment.count.should   == 0

  #     Placement.gen :comments_attributes => [{:comment => "placement comment"}]

  #     Placement.count.should == 1
  #     Comment.count.should   == 1
  #   end

  #   it "should reject nested attributes for comments" do
  #     Placement.count.should == 0
  #     Comment.count.should   == 0

  #     Placement.gen :comments_attributes => [{:comment => nil}]

  #     Placement.count.should == 1
  #     Comment.count.should   == 0
  #   end

  #   it "should destroy nested comments" do
  #     placement = Placement.gen :comments_attributes => [{:comment => "destroy comment"}]

  #     Placement.count.should == 1
  #     Comment.count.should   == 1

  #     placement.destroy

  #     Placement.count.should == 0
  #     Comment.count.should   == 0
  #   end
  # end
