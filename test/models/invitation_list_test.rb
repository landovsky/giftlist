require "test_helper"

describe InvitationList do
  let(:invitation_list) { InvitationList.new }

  it "must be valid" do
    value(invitation_list).must_be :valid?
  end
end
